import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../features/ebike_errors/generic_models.dart';
import '../services/ebike_model_scanner.dart';
import '../theme/app_theme.dart';
import '../widgets/app_back_button.dart';

class EbikeGenericModelScreen extends StatelessWidget {
  final String onSelectBasePath;

  const EbikeGenericModelScreen({
    super.key,
    this.onSelectBasePath = '/ebike-errors/generic',
  });

  Future<String?> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    try {
      final picked = await picker.pickImage(
        source: source,
        imageQuality: 92,
      );
      return picked?.path;
    } catch (_) {
      if (!context.mounted) return null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open camera/gallery.')),
      );
      return null;
    }
  }

  Future<void> _showScanningDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final gradient = AppTheme.headerGradient(context);

        return AlertDialog(
          backgroundColor: colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          content: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: gradient,
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scanning…',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hold steady — identifying your model.',
                      style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _hideDialogIfOpen(BuildContext context) async {
    final nav = Navigator.of(context, rootNavigator: true);
    if (nav.canPop()) {
      nav.pop();
      await Future<void>.delayed(const Duration(milliseconds: 60));
    }
  }

  String _strengthLabel(int score) {
    if (score >= 60) return 'High';
    if (score >= 35) return 'Good';
    return 'Low';
  }

  Future<String?> _showDetectedSheet(BuildContext context, ModelScanResult result) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accent = AppTheme.headerGradient(context).colors.first;

    return showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      backgroundColor: colorScheme.surface,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.document_scanner_rounded, color: accent),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Model identified',
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Confirm the detected model to continue.',
                            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ...result.candidates.map(
                  (c) {
                    final strength = _strengthLabel(c.score);
                    return Card(
                      elevation: 0,
                      color: colorScheme.surfaceContainerHighest,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: accent.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(Icons.qr_code_scanner_rounded, color: accent),
                        ),
                        title: Text(c.label, style: const TextStyle(fontWeight: FontWeight.w900)),
                        subtitle: Text('${c.id.toUpperCase()} • $strength match'),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => Navigator.of(context).pop(c.id),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.list_alt_rounded),
                        label: const Text('Select manually'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => Navigator.of(context).pop('__rescan__'),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Scan again'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> _showNotFoundSheet(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accent = AppTheme.headerGradient(context).colors.first;

    return showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      backgroundColor: colorScheme.surface,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorScheme.errorContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.search_off_rounded, color: colorScheme.onErrorContainer),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Couldn’t identify the model',
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Try these quick tips and retry:',
                            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TipRow(icon: Icons.wb_sunny_rounded, text: 'Add light and avoid glare/reflections.'),
                      const SizedBox(height: 8),
                      _TipRow(icon: Icons.center_focus_strong_rounded, text: 'Keep the model label clearly visible and centered.'),
                      const SizedBox(height: 8),
                      _TipRow(icon: Icons.motion_photos_off_rounded, text: 'Hold steady so the label stays sharp.'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).pop('__manual__'),
                        icon: const Icon(Icons.list_alt_rounded),
                        label: const Text('Select manually'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => Navigator.of(context).pop('__rescan__'),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Try again'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'If your model isn’t listed, scroll down and tap “Request a model”.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _scanAndSelect(BuildContext context) async {
    final imagePath = await _pickImage(context, ImageSource.camera);
    if (imagePath == null) return;
    if (!context.mounted) return;

    final scanningDialog = _showScanningDialog(context);
    final result = await EbikeModelScanner.scanGenericModelFromImagePath(imagePath);

    if (!context.mounted) return;
    await _hideDialogIfOpen(context);
    await scanningDialog;

    if (!context.mounted) return;

    if (result.candidates.isEmpty) {
      final action = await _showNotFoundSheet(context);
      if (!context.mounted) return;
      if (action == '__rescan__') {
        await _scanAndSelect(context);
      }
      return;
    }

    final selectedId = await _showDetectedSheet(context, result);
    if (!context.mounted) return;

    if (selectedId == '__rescan__') {
      await _scanAndSelect(context);
      return;
    }

    if (selectedId == null) return;

    context.push('$onSelectBasePath?model=$selectedId');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accent = AppTheme.headerGradient(context).colors.first;
    final topInset = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    IconData iconFor(String id) {
      switch (id) {
        case 'sw900':
          return Icons.display_settings_rounded;
        case 'gd01':
        case 'gd02':
          return Icons.developer_board_rounded;
        case 's866':
        case 's830':
          return Icons.speed_rounded;
        case 'kt-lcd3':
          return Icons.lan_rounded;
        case 'ukc1':
          return Icons.tune_rounded;
        case 'm5':
          return Icons.memory_rounded;
        default:
          return Icons.help_outline_rounded;
      }
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
        backgroundColor: colorScheme.background,
        body: Column(
          children: [
          Container(
            padding: EdgeInsets.fromLTRB(24, topInset + 16, 24, 24),
            decoration: BoxDecoration(
              gradient: AppTheme.headerGradient(context),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              boxShadow: AppTheme.softShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBackButton(
                  color: Colors.white,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.display_settings_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select your display / controller',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Pick the closest model so we can tailor the results.',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: const [
                              _HeroChip(text: 'LCD displays'),
                              _HeroChip(text: 'Hub & mid‑drive kits'),
                              _HeroChip(text: 'Popular combos'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(16, 14, 16, bottomPad + 24),
              itemCount: genericEbikeSubModels.length + 2,
              separatorBuilder: (context, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: colorScheme.surfaceContainerHighest,
                        border: Border.all(color: accent.withOpacity(0.22)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: AppTheme.headerGradient(context),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.document_scanner_rounded, color: Colors.white),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Identify your model',
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'We’ll auto-detect the display/controller model from what your camera sees.',
                                  style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          FilledButton.icon(
                            onPressed: () => _scanAndSelect(context),
                            icon: const Icon(Icons.camera_alt_rounded),
                            label: const Text('Identify'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (index == genericEbikeSubModels.length + 1) {
                  final isSettings = onSelectBasePath.startsWith('/ebike-settings');
                  final uri = Uri(
                    path: '/feature-request',
                    queryParameters: {
                      'title': isSettings
                          ? 'Request display/controller model (P‑settings)'
                          : 'Request display/controller model (error codes)',
                      'description': isSettings
                          ? 'Please add verified P‑settings for this display/controller:\n\nDisplay/controller model name: \nController brand (if known): \nBike brand/model/year (optional): \n\nWhat I see in P‑settings menu (P01, P02...): \n\nPhotos/links (optional): '
                          : 'Please add error codes for this display/controller:\n\nDisplay/controller model name: \nController brand (if known): \nBike brand/model/year (optional): \n\nError code(s) I see: \n\nPhotos/links (optional): ',
                    },
                  );

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _RequestSectionDivider(label: 'REQUEST'),
                      const SizedBox(height: 12),
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () => context.push(uri.toString()),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: colorScheme.secondaryContainer,
                              border: Border.all(color: accent.withOpacity(0.35)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: colorScheme.onSecondaryContainer.withOpacity(0.10),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.add_circle_outline,
                                    color: colorScheme.onSecondaryContainer,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Request a model',
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w900,
                                          color: colorScheme.onSecondaryContainer,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Can’t find your display/controller? Tell us and we’ll add it.',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.onSecondaryContainer.withOpacity(0.85),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: colorScheme.onSecondaryContainer.withOpacity(0.55),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                final model = genericEbikeSubModels[index - 1];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => context.push('$onSelectBasePath?model=${model.id}'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: accent.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(iconFor(model.id), color: accent),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  model.name,
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  model.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final String text;
  const _HeroChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}

class _RequestSectionDivider extends StatelessWidget {
  final String label;
  const _RequestSectionDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Expanded(child: Divider(color: colorScheme.outlineVariant.withOpacity(0.6), height: 1)),
          const SizedBox(width: 10),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Divider(color: colorScheme.outlineVariant.withOpacity(0.6), height: 1)),
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _TipRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}
