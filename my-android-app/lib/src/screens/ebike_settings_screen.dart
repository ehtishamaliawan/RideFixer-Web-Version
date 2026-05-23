import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/ebike_settings/ebike_setting_model.dart';
import '../features/ebike_settings/settings_catalog.dart';
import '../features/ebike_errors/generic_models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_back_button.dart';

class EbikeSettingsScreen extends StatefulWidget {
  final String brand;
  final String? modelId; // used for generic flow

  const EbikeSettingsScreen({super.key, required this.brand, this.modelId});

  @override
  State<EbikeSettingsScreen> createState() => _EbikeSettingsScreenState();
}

class _EbikeSettingsScreenState extends State<EbikeSettingsScreen> {
  String _query = '';

  String get _brandDisplayName {
    switch (widget.brand.toLowerCase()) {
      case 'bosch':
        return 'Bosch';
      case 'shimano':
        return 'Shimano';
      case 'yamaha':
        return 'Yamaha';
      case 'bafang':
        return 'Bafang';
      case 'brose':
        return 'Brose';
      case 'generic':
        return 'Generic / Chinese';
      default:
        return 'Unknown';
    }
  }

  String _genericModelLabel(String? id) {
    final resolved = (id ?? 'other').toLowerCase();
    final found = genericEbikeSubModels.firstWhere(
      (m) => m.id == resolved,
      orElse: () => const GenericEbikeSubModel(
        id: 'other',
        name: 'Other / Not sure',
        description: 'Show all settings.',
      ),
    );
    return 'Display/controller: ${found.name}';
  }

