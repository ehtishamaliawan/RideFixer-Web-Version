import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/ebike_errors/brand_error_catalog.dart';
import '../features/ebike_errors/ebike_error_model.dart';
import '../features/ebike_errors/generic_models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_back_button.dart';

class EbikeErrorScreen extends StatefulWidget {
  final String brand;
  final String? modelId; // used for generic/chinese flow
  
  const EbikeErrorScreen({super.key, required this.brand, this.modelId});

  @override
  State<EbikeErrorScreen> createState() => _EbikeErrorScreenState();
}

class _EbikeErrorScreenState extends State<EbikeErrorScreen> {
  String _query = '';

  void _openRequest({String? codeHint}) {
    final isGeneric = widget.brand.toLowerCase() == 'generic';
    final modelId = widget.modelId?.toLowerCase();
    final modelLine = isGeneric
        ? '\nDisplay/controller: ${_genericModelLabel(modelId)}'
        : '';

    final title = 'Add e‑bike error code ($_brandDisplayName)';
    final description = [
      'Please add this error code:',
      '',
      'Brand/system: $_brandDisplayName$modelLine',
      'Error code: ${codeHint?.trim().isNotEmpty == true ? codeHint!.trim() : ''}',
      '',
      'What happens (symptoms):',
      '',
      'Bike brand/model/year (if known):',
      '',
      'Photo/link to manual (optional):',
    ].join('\n');

    final uri = Uri(
      path: '/feature-request',
      queryParameters: {
        'title': title,
        'description': description,
      },
    );

    context.push(uri.toString());
  }

  String get _brandDisplayName {
    switch (widget.brand.toLowerCase()) {
      case 'bosch':
        return 'Bosch';
      case 'yamaha':
        return 'Yamaha';
      case 'shimano':
        return 'Shimano';
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
        description: 'Show all generic codes.',
      ),
    );
    return 'Display/controller: ${found.name}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final selectedModelId = widget.modelId?.toLowerCase() ?? 'other';
    final isGeneric = widget.brand.toLowerCase() == 'generic';

    final all = BrandErrorCatalog.getErrorsByBrand(widget.brand);
    final q = _query.toLowerCase();
    final searched = all.where((e) {
      if (q.isEmpty) return true;
      return e.code.toLowerCase().contains(q) ||
          e.title.toLowerCase().contains(q) ||
          e.description.toLowerCase().contains(q);
    }).toList();

    final codes = (!isGeneric || selectedModelId == 'other')
        ? searched
        : searched.where((e) => e.models.isEmpty || e.models.contains(selectedModelId)).toList();

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
                      child: const Icon(
                        Icons.electrical_services,
                        color: Colors.white,
                        size: 28,
                      ),
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
                          'Error codes & solutions',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
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
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search code or keyword (e.g. E01, battery)',
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
                    onPressed: () => context.go('/ebike-errors/generic/models'),
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
                  Icon(Icons.add_circle_outline, color: colorScheme.onSecondaryContainer),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Can\'t find your exact code? Send it and we\'ll add it.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _openRequest,
                    child: Text(
                      'Request',
                      style: TextStyle(color: colorScheme.onSecondaryContainer, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: codes.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off, size: 44, color: colorScheme.onSurfaceVariant),
                          const SizedBox(height: 10),
                          Text(
                            'No matches',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Try a different keyword or request this code.',
                            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: _openRequest,
                            child: const Text('Request a code'),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(context).padding.bottom + 100),
                    itemCount: codes.length,
                    separatorBuilder: (c, i) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final info = codes[i];
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          leading: _severityCircle(context, info),
                          title: Text(
                            '${info.code} — ${info.title}',
                            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          subtitle: Text(info.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => context.push('/ebike-errors/${widget.brand}/detail/${info.code}'),
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

  Widget _severityCircle(BuildContext context, EbikeErrorInfo info) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = switch (info.severity) {
      EbikeSeverity.high => colorScheme.error,
      EbikeSeverity.medium => colorScheme.tertiary,
      EbikeSeverity.low => colorScheme.secondary,
    };
    final icon = info.severityIcon();
    return CircleAvatar(
      backgroundColor: color.withOpacity(0.12),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
