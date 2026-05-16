import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Shows a Google Play-compliant prominent disclosure dialog before any
/// location permission is requested. Returns true if the user tapped Continue,
/// false if they dismissed without consent.
Future<bool> showLocationDisclosure(
  BuildContext context, {
  /// Pass true for the ride-tracking disclosure (GPS + foreground service),
  /// false for the nearby-shops disclosure (one-time position lookup).
  bool forRideTracking = false,
}) async {
  // Only show once — track per use-case so each has its own flag.
  final key = forRideTracking
      ? 'location_disclosure_ride_v1'
      : 'location_disclosure_shops_v1';

  final prefs = await SharedPreferences.getInstance();
  final alreadyShown = prefs.getBool(key) ?? false;
  if (alreadyShown) return true;

  if (!context.mounted) return false;

  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _LocationDisclosureDialog(
      forRideTracking: forRideTracking,
    ),
  );

  final accepted = result == true;
  if (accepted) {
    await prefs.setBool(key, true);
  }
  return accepted;
}

class _LocationDisclosureDialog extends StatelessWidget {
  final bool forRideTracking;
  const _LocationDisclosureDialog({required this.forRideTracking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final title = forRideTracking
        ? 'GPS Access Required'
        : 'Location Access Required';

    final body = forRideTracking
        ? '''RideFixer uses your GPS location to record ride distance while tracking is active.

• Location is accessed only while the ride tracking session is running.
• A foreground notification will be visible while tracking is active.
• Your location data is stored only on your device and is never shared with third parties.
• You can stop tracking at any time from the home screen.'''
        : '''RideFixer uses your location to find nearby e-bike service shops and dealers in your area.

• Your location is used only to perform a one-time search for nearby shops.
• Location data is not stored, uploaded, or shared with any third parties.
• You can always search manually if you prefer not to share your location.''';

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(
            forRideTracking ? Icons.gps_fixed : Icons.location_on_outlined,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(body, style: const TextStyle(height: 1.5)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.privacy_tip_outlined,
                      size: 16, color: theme.colorScheme.secondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your location data is never shared with third parties.',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('No Thanks'),
        ),
        FilledButton.icon(
          icon: const Icon(Icons.check_circle_outline, size: 18),
          label: const Text('Continue'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
