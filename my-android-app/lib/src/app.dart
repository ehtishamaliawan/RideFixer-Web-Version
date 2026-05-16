import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'theme/app_theme.dart';
import 'services/bike_provider.dart';
import 'services/reminder_provider.dart';
import 'services/theme_provider.dart';
import 'screens/scaffold_with_navbar.dart';
import 'screens/home_screen.dart';
import 'screens/feature_home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/ebike_brand_selection_screen.dart';
import 'screens/ebike_error_screen.dart';
import 'screens/ebike_error_detail_screen.dart';
import 'screens/bike_list_screen.dart';
import 'screens/nearby_shops_screen.dart';
import 'screens/about_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/feature_request_screen.dart';
import 'screens/legal_disclaimer_screen.dart';
import 'screens/ebike_generic_model_screen.dart';
import 'screens/motor_noise_diagnostic_screen.dart';
import 'screens/battery_health_calculator_screen.dart';
import 'screens/ebike_settings_brand_selection_screen.dart';
import 'screens/ebike_settings_screen.dart';
import 'screens/ebike_setting_detail_screen.dart';
import 'services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

// Placeholders for other screens
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen(this.title, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(child: Text(title)),
  );
}

class RideFixerApp extends StatefulWidget {
  const RideFixerApp({super.key});

  @override
  State<RideFixerApp> createState() => _RideFixerAppState();
}

class _RideFixerAppState extends State<RideFixerApp> {
  bool _isInitialized = false;
  bool _hasAcceptedDisclaimer = false;
  bool _disclaimerChecked = false;

  static const String _disclaimerKey = 'legal_disclaimer_accepted_v1';

  Future<void> _loadDisclaimerAcceptance() async {
    final prefs = await SharedPreferences.getInstance();
    final accepted = prefs.getBool(_disclaimerKey) ?? false;
    if (!mounted) return;
    setState(() {
      _hasAcceptedDisclaimer = accepted;
      _disclaimerChecked = true;
    });
  }

