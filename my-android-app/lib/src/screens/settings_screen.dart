import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../theme/app_theme.dart';
import '../widgets/app_back_button.dart';
import '../services/theme_provider.dart';
import '../services/bike_provider.dart';
import '../services/reminder_provider.dart';
import '../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  DateTime? _mutedUntil;

  @override
  void initState() {
    super.initState();
    _loadMuteState();
  }

  Future<void> _loadMuteState() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt('notifications_muted_until');
    if (!mounted) return;
    setState(() {
      if (ms == null) {
        _mutedUntil = null;
        return;
      }
      final until = DateTime.fromMillisecondsSinceEpoch(ms);
      _mutedUntil = until.isAfter(DateTime.now()) ? until : null;
    });
  }

  Future<void> _setMute(Duration duration) async {
    final prefs = await SharedPreferences.getInstance();
    final until = DateTime.now().add(duration);
    await prefs.setInt('notifications_muted_until', until.millisecondsSinceEpoch);
    await NotificationService().cancelOverdueNotification();
    await _loadMuteState();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notifications muted until ${until.toLocal()}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _unmute() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notifications_muted_until');
    await NotificationService().scheduleDailyOverdueReminder(
      reminders: Provider.of<ReminderProvider>(context, listen: false).reminders,
      bikes: Provider.of<BikeProvider>(context, listen: false).bikes,
    );
    await _loadMuteState();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notifications unmuted'), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _sendTestNotification() async {
    try {
      await Permission.notification.request();
    } catch (_) {}
    await NotificationService().showTestNotification();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test notification sent'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final topInset = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    final mutedUntil = _mutedUntil;
    final muteSubtitle = mutedUntil == null
        ? 'Notifications are on'
        : 'Muted until ${mutedUntil.toLocal()}';

    Widget sectionCard({
      required IconData icon,
      required String title,
      String? subtitle,
      required List<Widget> children,
    }) {
      return Card(
        elevation: 0,
        color: colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: colorScheme.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (subtitle != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              subtitle,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...children,
            ],
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        final router = GoRouter.of(context);
        if (router.canPop()) {
          router.pop();
          return;
        }
        router.go('/home');
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.w900)),
          leading: AppBackButton(
            color: Colors.white,
          ),
        ),
        body: Stack(
          children: [
            Container(
              height: topInset + 220,
              decoration: BoxDecoration(
                gradient: AppTheme.headerGradient(context),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                boxShadow: AppTheme.softShadow,
              ),
            ),
            ListView(
              padding: EdgeInsets.fromLTRB(16, topInset + 130, 16, bottomInset + 24),
              children: [
              sectionCard(
                icon: Icons.notifications_rounded,
                title: 'Notifications',
                subtitle: muteSubtitle,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      if (mutedUntil != null)
                        FilledButton.tonalIcon(
                          onPressed: _unmute,
                          icon: const Icon(Icons.volume_up_rounded),
                          label: const Text('Unmute'),
                        ),
                      FilledButton.tonalIcon(
                        onPressed: () => _setMute(const Duration(days: 1)),
                        icon: const Icon(Icons.volume_off_rounded),
                        label: const Text('1 day'),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () => _setMute(const Duration(days: 7)),
                        icon: const Icon(Icons.volume_off_rounded),
                        label: const Text('1 week'),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () => _setMute(const Duration(days: 30)),
                        icon: const Icon(Icons.volume_off_rounded),
                        label: const Text('1 month'),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: _sendTestNotification,
                        icon: const Icon(Icons.notifications_active_rounded),
                        label: const Text('Test notification'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              sectionCard(
                icon: Icons.palette_rounded,
                title: 'Appearance',
                subtitle: 'Theme mode',
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Theme',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      DropdownButton<ThemeMode>(
                        value: themeProvider.themeMode,
                        onChanged: (ThemeMode? newValue) {
                          if (newValue != null) {
                            themeProvider.setThemeMode(newValue);
                          }
                        },
                        items: const [
                          DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                          DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                          DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              sectionCard(
                icon: Icons.share_rounded,
                title: 'Share & Rate',
                subtitle: 'Help us grow',
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.share_rounded, color: colorScheme.primary),
                    title: const Text('Share the app'),
                    subtitle: const Text('Share RideFixer with friends'),
                    onTap: () async {
                      const appId = 'com.example.ride_care';
                      const playStoreUrl = 'https://play.google.com/store/apps/details?id=$appId';
                      await Share.share(
                        'RideFixer helps e-bike riders understand display error codes and adjust P-settings (P1, P2, etc.) quickly. '
                        'Share it with your riding group: $playStoreUrl',
                      );
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.star_rate_rounded, color: colorScheme.primary),
                    title: const Text('Rate us'),
                    subtitle: const Text('Rate RideFixer on Play Store'),
                    onTap: () async {
                      const appId = 'com.example.ride_care';
                      try {
                        final marketUri = Uri.parse('market://details?id=$appId');
                        if (await canLaunchUrl(marketUri)) {
                          await launchUrl(marketUri, mode: LaunchMode.externalApplication);
                          return;
                        }
                        final webUri = Uri.parse('https://play.google.com/store/apps/details?id=$appId');
                        await launchUrl(webUri, mode: LaunchMode.externalApplication);
                      } catch (_) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Could not open Play Store'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              sectionCard(
                icon: Icons.info_outline_rounded,
                title: 'About',
                subtitle: 'RideFixer',
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('About RideFixer'),
                    subtitle: FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        final version = snapshot.data?.version ?? '...';
                        return Text('Version $version');
                      },
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/about'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }
}
