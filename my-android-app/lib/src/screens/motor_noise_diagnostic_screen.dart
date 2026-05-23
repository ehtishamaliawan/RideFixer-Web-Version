import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../widgets/app_back_button.dart';

class MotorNoiseDiagnosticScreen extends StatefulWidget {
  const MotorNoiseDiagnosticScreen({super.key});

  @override
  State<MotorNoiseDiagnosticScreen> createState() => _MotorNoiseDiagnosticScreenState();
}

class _MotorNoiseDiagnosticScreenState extends State<MotorNoiseDiagnosticScreen> {
  static const MethodChannel _noisePreviewChannel = MethodChannel('ridefixer/noise_preview');
  static const List<_NoiseSample> _noiseSamples = [
    _NoiseSample(
      label: 'Motor Gears',
      soundType: 'motor_gears',
      summary: 'Common for mid-drive and geared hub motors when internal gears are worn or dry.',
      likelyCause:
          'Worn nylon gears, dry lubrication, or internal alignment issues can create a grinding or whirring gear noise.',
      quickChecks: [
        'Check for play in the motor axle or side cover.',
        'Listen for the sound under light load vs heavy load.',
        'Look for metal shavings or grease leaks near the motor casing.',
      ],
      repairs: [
        'Open the motor housing and inspect nylon gears for wear.',
        'Replace worn gears and re-grease with high-temp gear grease.',
        'If unsure, use a professional e-bike motor service.',
      ],
      icon: Icons.settings_rounded,
    ),
    _NoiseSample(
      label: 'Derailleur Adjustment',
      soundType: 'derailleur_adjustment',
      summary: 'Ticking or clicking that appears when pedaling or shifting under load.',
      likelyCause:
          'Misaligned derailleur hanger, cable tension drift, or worn pulley wheels cause the chain to chatter.',
      quickChecks: [
        'Shift through gears and note which cogs trigger the noise.',
        'Check the derailleur hanger for bends or impact marks.',
        'Inspect jockey wheels for wobble or grit buildup.',
      ],
      repairs: [
        'Re-index the gears with the barrel adjuster.',
        'Align or replace a bent hanger.',
        'Clean and replace worn pulley wheels or cables.',
      ],
      icon: Icons.settings_input_component_rounded,
    ),
    _NoiseSample(
      label: 'Spokes Loose',
      soundType: 'spokes_loose',
      summary: 'Ping or creak from the wheel during turns or hard pedaling.',
      likelyCause: 'Uneven spoke tension or a spoke nipple that is backing out under load.',
      quickChecks: [
        'Pluck adjacent spokes to compare tension tone.',
        'Check the wheel for side-to-side wobble.',
        'Listen for the noise while cornering or braking.',
      ],
      repairs: [
        'True the wheel and tension spokes evenly.',
        'Replace damaged spokes or nipples.',
        'Have a wheel builder re-tension if many spokes are loose.',
      ],
      icon: Icons.circle_outlined,
    ),
    _NoiseSample(
      label: 'Touching Disk',
      soundType: 'touching_disk',
      summary: 'Light scraping or shh sound each wheel rotation.',
      likelyCause: 'Brake rotor rub from a bent rotor or misaligned caliper.',
      quickChecks: [
        'Spin the wheel and watch the rotor gap at the caliper.',
        'Confirm the axle or quick release is fully seated.',
        'Check for heat discoloration or pad glazing.',
      ],
      repairs: [
        'Center the caliper using the mounting bolts.',
        'True the rotor with a rotor truing fork.',
        'Clean the rotor and pads if contaminated.',
      ],
      icon: Icons.album_rounded,
    ),
  ];

  String? _playingNoiseKey;
  String? _detailNoiseKey;

  @override
  void dispose() {
    _noisePreviewChannel.invokeMethod('stopPreview');
    super.dispose();
  }

  Future<void> _toggleNoiseSample(_NoiseSample sample) async {
    if (_playingNoiseKey == sample.label) {
      await _noisePreviewChannel.invokeMethod('stopPreview');
      if (!mounted) return;
      setState(() => _playingNoiseKey = null);
      return;
    }

    try {
      await _noisePreviewChannel.invokeMethod('playPreview', {'type': sample.soundType});
      if (!mounted) return;
      setState(() => _playingNoiseKey = sample.label);
      Future<void>.delayed(const Duration(milliseconds: 2400), () {
        if (!mounted) return;
        if (_playingNoiseKey == sample.label) {
          setState(() => _playingNoiseKey = null);
        }
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not play sample sound.')),
      );
    }
  }

  Future<void> _handleScreenBack() async {
    final router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
      return;
    }
    router.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noiseCards = <Widget>[];
    for (final sample in _noiseSamples) {
      noiseCards.add(_soundCard(theme, sample));
      noiseCards.add(const SizedBox(height: 16));
      if (_detailNoiseKey == sample.label) {
        noiseCards.add(_detailsCard(theme, sample));
        noiseCards.add(const SizedBox(height: 16));
      }
    }
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _handleScreenBack();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: theme.colorScheme.background,
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
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AppBackButton(
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Motor Noise Library',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withOpacity(0.22)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Listen and match',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Play a sound. If it matches your bike, open the repair details.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    ...noiseCards,
                    const SizedBox(height: 8),
                    _comingSoonCard(theme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _soundCard(ThemeData theme, _NoiseSample sample) {
    final isPlaying = _playingNoiseKey == sample.label;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.55)),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(sample.icon, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  sample.label,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            sample.summary,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.6)),
                ),
                child: IconButton(
                  onPressed: () => _toggleNoiseSample(sample),
                  tooltip: isPlaying ? 'Stop sample' : 'Play sample',
                  icon: Icon(isPlaying ? Icons.stop_circle_outlined : Icons.play_circle_outline),
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _detailNoiseKey = _detailNoiseKey == sample.label ? null : sample.label;
                    });
                  },
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: const Text('Open guide'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailsCard(ThemeData theme, _NoiseSample sample) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.55)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.build_circle_outlined, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                '${sample.label} - Repair guide',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Likely cause',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            sample.likelyCause,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
          ),
          const SizedBox(height: 12),
          Text(
            'Quick checks',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          for (final item in sample.quickChecks) _bullet(theme, item),
          const SizedBox(height: 12),
          Text(
            'How to repair',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          for (final item in sample.repairs) _bullet(theme, item),
        ],
      ),
    );
  }

  Widget _comingSoonCard(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.upcoming_rounded, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'More verified sounds will be added soon.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bullet(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•  ', style: theme.textTheme.bodyMedium?.copyWith(height: 1.4)),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoiseSample {
  final String label;
  final String soundType;
  final String summary;
  final String likelyCause;
  final List<String> quickChecks;
  final List<String> repairs;
  final IconData icon;

  const _NoiseSample({
    required this.label,
    required this.soundType,
    required this.summary,
    required this.likelyCause,
    required this.quickChecks,
    required this.repairs,
    required this.icon,
  });
}
