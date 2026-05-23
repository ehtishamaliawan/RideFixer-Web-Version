import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/app_back_button.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom + 100;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Future<void> handleBack() async {
      final router = GoRouter.of(context);
      if (router.canPop()) {
        router.pop();
        return;
      }
      router.go('/home');
    }

    Future<void> shareApp() async {
      const appId = 'com.example.ride_care';
      const playStoreUrl = 'https://play.google.com/store/apps/details?id=$appId';
      await Share.share(
        'RideFixer helps e-bike riders understand display error codes and adjust P-settings (P1, P2, etc.) quickly. '
        'Share it with your riding group: $playStoreUrl',
      );
    }

    Future<void> rateApp() async {
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
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        handleBack();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            'About',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          leading: AppBackButton(
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        body: Stack(
          children: [
          // Gradient Header
          Container(
            height: 360,
            decoration: BoxDecoration(
                gradient: AppTheme.headerGradient(context),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              boxShadow: AppTheme.softShadow,
            ),
          ),

          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: bottomPad),
            child: Column(
              children: [
                const SizedBox(height: 120),

                // App Icon/Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: AppTheme.accentGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.pedal_bike,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'RideFixer',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      final version = snapshot.data?.version ?? '...';
                      return Text(
                        'Version $version',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 40),

                // Info Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.6)),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 48,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Your Bike Maintenance Companion',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Track your bike\'s parts, know what\'s due, and never miss maintenance again. Add bikes, get reminders, and find nearby repair shops when you need them.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '© ${DateTime.now().year} RideFixer',
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant.withOpacity(0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Share and Rate options
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.6)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.shield_outlined, color: colorScheme.primary),
                        title: const Text('Privacy Policy'),
                        subtitle: const Text('How we handle your data'),
                        onTap: () => context.go('/privacy-policy'),
                      ),
                      Divider(height: 1, color: colorScheme.outlineVariant.withOpacity(0.5)),
                      ListTile(
                        leading: Icon(Icons.share_rounded, color: colorScheme.primary),
                        title: const Text('Share the app'),
                        subtitle: const Text('Share RideFixer with friends'),
                        onTap: shareApp,
                      ),
                      Divider(height: 1, color: colorScheme.outlineVariant.withOpacity(0.5)),
                      ListTile(
                        leading: Icon(Icons.star_rate_rounded, color: colorScheme.primary),
                        title: const Text('Rate us'),
                        subtitle: const Text('Rate RideFixer on Play Store'),
                        onTap: rateApp,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }
}
