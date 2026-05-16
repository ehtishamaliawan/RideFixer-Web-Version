import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../widgets/app_back_button.dart';

class EbikeSettingsBrandSelectionScreen extends StatefulWidget {
  const EbikeSettingsBrandSelectionScreen({super.key});

  @override
  State<EbikeSettingsBrandSelectionScreen> createState() => _EbikeSettingsBrandSelectionScreenState();
}

class _EbikeSettingsBrandSelectionScreenState extends State<EbikeSettingsBrandSelectionScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // Bottom navigation bar can overlap the end of this scroll view.
    // Add extra space so the last card stays visible.
    const bottomNavClearance = 96.0;

    final genericBrand = _BrandInfo(
      name: 'Generic / Chinese',
      slug: 'generic',
      logo: Icons.widgets_outlined,
      description: 'SW900 / GD01 / GD02 (P01–P14) • S866 / M5 (P01–P20) • S830 (P00–P17) • KT‑LCD3 (P/C menus)',
    );

    final majorBrands = [
      _BrandInfo(
        name: 'Bosch',
        slug: 'bosch',
        logo: Icons.electric_bike_outlined,
        description: 'Official app / dealer settings (system-dependent)',
      ),
      _BrandInfo(
        name: 'Shimano',
        slug: 'shimano',
        logo: Icons.settings_suggest_outlined,
        description: 'E-Tube Project (where supported)',
      ),
      _BrandInfo(
        name: 'Yamaha',
        slug: 'yamaha',
        logo: Icons.speed_outlined,
        description: 'OEM display/app or dealer tools (model-dependent)',
      ),
      _BrandInfo(
        name: 'Bafang',
        slug: 'bafang',
        logo: Icons.electrical_services_outlined,
        description: 'Kits often support programming tools (varies by controller)',
      ),
      _BrandInfo(
        name: 'Brose',
        slug: 'brose',
        logo: Icons.bolt_outlined,
        description: 'Bike/OEM dependent settings',
      ),
    ];

    final q = _query.trim().toLowerCase();
    bool matches(_BrandInfo b) {
      if (q.isEmpty) return true;
      return b.name.toLowerCase().contains(q) || b.description.toLowerCase().contains(q);
    }

    final genericVisible = matches(genericBrand) ? [genericBrand] : const <_BrandInfo>[];
    final majorVisible = majorBrands.where(matches).toList(growable: false);

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
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 180,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(gradient: AppTheme.headerGradient(context)),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              AppBackButton(
                                color: Colors.white,
                              ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(Icons.tune_rounded, color: Colors.white, size: 28),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'E‑Bike Settings',
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Learn what each setting does before you change it.',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: const [
                            _HeroChip(text: 'P-settings'),
                            _HeroChip(text: 'Speed limits'),
                            _HeroChip(text: 'Battery & PAS'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search (e.g. SW900, Generic)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              16,
              10,
              16,
              MediaQuery.of(context).padding.bottom + bottomNavClearance,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  if (genericVisible.isNotEmpty) ...[
                    const _SectionTitle(
                      title: 'Generic / Chinese',
                      subtitle: 'Select this if you have an aftermarket kit, conversion kit, or unknown brand.',
                    ),
                    const SizedBox(height: 8),
                    _BrandCard(
                      brand: genericVisible.first,
                      prominent: true,
                      onTap: () => context.push('/ebike-settings/generic/models'),
                    ),
                    const SizedBox(height: 16),
                  ],

                  const _SectionTitle(
                    title: 'Major brands',
                    subtitle: 'We only show settings that are verified for a system or model.',
                  ),
                  const SizedBox(height: 8),
                  if (majorVisible.isEmpty)
                    const _EmptyState(
                      title: 'No matches',
                      message: 'Try a different search term.',
                    )
                  else
                    ...majorVisible.map(
                      (brand) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _BrandCard(
                          brand: brand,
                          onTap: () => context.push('/ebike-settings/${brand.slug}'),
                        ),
                      ),
                    ),

                  const SizedBox(height: 8),
                  const _RequestSectionDivider(label: 'REQUEST'),
                  const SizedBox(height: 10),
                  _RequestCard(
                    onTap: () {
                      final uri = Uri(
                        path: '/feature-request',
                        queryParameters: {
                          'title': 'Request a brand / model (P‑settings)',
                          'description':
                              'Please add verified P‑settings for:\n\nBrand/system name: \nDisplay/controller model: \nBike brand/model/year (optional): \n\nWhat I see on my screen/manual (P menu items): \n\nPhotos/links (optional): ',
                        },
                      );
                      context.push(uri.toString());
                    },
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
}

class _BrandInfo {
  final String name;
  final String slug;
  final IconData logo;
  final String description;

  _BrandInfo({
    required this.name,
    required this.slug,
    required this.logo,
    required this.description,
  });
}

class _BrandCard extends StatelessWidget {
  final _BrandInfo brand;
  final VoidCallback onTap;
  final bool prominent;

  const _BrandCard({required this.brand, required this.onTap, this.prominent = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accent = AppTheme.primaryGradient.colors.first;

    return Card(
      elevation: prominent ? 3 : 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: colorScheme.surface,
            border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.6)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  brand.logo,
                  color: accent,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      brand.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      brand.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurface.withOpacity(0.35),
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _SectionTitle({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: colorScheme.onSurface,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
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
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String message;

  const _EmptyState({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.6)),
      ),
      child: Row(
        children: [
          Icon(Icons.search_off, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final VoidCallback onTap;
  const _RequestCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accent = AppTheme.primaryGradient.colors.first;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: colorScheme.secondaryContainer,
            border: Border.all(color: accent.withOpacity(0.35)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colorScheme.onSecondaryContainer.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.lightbulb_outline_rounded, color: colorScheme.onSecondaryContainer, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Request a brand / model',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'We’ll add it once we can verify the settings.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSecondaryContainer.withOpacity(0.85),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSecondaryContainer.withOpacity(0.55),
                size: 26,
              ),
            ],
          ),
        ),
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
