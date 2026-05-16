import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/app_back_button.dart';

class EbikeBrandSelectionScreen extends StatefulWidget {
  const EbikeBrandSelectionScreen({super.key});

  @override
  State<EbikeBrandSelectionScreen> createState() => _EbikeBrandSelectionScreenState();
}

class _EbikeBrandSelectionScreenState extends State<EbikeBrandSelectionScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // Bottom navigation bar can overlap the end of this scroll view.
    // Add extra space so the last card (Generic/Chinese) stays visible.
    const bottomNavClearance = 96.0;

    final brands = [
      _BrandInfo(
        name: 'Generic / Chinese',
        slug: 'generic',
        logo: Icons.widgets_outlined,
        description: 'Generic controllers & Chinese brands',
      ),
    ];

    final famousBrands = [
      _BrandInfo(
        name: 'Bosch',
        slug: 'bosch',
        logo: Icons.electric_bolt,
        description: 'German engineering excellence',
      ),
      _BrandInfo(
        name: 'Yamaha',
        slug: 'yamaha',
        logo: Icons.directions_bike,
        description: 'Japanese precision motors',
      ),
      _BrandInfo(
        name: 'Shimano',
        slug: 'shimano',
        logo: Icons.settings_input_component,
        description: 'STEPS drive systems',
      ),
      _BrandInfo(
        name: 'Bafang',
        slug: 'bafang',
        logo: Icons.power,
        description: 'Popular mid-drive motors',
      ),
      _BrandInfo(
        name: 'Brose',
        slug: 'brose',
        logo: Icons.speed,
        description: 'High-performance drives',
      ),
    ];

    final q = _query.trim().toLowerCase();
    bool matches(_BrandInfo b) {
      if (q.isEmpty) return true;
      return b.name.toLowerCase().contains(q) || b.description.toLowerCase().contains(q);
    }

    final generic = brands.where(matches).toList(growable: false);
    final major = famousBrands.where(matches).toList(growable: false);

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
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
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
                              child: const Icon(Icons.electrical_services_rounded, color: Colors.white, size: 28),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'E‑Bike Error Codes',
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Choose your system to see the right codes.',
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
                            _HeroChip(text: 'Bosch'),
                            _HeroChip(text: 'Shimano STEPS'),
                            _HeroChip(text: 'Generic / Chinese kits'),
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
                  hintText: 'Search brand (e.g. Bosch, Bafang, Generic)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
          ),

          // Brand List
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
                  if (generic.isNotEmpty) ...[
                    _SectionTitle(
                      title: 'Generic / Chinese',
                      subtitle: 'Select this if you have an aftermarket kit or unknown brand.',
                    ),
                    const SizedBox(height: 8),
                    _BrandCard(
                      brand: generic.first,
                      prominent: true,
                      onTap: () => context.push('/ebike-errors/generic/models'),
                    ),
                    const SizedBox(height: 16),
                  ],
                  _SectionTitle(
                    title: 'Major brands',
                    subtitle: 'Official systems with dedicated error catalogs.',
                  ),
                  const SizedBox(height: 8),
                  if (major.isEmpty)
                    _EmptyState(
                      title: 'No matches',
                      message: 'Try a different search term.',
                    )
                  else
                    ...major.map(
                      (brand) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _BrandCard(
                          brand: brand,
                          onTap: () => context.push('/ebike-errors/${brand.slug}'),
                        ),
                      ),
                    ),

                  const SizedBox(height: 18),
                  const _RequestSectionDivider(label: 'REQUEST'),
                  const SizedBox(height: 10),
                  _RequestBrandCard(
                    onTap: () {
                      final uri = Uri(
                        path: '/feature-request',
                        queryParameters: {
                          'title': 'Add e‑bike brand (error codes)',
                          'description':
                              'Please add error codes for this e‑bike system/brand:\n\nBrand/system name: \nBike brand/model/year (optional): \nDisplay/controller model (optional): \n\nLink to manual / photo (optional): ',
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

class _RequestBrandCard extends StatelessWidget {
  final VoidCallback onTap;
  const _RequestBrandCard({required this.onTap});

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
                child: Icon(Icons.add_circle_outline, color: colorScheme.onSecondaryContainer, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Request a brand',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Missing your system? Tell us the brand/model.',
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

  const _BrandCard({
    required this.brand,
    required this.onTap,
    this.prominent = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accent = AppTheme.primaryGradient.colors.first;

    return Card(
      elevation: prominent ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
              // Brand Icon
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
              // Brand Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      brand.name,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
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
              // Arrow
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
                Text(message, style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
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