  IconData _iconFor(String code) {
    switch (code.toUpperCase()) {
      case 'P00':
        return Icons.settings_backup_restore_rounded;
      case 'P1':
        return Icons.settings_input_component_rounded;
      case 'P2':
        return Icons.sensors_rounded;
      case 'P3':
        return Icons.tune_rounded;
      case 'P4':
        return Icons.play_circle_outline_rounded;
      case 'P5':
        return Icons.battery_std_rounded;
      case 'C1':
        return Icons.sensors_rounded;
      case 'C7':
        return Icons.auto_mode_rounded;
      case 'P01':
        return Icons.brightness_6_rounded;
      case 'P02':
        return Icons.speed_rounded;
      case 'P03':
        return Icons.battery_charging_full_rounded;
      case 'P04':
        return Icons.timer_outlined;
      case 'P05':
        return Icons.stacked_line_chart_rounded;
      case 'P06':
        return Icons.circle_outlined;
      case 'P07':
        return Icons.settings_input_antenna_rounded;
      case 'P08':
        return Icons.shield_rounded;
      case 'P09':
        return Icons.play_circle_outline_rounded;
      case 'P10':
        return Icons.alt_route_rounded;
      case 'P11':
        return Icons.tune_rounded;
      case 'P12':
        return Icons.flash_on_rounded;
      case 'P13':
        return Icons.hub_outlined;
      case 'P14':
        return Icons.electric_bolt_rounded;
      case 'P15':
        return Icons.battery_alert_rounded;
      case 'P16':
        return Icons.restart_alt_rounded;
      case 'P17':
        return Icons.auto_mode_rounded;
      case 'P18':
        return Icons.speed_rounded;
      case 'P19':
        return Icons.exposure_zero_rounded;
      case 'P20':
        return Icons.lan_outlined;
      default:
        return Icons.tune_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final selectedModelId = widget.modelId?.toLowerCase() ?? 'other';
    final isGeneric = widget.brand.toLowerCase() == 'generic';

    final all = SettingsCatalog.getSettingsByBrand(widget.brand);
    final q = _query.toLowerCase().trim();

    final searched = all.where((s) {
      if (q.isEmpty) return true;
      return s.code.toLowerCase().contains(q) || s.title.toLowerCase().contains(q) || s.summary.toLowerCase().contains(q);
    }).toList();

    final visible = (!isGeneric || selectedModelId == 'other')
        ? searched
        : searched.where((s) => s.models.isEmpty || s.models.contains(selectedModelId)).toList();

    final modelSpecific = (!isGeneric || selectedModelId == 'other')
        ? const <EbikeSettingInfo>[]
        : visible.where((s) => s.models.contains(selectedModelId)).toList();

    final common = (!isGeneric || selectedModelId == 'other')
        ? const <EbikeSettingInfo>[]
        : visible.where((s) => s.models.isEmpty).toList();

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
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
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
                      child: const Icon(Icons.tune_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _brandDisplayName,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Settings & what they do',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
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
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search setting (e.g. P08, speed, voltage)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: theme.colorScheme.surface,
              ),
              onChanged: (v) => setState(() => _query = v.trim()),
            ),
          ),
          if (isGeneric)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  Icon(Icons.tune_rounded, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _genericModelLabel(widget.modelId),
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/ebike-settings/generic/models'),
                    child: const Text('Change'),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: colorScheme.onSecondaryContainer),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Settings vary by controller and firmware. If unsure, confirm with your manual or a bike shop.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: visible.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.tune, size: 44, color: colorScheme.onSurfaceVariant),
                          const SizedBox(height: 10),
                          Text(
                            'No settings found',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isGeneric && selectedModelId != 'other'
                              ? 'RideFixer doesn\'t have verified settings for this display/controller yet. Verified settings are currently included for SW900/GD01/GD02, S866/M5, S830, and KT‑LCD3.'
                                : 'Try a different keyword or pick “Other / Not sure”.',
                            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                            textAlign: TextAlign.center,
                          ),
                          if (isGeneric && selectedModelId != 'other') ...[
                            const SizedBox(height: 12),
                            FilledButton(
                              onPressed: () {
                                final title = 'Request display/controller model (P‑settings)';
                                final description = [
                                  'Please add verified P‑settings for this display/controller:',
                                  '',
                                  'Brand/system: $_brandDisplayName',
                                  'Display/controller model id: $selectedModelId',
                                  '',
                                  'What I see in P‑settings menu (P01, P02...):',
                                  '',
                                  'Photos/links (optional):',
                                ].join('\n');

                                final uri = Uri(
                                  path: '/feature-request',
                                  queryParameters: {
                                    'title': title,
                                    'description': description,
                                  },
                                );
                                context.push(uri.toString());
                              },
                              child: const Text('Request this display'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(context).padding.bottom + 100),
                    itemCount: _listItemsCount(
                      isGeneric: isGeneric,
                      selectedModelId: selectedModelId,
                      modelSpecific: modelSpecific,
                      common: common,
                      all: visible,
                    ),
                    separatorBuilder: (c, i) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final item = _listItemAt(
                        index: i,
                        isGeneric: isGeneric,
                        selectedModelId: selectedModelId,
                        modelSpecific: modelSpecific,
                        common: common,
                        all: visible,
                      );

                      if (item is _ListHeader) {
                        return _sectionHeader(context, title: item.title, subtitle: item.subtitle);
                      }

                      if (item is _InfoNote) {
                        return _infoNote(context, item.text);
                      }

                      final setting = (item as _SettingItem).setting;
                      final modelQuery = (isGeneric && selectedModelId != 'other') ? '?model=$selectedModelId' : '';
                      return _settingCard(
                        context,
                        setting,
                        icon: _iconFor(setting.code),
                        onTap: () => context.push('/ebike-settings/${widget.brand}/detail/${setting.code}$modelQuery'),
                      );
                    },
                  ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _settingCard(
    BuildContext context,
    EbikeSettingInfo setting, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final accent = AppTheme.primaryGradient.colors.first;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: accent.withOpacity(0.12),
          child: Icon(icon, color: accent, size: 20),
        ),
        title: Text(
          '${setting.code} — ${setting.title}',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
        subtitle: Text(setting.summary, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, {required String title, String? subtitle}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoNote(BuildContext context, String text) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.6)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static int _listItemsCount({
    required bool isGeneric,
    required String selectedModelId,
    required List<EbikeSettingInfo> modelSpecific,
    required List<EbikeSettingInfo> common,
    required List<EbikeSettingInfo> all,
  }) {
    if (!isGeneric) return all.length;

    if (selectedModelId == 'other') {
      // Show a short note reminding users to select a model, since P-codes vary.
      return all.length + 1;
    }

    var count = 0;
    count += 1; // header
    if (modelSpecific.isEmpty) count += 1; // note
    count += modelSpecific.length;

    if (common.isNotEmpty) {
      count += 1; // header
      count += common.length;
    }

    return count;
  }

  static _ListItem _listItemAt({
    required int index,
    required bool isGeneric,
    required String selectedModelId,
    required List<EbikeSettingInfo> modelSpecific,
    required List<EbikeSettingInfo> common,
    required List<EbikeSettingInfo> all,
  }) {
    if (!isGeneric) {
      return _SettingItem(all[index]);
    }

    if (selectedModelId == 'other') {
      if (index == 0) {
        return const _InfoNote('Tip: select your display/controller to see the correct meaning for each P‑code. P‑codes can differ between SW900/GDxx and S866/M5 families.');
      }
      return _SettingItem(all[index - 1]);
    }

    var cursor = 0;
    if (index == cursor) {
      return const _ListHeader(
        title: 'Settings for your selected model',
        subtitle: 'These are the most relevant settings for this display/controller.',
      );
    }
    cursor += 1;

    if (modelSpecific.isEmpty) {
      if (index == cursor) {
        return const _InfoNote('No model-specific settings in the catalog yet.');
      }
      cursor += 1;
    }

    if (index < cursor + modelSpecific.length) {
      return _SettingItem(modelSpecific[index - cursor]);
    }
    cursor += modelSpecific.length;

    if (common.isNotEmpty) {
      if (index == cursor) {
        return const _ListHeader(
          title: 'Common settings',
          subtitle: 'These may vary by controller/firmware. Confirm with your manual if unsure.',
        );
      }
      cursor += 1;

      if (index < cursor + common.length) {
        return _SettingItem(common[index - cursor]);
      }
      cursor += common.length;
    }

    return _SettingItem(all.last);
  }
}

sealed class _ListItem {
  const _ListItem();
}

final class _ListHeader extends _ListItem {
  final String title;
  final String? subtitle;
  const _ListHeader({required this.title, this.subtitle});
}

final class _InfoNote extends _ListItem {
  final String text;
  const _InfoNote(this.text);
}

final class _SettingItem extends _ListItem {
  final EbikeSettingInfo setting;
  const _SettingItem(this.setting);
}
