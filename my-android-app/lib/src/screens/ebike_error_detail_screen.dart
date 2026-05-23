import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/ebike_errors/brand_error_catalog.dart';
import '../features/ebike_errors/ebike_error_model.dart';
import '../theme/app_theme.dart';
import '../widgets/app_back_button.dart';

enum _ExitPromptAction { close, snoozeWeek, share }

class EbikeErrorDetailScreen extends StatelessWidget {
  final String code;
  final String brand;
  final String? modelId;

  static const String _appId = 'com.example.ride_care';
  static const String _playStoreUrl = 'https://play.google.com/store/apps/details?id=$_appId';
  static const String _shareText =
      'RideFixer helps e-bike riders understand display error codes and adjust P-settings (P1, P2, etc.) quickly. '
      'Share it with your riding group: $_playStoreUrl';
  static const String _sharePromptSnoozeUntilKey = 'share_prompt_snooze_until_ms';

  const EbikeErrorDetailScreen({super.key, required this.code, required this.brand, this.modelId});

  Future<bool> _isSharePromptSnoozed() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;
    final snoozeUntil = prefs.getInt(_sharePromptSnoozeUntilKey) ?? 0;
    return now < snoozeUntil;
  }

  Future<void> _snoozeSharePromptOneWeek() async {
    final prefs = await SharedPreferences.getInstance();
    final snoozeUntil = DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch;
    await prefs.setInt(_sharePromptSnoozeUntilKey, snoozeUntil);
  }

  Future<void> _performBack(BuildContext context) async {
    final router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
      return;
    }
    router.go('/home');
  }

  Future<_ExitPromptAction?> _showExitPromptDialog(BuildContext context) {
    return showDialog<_ExitPromptAction>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final scheme = theme.colorScheme;

        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: scheme.outlineVariant.withOpacity(0.55)),
              boxShadow: [
                BoxShadow(
                  color: scheme.shadow.withOpacity(0.16),
                  blurRadius: 30,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: AppTheme.headerGradient(ctx),
                        ),
                        child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Before you leave',
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Found this error guide useful? Share RideFixer with other riders.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.45,
                      color: scheme.onSurface.withOpacity(0.84),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => Navigator.of(ctx).pop(_ExitPromptAction.share),
                      icon: const Icon(Icons.ios_share_rounded),
                      label: const Text('Share'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(_ExitPromptAction.snoozeWeek),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: scheme.outline.withOpacity(0.55)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      child: const Text("Don't show for 1 week"),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () => Navigator.of(ctx).pop(_ExitPromptAction.close),
                      style: TextButton.styleFrom(foregroundColor: scheme.onSurface.withOpacity(0.75)),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleExitAttempt(BuildContext context) async {
    if (await _isSharePromptSnoozed()) {
      if (context.mounted) {
        await _performBack(context);
      }
      return;
    }

    final action = await _showExitPromptDialog(context);
    if (!context.mounted) return;
    if (action == null) return;

    if (action == _ExitPromptAction.share) {
      await Share.share(_shareText);
      if (!context.mounted) return;
      await _performBack(context);
      return;
    }

    if (action == _ExitPromptAction.snoozeWeek) {
      await _snoozeSharePromptOneWeek();
    }

    if (!context.mounted) return;
    await _performBack(context);
  }

  @override
  Widget build(BuildContext context) {
    final info = BrandErrorCatalog.findByCodeAndBrand(code, brand, modelId: modelId);
    final bottomPad = MediaQuery.of(context).padding.bottom + 24;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (info == null) {
      return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) return;
          _handleExitAttempt(context);
        },
        child: Scaffold(
          backgroundColor: colorScheme.background,
          body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBackButton(
                  onPressed: () => _handleExitAttempt(context),
                ),
                const SizedBox(height: 12),
                Text(
                  'Code not in catalog',
                  style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'RideFixer doesn\'t have verified details for "$code" yet. Please check your bike manual, or request this code so we can add it correctly.',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => context.push('/feature-request'),
                  icon: const Icon(Icons.add_comment_outlined),
                  label: const Text('Request this code'),
                ),
              ],
            ),
          ),
        ),
        ),
      );
    }

    final severityColor = _severityColor(colorScheme, info.severity);
    final rideabilityColor = _rideabilityColor(colorScheme, info.rideability);
    final urgencyColor = _urgencyColor(colorScheme, info.urgency);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _handleExitAttempt(context);
      },
      child: Scaffold(
      backgroundColor: colorScheme.background,
      body: Stack(
        children: [
          Container(
            height: 260,
            decoration: BoxDecoration(
                gradient: AppTheme.headerGradient(context),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              boxShadow: AppTheme.softShadow,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppBackButton(
                        color: Colors.white,
                        onPressed: () => _handleExitAttempt(context),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Error $code',
                          style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await _copySummary(context, info);
                        },
                        icon: const Icon(Icons.copy_outlined, color: Colors.white),
                        tooltip: 'Copy',
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    info.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      _pill(
                        icon: info.severityIcon(),
                        label: _severityLabel(info.severity),
                        bg: severityColor.withOpacity(0.18),
                        fg: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      _pill(
                        icon: info.rideabilityIcon(),
                        label: info.rideabilityLabel(),
                        bg: rideabilityColor.withOpacity(0.18),
                        fg: Colors.white,
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  _card(
                    context,
                    title: 'What this error means',
                    icon: Icons.help_outline,
                    child: Text(
                      info.whatItMeans,
                      style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.5,
                            color: colorScheme.onSurface.withOpacity(0.85),
                          ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  _ExpandableCard(
                    title: 'Can I go home with this error?',
                    icon: info.rideabilityIcon(),
                    iconColor: rideabilityColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          info.rideabilityLabel(),
                          style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: colorScheme.onSurface,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          info.rideabilityGuidance,
                          style: theme.textTheme.bodyLarge?.copyWith(
                                height: 1.5,
                                color: colorScheme.onSurface.withOpacity(0.85),
                              ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  _ExpandableCard(
                    title: 'Should I go to a shop immediately?',
                    icon: info.urgencyIcon(),
                    iconColor: urgencyColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          info.urgencyLabel(),
                          style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: colorScheme.onSurface,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          info.urgencyGuidance,
                          style: theme.textTheme.bodyLarge?.copyWith(
                                height: 1.5,
                                color: colorScheme.onSurface.withOpacity(0.85),
                              ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  _ExpandableCard(
                    title: 'Common causes',
                    icon: Icons.bolt,
                    child: _bullets(context, info.commonCauses),
                  ),

                  const SizedBox(height: 12),

                  _ExpandableCard(
                    title: 'Symptoms you may notice',
                    icon: Icons.visibility_outlined,
                    child: _bullets(context, info.commonSymptoms),
                  ),

                  const SizedBox(height: 12),

                  _ExpandableCard(
                    title: 'How to fix',
                    icon: Icons.build_outlined,
                    child: _numbered(context, info.howToFix),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  static Widget _pill({
    required IconData icon,
    required String label,
    required Color bg,
    required Color fg,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: fg, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: fg, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  static String _severityLabel(EbikeSeverity s) {
    switch (s) {
      case EbikeSeverity.high:
        return 'High severity';
      case EbikeSeverity.medium:
        return 'Medium severity';
      case EbikeSeverity.low:
        return 'Low severity';
    }
  }

  static Widget _card(
    BuildContext context, {
    required String title,
    required IconData icon,
    Color? iconColor,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.10),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (iconColor ?? colorScheme.primary).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor ?? colorScheme.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  static Widget _bullets(BuildContext context, List<String> items) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      children: items
          .map(
            (s) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•  ', style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
                  Expanded(
                    child: Text(
                      s,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                        color: colorScheme.onSurface.withOpacity(0.85),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  static Widget _numbered(BuildContext context, List<String> items) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      children: List.generate(items.length, (i) {
        final s = items[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${i + 1}',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  s,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                    color: colorScheme.onSurface.withOpacity(0.85),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  static Color _severityColor(ColorScheme scheme, EbikeSeverity s) {
    return switch (s) {
      EbikeSeverity.high => scheme.error,
      EbikeSeverity.medium => scheme.tertiary,
      EbikeSeverity.low => scheme.secondary,
    };
  }

  static Color _rideabilityColor(ColorScheme scheme, Rideability r) {
    return switch (r) {
      Rideability.stop => scheme.error,
      Rideability.caution => scheme.tertiary,
      Rideability.ok => scheme.secondary,
    };
  }

  static Color _urgencyColor(ColorScheme scheme, ServiceUrgency u) {
    return switch (u) {
      ServiceUrgency.immediate => scheme.error,
      ServiceUrgency.soon => scheme.tertiary,
      ServiceUrgency.info => scheme.primary,
    };
  }

  static Future<void> _copySummary(BuildContext context, EbikeErrorInfo info) async {
    final text = StringBuffer()
      ..writeln('${info.code} — ${info.title}')
      ..writeln(info.description)
      ..writeln('')
      ..writeln('Can I ride home? ${info.rideabilityLabel()}')
      ..writeln(info.rideabilityGuidance)
      ..writeln('')
      ..writeln('Suggested fix:')
      ..writeln(info.howToFix.map((e) => '- $e').join('\n'));

    await Clipboard.setData(ClipboardData(text: text.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }
}

class _ExpandableCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final Widget child;

  const _ExpandableCard({
    required this.title,
    required this.icon,
    this.iconColor,
    required this.child,
  });

  @override
  State<_ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<_ExpandableCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.10),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.6)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (widget.iconColor ?? colorScheme.primary).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.iconColor ?? colorScheme.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: colorScheme.primary,
                      size: 28,
                    ),
                  ],
                ),
                if (_isExpanded) ...[
                  const SizedBox(height: 12),
                  widget.child,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