  Future<void> _acceptDisclaimer() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_disclaimerKey, true);
    if (!mounted) return;
    setState(() {
      _hasAcceptedDisclaimer = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: themeProvider.themeMode,
            home: SplashScreen(
              onInitComplete: () {
                setState(() {
                  _isInitialized = true;
                });
                _loadDisclaimerAcceptance();
              },
            ),
          );
        },
      );
    }

    if (!_disclaimerChecked) {
      return Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: themeProvider.themeMode,
            home: const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        },
      );
    }

    if (!_hasAcceptedDisclaimer) {
      return Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: themeProvider.themeMode,
            home: LegalDisclaimerScreen(
              onAccept: _acceptDisclaimer,
              onDecline: () => SystemNavigator.pop(),
            ),
          );
        },
      );
    }

    final rootNavigatorKey = GlobalKey<NavigatorState>();

    final GoRouter router = GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: '/home',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return ScaffoldWithNavBar(navigationShell: navigationShell);
          },
          branches: [
            // Home / feature hub
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  builder: (context, state) => const FeatureHomeScreen(),
                ),
                // Feature Request (keep bottom navbar visible)
                GoRoute(
                  path: '/feature-request',
                  builder: (context, state) {
                    final title = state.uri.queryParameters['title'];
                    final description = state.uri.queryParameters['description'];
                    return FeatureRequestScreen(initialTitle: title, initialDescription: description);
                  },
                ),
                GoRoute(
                  path: '/settings',
                  builder: (context, state) => const SettingsScreen(),
                ),
                GoRoute(
                  path: '/about',
                  builder: (context, state) => const AboutScreen(),
                ),
                GoRoute(
                  path: '/motor-noise-diagnostic',
                  builder: (context, state) => const MotorNoiseDiagnosticScreen(),
                ),
                GoRoute(
                  path: '/battery-health-calculator',
                  builder: (context, state) => const BatteryHealthCalculatorScreen(),
                ),
                GoRoute(
                  path: '/privacy-policy',
                  builder: (context, state) => const PrivacyPolicyScreen(),
                ),
              ],
            ),
            // Garage (bike list)
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/garage',
                  builder: (context, state) => const BikeListScreen(),
                  routes: [
                    GoRoute(
                      path: 'dashboard/:bikeId',
                      builder: (context, state) {
                        final bikeId =
                            int.tryParse(
                              state.pathParameters['bikeId'] ?? '',
                            ) ??
                            0;
                        return HomeScreen(bikeId: bikeId);
                      },
                    ),
                  ],
                ),
              ],
            ),
            // E-Bike Errors
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/ebike-errors',
                  builder: (context, state) => const EbikeBrandSelectionScreen(),
                  routes: [
                    GoRoute(
                      path: 'generic/models',
                      builder: (context, state) => const EbikeGenericModelScreen(),
                    ),
                    GoRoute(
                      path: ':brand',
                      builder: (context, state) {
                        final brand = state.pathParameters['brand'] ?? 'generic';
                        final model = state.uri.queryParameters['model'];
                        return EbikeErrorScreen(brand: brand, modelId: model);
                      },
                      routes: [
                        GoRoute(
                          path: 'detail/:code',
                          builder: (context, state) {
                            final brand = state.pathParameters['brand'] ?? 'generic';
                            final code = (state.pathParameters['code'] ?? '').trim();
                            final model = state.uri.queryParameters['model'];
                            return EbikeErrorDetailScreen(code: code, brand: brand, modelId: model);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            // E-Bike Settings
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/ebike-settings',
                  builder: (context, state) => const EbikeGenericModelScreen(
                    onSelectBasePath: '/ebike-settings/generic',
                  ),
                  routes: [
                    GoRoute(
                      path: 'generic/models',
                      builder: (context, state) => const EbikeGenericModelScreen(
                        onSelectBasePath: '/ebike-settings/generic',
                      ),
                    ),
                    GoRoute(
                      path: ':brand',
                      builder: (context, state) {
                        final brand = state.pathParameters['brand'] ?? 'generic';
                        final model = state.uri.queryParameters['model'];
                        return EbikeSettingsScreen(brand: brand, modelId: model);
                      },
                      routes: [
                        GoRoute(
                          path: 'detail/:code',
                          builder: (context, state) {
                            final brand = state.pathParameters['brand'] ?? 'generic';
                            final code = (state.pathParameters['code'] ?? '').trim();
                            final model = state.uri.queryParameters['model'];
                            return EbikeSettingDetailScreen(code: code, brand: brand, modelId: model);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            // Shops
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/shops',
                  builder: (context, state) => const NearbyShopsScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    );

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return _NotificationCoordinator(
          child: MaterialApp.router(
            title: 'RideFixer',
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: themeProvider.themeMode,
            routerConfig: router,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}

/// Listens for changes to bikes/reminders and schedules a single daily overdue notification.
class _NotificationCoordinator extends StatefulWidget {
  final Widget child;
  const _NotificationCoordinator({required this.child});

  @override
  State<_NotificationCoordinator> createState() =>
      _NotificationCoordinatorState();
}

class _NotificationCoordinatorState extends State<_NotificationCoordinator> {
  final NotificationService _notificationService = NotificationService();

  static const String _startupPermsKey = 'startup_permissions_prompted_v1';

  @override
  void initState() {
    super.initState();
    _notificationService.init();
    _requestStartupPermissionsOnce();
  }

  Future<void> _requestStartupPermissionsOnce() async {
    if (!Platform.isAndroid) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final already = prefs.getBool(_startupPermsKey) ?? false;
      if (already) return;
      await prefs.setBool(_startupPermsKey, true);
    } catch (_) {
      // If prefs fails, still attempt requesting once per session.
    }

    try {
      await [
        Permission.notification,
      ].request();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final bikeProvider = context.watch<BikeProvider>();
    final bikes = bikeProvider.bikes;
    final reminders = context.watch<ReminderProvider>().reminders;

    // Show a lightweight splash while bikes are loading to engage the user.
    // Wrap in a minimal MaterialApp so Directionality and theme are available.
    if (bikeProvider.loading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(),
        home: const LoadingSplash(),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      () async {
        try {
          final prefs = await SharedPreferences.getInstance();
          final mutedUntilMs = prefs.getInt('notifications_muted_until');
          if (mutedUntilMs != null) {
            final until = DateTime.fromMillisecondsSinceEpoch(mutedUntilMs);
            if (DateTime.now().isBefore(until)) {
              // Respect mute: cancel any scheduled overdue notification.
              await _notificationService.cancelOverdueNotification();
              return;
            }
          }
        } catch (_) {}

        await _notificationService.scheduleDailyOverdueReminder(
          reminders: reminders,
          bikes: bikes,
        );
      }();
      // Handle notification taps that include a payload like "track:bikeId=123"
      final payload = _notificationService.consumeLastPayload();
      if (payload != null && payload.startsWith('track:bikeId=')) {
        final parts = payload.split('=');
        final id = int.tryParse(parts.length > 1 ? parts[1] : '') ?? 0;
        if (id > 0) {
          // Wait briefly for bikes to load in provider so the dashboard
          // receives a real Bike instance (not the placeholder), then navigate.
          () async {
            final provider = context.read<BikeProvider>();
            // Poll for up to 5 seconds for the bike to appear
            var found = provider.bikes.any((b) => b.id == id);
            var attempts = 0;
            while (!found && attempts < 50) {
              await Future.delayed(const Duration(milliseconds: 100));
              found = provider.bikes.any((b) => b.id == id);
              attempts++;
            }
            // Navigate regardless; if bike isn't loaded we still attempt route
            context.go('/garage/dashboard/$id');
          }();
        }
      }
    });

    return widget.child;
  }
}

class LoadingSplash extends StatefulWidget {
  const LoadingSplash({super.key});

  @override
  State<LoadingSplash> createState() => _LoadingSplashState();
}

class _LoadingSplashState extends State<LoadingSplash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.lightTheme();
    return Material(
      child: Scaffold(
        backgroundColor: theme.colorScheme.primary,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _ctrl,
                builder: (context, child) {
                  final angle = _ctrl.value * 2 * pi;
                  final scale = 0.95 + 0.1 * sin(_ctrl.value * 2 * pi);
                  return Transform.rotate(
                    angle: angle,
                    child: Transform.scale(scale: scale, child: child),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.pedal_bike_rounded,
                    size: 96,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
