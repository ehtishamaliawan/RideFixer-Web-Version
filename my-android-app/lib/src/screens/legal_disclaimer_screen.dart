import 'package:flutter/material.dart';

class LegalDisclaimerScreen extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const LegalDisclaimerScreen({
    super.key,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.policy_outlined, color: colorScheme.primary, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Before you continue',
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'RideFixer provides general guidance only. Always follow your bike manufacturer\'s manual and use a qualified technician when needed.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.4,
                  color: colorScheme.onSurface.withOpacity(0.85),
                ),
              ),
              const SizedBox(height: 16),
              _Bullet(
                text: 'Information may be incomplete or differ by brand, model, firmware, and year.',
              ),
              _Bullet(
                text: 'Do not rely on the app as a substitute for professional diagnosis.',
              ),
              _Bullet(
                text: 'If you do not agree, you must close the app.',
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onDecline,
                      child: const Text('Decline & close'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: onAccept,
                      child: const Text('I accept'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'You\'ll be asked again until you accept.',
                style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•  ', style: theme.textTheme.bodyLarge),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.4,
                color: colorScheme.onSurface.withOpacity(0.85),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
