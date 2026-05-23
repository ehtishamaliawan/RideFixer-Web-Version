import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/app_back_button.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPad = MediaQuery.of(context).padding.bottom + 80;

    Future<void> handleBack() async {
      final router = GoRouter.of(context);
      if (router.canPop()) {
        router.pop();
        return;
      }
      router.go('/home');
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
            'Privacy Policy',
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
            Container(
              height: 180,
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
              padding: EdgeInsets.only(
                  top: kToolbarHeight + 80, left: 16, right: 16, bottom: bottomPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _section(
                    theme,
                    icon: Icons.info_outline,
                    title: 'Introduction',
                    body:
                        'RideFixer ("we", "our", or "us") is an e-bike companion app that helps '
                        'riders identify error codes displayed on their e-bike dashboard, '
                        'adjust controller settings (P-settings), record ride distance, and find '
                        'nearby e-bike service shops. This Privacy Policy explains what data we '
                        'collect and how we use it.',
                  ),
                  _section(
                    theme,
                    icon: Icons.location_on_outlined,
                    title: 'Location Data',
                    body:
                        'RideFixer requests access to your device location for two purposes:\n\n'
                        '1. Ride Distance Tracking — When you start a ride, RideFixer uses GPS '
                        'to record the distance you travel. Location is accessed only while the '
                        'ride tracking session is active and a foreground notification is '
                        'visible. Tracking stops as soon as you end the ride.\n\n'
                        '2. Nearby Shops — When you use the "Nearby Shops" feature, RideFixer '
                        'reads your current location once to search for nearby e-bike service '
                        'shops using the OpenStreetMap Overpass API.\n\n'
                        'Your location data is processed on-device or sent only as coordinates '
                        'to the Overpass API to perform the shop search. It is never stored on '
                        'our servers, and never sold or shared with any third parties.',
                  ),
                  _section(
                    theme,
                    icon: Icons.camera_alt_outlined,
                    title: 'Camera',
                    body:
                        'RideFixer uses your camera to scan e-bike display labels for automatic '
                        'model detection. Captured images are processed entirely on-device using '
                        'Google ML Kit. No images are uploaded or stored.',
                  ),
                  _section(
                    theme,
                    icon: Icons.storage_outlined,
                    title: 'Data Storage',
                    body:
                        'All app data — including your bikes, ride history, reminders, and '
                        'settings — is stored locally on your device in a SQLite database. '
                        'We do not operate any cloud servers or databases that store your '
                        'personal information.',
                  ),
                  _section(
                    theme,
                    icon: Icons.notifications_none_outlined,
                    title: 'Notifications',
                    body:
                        'RideFixer may send local notifications for ride tracking status and '
                        'maintenance reminders you set. These are generated on-device and do '
                        'not involve any external servers.',
                  ),
                  _section(
                    theme,
                    icon: Icons.share_outlined,
                    title: 'Third-Party Services',
                    body:
                        'RideFixer uses the following third-party services:\n\n'
                        '• OpenStreetMap Overpass API — receives your GPS coordinates to return '
                        'nearby bicycle shops. See: openstreetmap.org/copyright\n\n'
                        '• Google ML Kit Text Recognition — on-device OCR for label scanning. '
                        'No data is sent to Google servers.',
                  ),
                  _section(
                    theme,
                    icon: Icons.child_care_outlined,
                    title: "Children's Privacy",
                    body:
                        'RideFixer is not directed at children under 13. We do not knowingly '
                        'collect personal data from children.',
                  ),
                  _section(
                    theme,
                    icon: Icons.update_outlined,
                    title: 'Changes to This Policy',
                    body:
                        'We may update this Privacy Policy from time to time. Changes will be '
                        'reflected in the app and on our policy web page. Continued use of the '
                        'app after changes constitutes acceptance of the updated policy.',
                  ),
                  _section(
                    theme,
                    icon: Icons.email_outlined,
                    title: 'Contact Us',
                    body:
                        'If you have any questions about this Privacy Policy, please contact '
                        'us at: ridefixer232@gmail.com',
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Last updated: March 2026',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
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

  Widget _section(ThemeData theme, {required IconData icon, required String title, required String body}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    )),
              ],
            ),
            const SizedBox(height: 10),
            Text(body, style: const TextStyle(height: 1.55)),
          ],
        ),
      ),
    );
  }
}
