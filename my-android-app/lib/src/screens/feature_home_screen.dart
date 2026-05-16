import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class FeatureHomeScreen extends StatefulWidget {
  const FeatureHomeScreen({super.key});

  @override
  State<FeatureHomeScreen> createState() => _FeatureHomeScreenState();
}

class _FeatureHomeScreenState extends State<FeatureHomeScreen> {
  Future<void> _shareApp() async {
    const appId = 'com.example.ride_care';
    const playStoreUrl = 'https://play.google.com/store/apps/details?id=$appId';
    await Share.share(
      'RideFixer helps e-bike riders understand display error codes and adjust P-settings (P1, P2, etc.) quickly. '
      'Share it with your riding group: $playStoreUrl',
    );
  }

  Widget _headerIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      label: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }

  void _openHomeMenu() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.86,
      ),
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (ctx) {
        final scheme = Theme.of(ctx).colorScheme;
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24), bottom: Radius.circular(24)),
              gradient: isDark
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        scheme.surface.withOpacity(0.96),
                        scheme.surface.withOpacity(0.82),
                      ],
                    )
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        scheme.surface,
                        scheme.surfaceVariant.withOpacity(0.7),
                      ],
                    ),
              border: Border.all(color: scheme.outlineVariant.withOpacity(0.6)),
              boxShadow: AppTheme.softShadow,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: AppTheme.headerGradient(ctx),
                          ),
                          child: const Icon(Icons.menu_rounded, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Quick menu',
                            style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _MenuTile(
                      icon: Icons.settings,
                      title: 'Settings',
                      onTap: () {
                        Navigator.of(ctx).pop();
                        context.go('/settings');
                      },
                    ),
                    _MenuTile(
                      icon: Icons.store,
                      title: 'Nearby shops',
                      onTap: () {
                        Navigator.of(ctx).pop();
                        context.go('/shops');
                      },
                    ),
                    _MenuTile(
                      icon: Icons.electrical_services,
                      title: 'E-Bike Error Codes',
                      onTap: () {
                        Navigator.of(ctx).pop();
                        context.go('/ebike-errors');
                      },
                    ),
                    _MenuTile(
                      icon: Icons.tune_rounded,
                      title: 'E-Bike Settings',
                      onTap: () {
                        Navigator.of(ctx).pop();
                        context.go('/ebike-settings');
                      },
                    ),
                    _MenuTile(
                      icon: Icons.hearing_rounded,
                      title: 'Motor Noise Diagnostic',
                      onTap: () {
                        Navigator.of(ctx).pop();
                        context.go('/motor-noise-diagnostic');
                      },
                    ),
                    _MenuTile(
                      icon: Icons.battery_charging_full_rounded,
                      title: 'Battery Health Calculator',
                      onTap: () {
                        Navigator.of(ctx).pop();
                        context.go('/battery-health-calculator');
                      },
                    ),
                    _MenuTile(
                      icon: Icons.lightbulb_outline_rounded,
                      title: 'Feature Requests',
                      onTap: () {
                        Navigator.of(ctx).pop();
                        context.go('/feature-request');
                      },
                    ),
                    _MenuTile(
                      icon: Icons.share_rounded,
                      title: 'Share the app',
                      onTap: () async {
                        Navigator.of(ctx).pop();
                        await _shareApp();
                      },
                    ),
                    _MenuTile(
                      icon: Icons.star_rate_rounded,
                      title: 'Rate us',
                      onTap: () async {
                        Navigator.of(ctx).pop();
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
                    _MenuTile(
                      icon: Icons.info_outline,
                      title: 'About',
                      onTap: () {
                        Navigator.of(ctx).pop();
                        context.go('/about');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPad = MediaQuery.of(context).padding.bottom + 140;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: ListView(
        padding: EdgeInsets.only(bottom: bottomPad),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
            decoration: BoxDecoration(
              gradient: AppTheme.headerGradient(context),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C63FF).withOpacity(0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _headerIconButton(
                      icon: Icons.sort,
                      tooltip: 'Menu',
                      onTap: _openHomeMenu,
                    ),
                    Row(
                      children: [
                        _headerIconButton(
                          icon: Icons.settings_rounded,
                          tooltip: 'App settings',
                          onTap: () => context.go('/settings'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.pedal_bike_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RideFixer',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your bike maintenance companion',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _FeatureCard(
                        icon: Icons.directions_bike_rounded,
                        label: 'My Garage',
                        subtitle: 'Manage bikes and maintenance',
                        onTap: () => context.go('/garage'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _FeatureCard(
                        icon: Icons.electrical_services,
                        label: 'E‑Bike Errors',
                        subtitle: 'Error codes & fixes',
                        onTap: () => context.go('/ebike-errors'),
                        accent: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _FeatureCard(
                        icon: Icons.tune_rounded,
                        label: 'E‑Bike Settings',
                        subtitle: 'P-settings explained',
                        onTap: () => context.go('/ebike-settings'),
                        accent: Colors.deepPurpleAccent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _FeatureCard(
                        icon: Icons.hearing_rounded,
                        label: 'Motor Noise',
                        subtitle: 'Listen and match sounds',
                        onTap: () => context.go('/motor-noise-diagnostic'),
                        accent: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _FeatureCard(
                        icon: Icons.battery_charging_full_rounded,
                        label: 'Battery Health',
                        subtitle: 'Estimate life and tips',
                        onTap: () => context.go('/battery-health-calculator'),
                        accent: Colors.teal,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _FeatureCard(
                        icon: Icons.chat_bubble_outline,
                        label: 'Feature Request',
                        subtitle: 'Suggest improvements',
                        onTap: () => context.push('/feature-request'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _FeatureCard(
                        icon: Icons.store_mall_directory_rounded,
                        label: 'Shops',
                        subtitle: 'Nearby vendors',
                        onTap: () => context.go('/shops'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _FeatureCard(
                        icon: Icons.share_rounded,
                        label: 'Share App',
                        subtitle: 'Share with friends',
                        onTap: _shareApp,
                        accent: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _FeatureCard(
                        icon: Icons.star_rate_rounded,
                        label: 'Rate Us',
                        subtitle: 'Rate on Play Store',
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
                        accent: Colors.amber,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _FeatureCard(
                        icon: Icons.info_outline,
                        label: 'About',
                        subtitle: 'App info & help',
                        onTap: () => context.go('/about'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final Color? accent;

  const _FeatureCard({required this.icon, required this.label, required this.subtitle, required this.onTap, this.accent});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = accent ?? const Color(0xFF6C63FF);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 176,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.6)),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : accentColor.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: accentColor, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 34,
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuTile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: scheme.surface.withOpacity(0.85),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: scheme.outlineVariant.withOpacity(0.6)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: scheme.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: scheme.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
