import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/ebike_settings/settings_catalog.dart';
import '../theme/app_theme.dart';
import '../widgets/app_back_button.dart';

enum _ExitPromptAction { close, snoozeWeek, share }

class EbikeSettingDetailScreen extends StatelessWidget {
  final String code;
  final String brand;
  final String? modelId;

  static const String _appId = 'com.example.ride_care';
  static const String _playStoreUrl = 'https://play.google.com/store/apps/details?id=$_appId';
  static const String _shareText =
      'RideFixer helps e-bike riders understand display error codes and adjust P-settings (P1, P2, etc.) quickly. '
      'Share it with your riding group: $_playStoreUrl';
  static const String _sharePromptSnoozeUntilKey = 'share_prompt_snooze_until_ms';

  const EbikeSettingDetailScreen({super.key, required this.code, required this.brand, this.modelId});

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
                    'Found this setting guide useful? Share RideFixer with other riders.',
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
    final info = SettingsCatalog.findByCodeAndBrand(code, brand, modelId: modelId);
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
                  'Setting not in catalog',
                  style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(
                  'RideFixer doesn\'t have verified details for "$code" yet. Please check your display manual.',
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
        ),
      );
    }

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
            height: 240,
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
                          info.code,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await _copySummary(context, info.code, info.title, info.whatItDoes, info.values, info.notes);
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
                  _card(
                    context,
                    title: 'What it changes',
                    icon: Icons.help_outline,
                    child: Text(
                      info.whatItDoes,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                        color: colorScheme.onSurface.withOpacity(0.85),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _card(
                    context,
                    title: 'Values',
                    icon: Icons.tune_rounded,
                    child: _bullets(context, info.values),
                  ),
                  const SizedBox(height: 12),
                  if (info.notes.isNotEmpty)
                    _card(
                      context,
                      title: 'Notes / warnings',
                      icon: Icons.warning_amber_rounded,
                      child: _bullets(context, info.notes),
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

  static Widget _card(BuildContext context, {required String title, required IconData icon, required Widget child}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryGradient.colors.first),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  static Widget _bullets(BuildContext context, List<String> items) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    if (items.isEmpty) {
      return Text('Not specified.', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final t in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w900)),
                Expanded(
                  child: Text(
                    t,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.4),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  static Future<void> _copySummary(
    BuildContext context,
    String code,
    String title,
    String whatItDoes,
    List<String> values,
    List<String> notes,
  ) async {
    final text = StringBuffer()
      ..writeln('$code — $title')
      ..writeln()
      ..writeln(whatItDoes)
      ..writeln()
      ..writeln('Values:')
      ..writeln(values.map((e) => '- $e').join('\n'));

    if (notes.isNotEmpty) {
      text
        ..writeln()
        ..writeln('Notes:')
        ..writeln(notes.map((e) => '- $e').join('\n'));
    }

    await Clipboard.setData(ClipboardData(text: text.toString()));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied')));
    }
  }
}
