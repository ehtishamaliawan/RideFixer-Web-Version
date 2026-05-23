import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../widgets/app_back_button.dart';

class BatteryHealthCalculatorScreen extends StatefulWidget {
  const BatteryHealthCalculatorScreen({super.key});

  @override
  State<BatteryHealthCalculatorScreen> createState() => _BatteryHealthCalculatorScreenState();
}

class _BatteryHealthCalculatorScreenState extends State<BatteryHealthCalculatorScreen> {
  int _step = 0;

  String? _age;
  String? _cycles;
  String? _rangeLoss;
  String? _charging;
  String? _storage;
  String? _voltage;

  BatteryHealthResult? _result;

  static const List<String> _ageOptions = [
    'Less than 6 months',
    '6 months to 1 year',
    '1 to 2 years',
    '2 to 3 years',
    '3 to 4 years',
    'More than 4 years',
  ];

  static const List<String> _cycleOptions = [
    'Every day',
    'Every 2-3 days',
    'Once a week',
    'Only when completely empty',
    'Irregularly',
  ];

  static const List<String> _rangeOptions = [
    'Same as new - no change',
    'Slightly less - about 10-20% reduction',
    'Noticeably less - about 20-40% reduction',
    'Significantly less - about 40-60% reduction',
    'Much worse - over 60% reduction',
  ];

  static const List<String> _chargingOptions = [
    'Always charge to 100%',
    'Charge to 80-90% mostly',
    'Leave on charger overnight regularly',
    'Charge from completely empty always',
    'Mix of different habits',
  ];

  static const List<String> _storageOptions = [
    'Always on the bike outside',
    'Indoors at room temperature',
    'In garage - can get very cold or hot',
    'Remove and store indoors in winter',
    "Don't know",
  ];

  static const List<String> _voltageOptions = [
    '36V',
    '48V',
    '52V',
    '72V',
    "Don't know",
  ];

  bool get _canNext {
    switch (_step) {
      case 0:
        return _age != null;
      case 1:
        return _cycles != null;
      case 2:
        return _rangeLoss != null;
      case 3:
        return _charging != null;
      case 4:
        return _storage != null;
      case 5:
        return _voltage != null;
      default:
        return true;
    }
  }

  void _reset() {
    setState(() {
      _step = 0;
      _age = null;
      _cycles = null;
      _rangeLoss = null;
      _charging = null;
      _storage = null;
      _voltage = null;
      _result = null;
    });
  }

  void _next() {
    if (!_canNext) return;
    if (_step < 5) {
      setState(() => _step += 1);
      return;
    }
    _calculate();
  }

  void _back() {
    if (_step == 0) return;
    setState(() => _step -= 1);
  }

  void _calculate() {
    int score = 0;
    final issues = <String>[];
    final positives = <String>[];
    final tips = <String>[];
    var confidence = 100;

    // Age (20)
    switch (_age) {
      case 'Less than 6 months':
        score += 20;
        positives.add('Battery age is excellent.');
        break;
      case '6 months to 1 year':
        score += 18;
        positives.add('Battery age is still very good.');
        break;
      case '1 to 2 years':
        score += 15;
        break;
      case '2 to 3 years':
        score += 10;
        issues.add('Battery age is entering natural degradation period.');
        break;
      case '3 to 4 years':
        score += 6;
        issues.add('Battery age is likely impacting capacity noticeably.');
        break;
      default:
        score += 2;
        issues.add('Battery age is high and may reduce reliability.');
    }

    // Charge cycles habit (15)
    switch (_cycles) {
      case 'Every 2-3 days':
        score += 15;
        positives.add('Charge frequency is healthy.');
        break;
      case 'Once a week':
        score += 12;
        break;
      case 'Irregularly':
        score += 9;
        tips.add('Keep charging pattern more consistent for better battery health.');
        break;
      case 'Every day':
        score += 8;
        issues.add('Daily full cycling can accelerate wear over time.');
        break;
      default:
        score += 4;
        issues.add('Charging only from empty increases stress on cells.');
        tips.add('Avoid letting battery drop below 20% before charging.');
    }

    // Range loss (25)
    switch (_rangeLoss) {
      case 'Same as new - no change':
        score += 25;
        positives.add('Range retention is excellent.');
        break;
      case 'Slightly less - about 10-20% reduction':
        score += 20;
        break;
      case 'Noticeably less - about 20-40% reduction':
        score += 14;
        issues.add('Range drop suggests medium battery wear.');
        break;
      case 'Significantly less - about 40-60% reduction':
        score += 7;
        issues.add('Significant range loss indicates advanced degradation.');
        break;
      default:
        score += 2;
        issues.add('Severe range loss detected.');
    }

    // Charging habit (20)
    switch (_charging) {
      case 'Charge to 80-90% mostly':
        score += 20;
        positives.add('Charging to 80-90% helps battery longevity.');
        break;
      case 'Always charge to 100%':
        score += 12;
        issues.add('Frequent 100% charging can increase long-term wear.');
        tips.add('Charge to 80-90% for regular daily use when possible.');
        break;
      case 'Mix of different habits':
        score += 11;
        break;
      case 'Charge from completely empty always':
        score += 5;
        issues.add('Deep discharging from empty is harsh on battery cells.');
        tips.add('Recharge before battery drops below 20%.');
        break;
      default:
        score += 4;
        issues.add('Leaving on charger overnight regularly reduces lifespan.');
        tips.add('Remove battery from charger once full.');
    }

    // Storage habit (15)
    switch (_storage) {
      case 'Indoors at room temperature':
        score += 15;
        positives.add('Storage temperature practice is good.');
        break;
      case 'Remove and store indoors in winter':
        score += 14;
        positives.add('Winter storage habit helps preserve battery health.');
        break;
      case "Don't know":
        score += 9;
        tips.add('Store battery at room temperature when not in use.');
        break;
      case 'In garage - can get very cold or hot':
        score += 7;
        issues.add('Temperature swings in garage can accelerate capacity loss.');
        tips.add('Store battery indoors in extreme seasons.');
        break;
      default:
        score += 3;
        issues.add('Outdoor storage increases moisture and temperature stress.');
        tips.add('Avoid storing battery outside on the bike for long periods.');
    }

    // Voltage awareness (confidence only)
    if (_voltage == "Don't know") {
      confidence -= 12;
      tips.add('Confirm your battery voltage to match correct charger and settings.');
    } else {
      positives.add('Battery voltage information is available.');
    }

    final severeRange = _rangeLoss == 'Significantly less - about 40-60% reduction' ||
        _rangeLoss == 'Much worse - over 60% reduction';
    final veryOldBattery = _age == '3 to 4 years' || _age == 'More than 4 years';
    final harshCharging = _charging == 'Charge from completely empty always' ||
        _charging == 'Leave on charger overnight regularly';
    final extremeStorage =
        _storage == 'Always on the bike outside' || _storage == 'In garage - can get very cold or hot';

    // Guardrails: prevent unrealistically optimistic outcomes when severe symptoms exist.
    if (severeRange) {
      score = min(score, 49);
      issues.add('Range-loss pattern indicates advanced cell wear.');
    }
    if (severeRange && veryOldBattery) {
      score = min(score, 29);
      issues.add('Age + severe range loss suggests end-of-life battery condition.');
    } else if (harshCharging && severeRange) {
      score = min(score, 39);
      issues.add('Charging pattern likely accelerated degradation.');
    }
    if (extremeStorage && veryOldBattery) {
      score = min(score, 44);
      tips.add('Move battery storage to indoor, temperature-stable conditions.');
    }

    if (_storage == "Don't know") {
      confidence -= 8;
    }
    if (_charging == 'Mix of different habits' || _cycles == 'Irregularly') {
      confidence -= 6;
    }

    score = score.clamp(0, 100);
    confidence = confidence.clamp(60, 100);
    final status = _statusForScore(score);
    final lifespan = _estimateLifespan(
      score,
      _age ?? '1 to 2 years',
      severeRange: severeRange,
      veryOldBattery: veryOldBattery,
    );

    final normalizedIssues = <String>[];
    normalizedIssues.addAll(issues.map((e) => 'Warning: $e'));

    final uniqTips = <String>[];
    for (final t in tips) {
      if (!uniqTips.contains(t)) {
        uniqTips.add(t);
      }
    }

    while (uniqTips.length < 3) {
      final fallback = [
        'Avoid storing battery fully charged for many days.',
        'Keep battery clean and dry around terminals.',
        'Use original or certified charger only.',
        'Do not expose battery to direct sun for long periods.',
      ][uniqTips.length % 4];
      if (!uniqTips.contains(fallback)) {
        uniqTips.add(fallback);
      }
    }

    if (normalizedIssues.isEmpty) {
      normalizedIssues.add('No critical warning pattern detected from your answers.');
    }

    final replacement = _replacementGuidance(
      score,
      severeRange: severeRange,
      veryOldBattery: veryOldBattery,
    );

    setState(() {
      _result = BatteryHealthResult(
        score: score,
        confidence: confidence,
        status: status,
        estimatedLifespan: lifespan,
        keyIssues: normalizedIssues,
        positives: positives.take(3).toList(),
        tips: uniqTips.take(5).toList(),
        replacementGuidance: replacement,
      );
    });
  }

  String _statusForScore(int score) {
    if (score >= 85) return 'Excellent';
    if (score >= 70) return 'Good';
    if (score >= 50) return 'Fair';
    if (score >= 30) return 'Poor';
    return 'Critical';
  }

  String _estimateLifespan(
    int score,
    String age, {
    required bool severeRange,
    required bool veryOldBattery,
  }) {
    int baseMonths;
    if (score >= 85) {
      baseMonths = 30;
    } else if (score >= 70) {
      baseMonths = 22;
    } else if (score >= 50) {
      baseMonths = 15;
    } else if (score >= 30) {
      baseMonths = 9;
    } else {
      baseMonths = 4;
    }

    final agePenalty = {
      'Less than 6 months': 0,
      '6 months to 1 year': 2,
      '1 to 2 years': 4,
      '2 to 3 years': 7,
      '3 to 4 years': 10,
      'More than 4 years': 14,
    }[age] ?? 4;

    var months = max(2, baseMonths - agePenalty);

    if (severeRange) {
      months = min(months, 8);
    }
    if (veryOldBattery) {
      months = min(months, 10);
    }

    if (months >= 24) {
      return 'Your battery has approximately ${(months / 12).toStringAsFixed(1)} years of good performance remaining.';
    }
    return 'Your battery has approximately $months months of good performance remaining.';
  }

  String _replacementGuidance(
    int score, {
    required bool severeRange,
    required bool veryOldBattery,
  }) {
    if (severeRange && veryOldBattery) {
      return 'Battery replacement is strongly recommended soon for safety and predictable range.';
    }
    if (severeRange || score < 30) {
      return 'Battery replacement recommended soon for safety and performance.';
    }
    if (score < 50) {
      return 'Consider budgeting for a replacement battery within 12 months.';
    }
    return 'Your battery is in good shape. Keep up good charging habits.';
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
                            'Battery Health Calculator',
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
                            'Battery health snapshot',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Estimate condition, lifespan, and maintenance advice from real-world usage.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    _result == null ? _buildWizard(theme) : _buildResult(theme, _result!),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWizard(ThemeData theme) {
    final progress = (_step + 1) / 6;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
              boxShadow: AppTheme.softShadow,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: theme.colorScheme.primary.withOpacity(0.12),
                  ),
                  child: Icon(Icons.battery_charging_full_rounded, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Step ${_step + 1} of 6',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Quick assessment based on your real usage pattern',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 14),
          _currentQuestion(),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _step == 0 ? null : _back,
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _canNext ? _next : null,
                  child: Text(_step == 5 ? 'Calculate' : 'Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _currentQuestion() {
    switch (_step) {
      case 0:
        return _questionCard(
          title: 'How old is your battery?',
          options: _ageOptions,
          selected: _age,
          onChanged: (v) => setState(() => _age = v),
        );
      case 1:
        return _questionCard(
          title: 'How often do you charge your battery?',
          options: _cycleOptions,
          selected: _cycles,
          onChanged: (v) => setState(() => _cycles = v),
        );
      case 2:
        return _questionCard(
          title: 'Compared to when your battery was new, what is your current range?',
          options: _rangeOptions,
          selected: _rangeLoss,
          onChanged: (v) => setState(() => _rangeLoss = v),
        );
      case 3:
        return _questionCard(
          title: 'How do you usually charge your battery?',
          options: _chargingOptions,
          selected: _charging,
          onChanged: (v) => setState(() => _charging = v),
        );
      case 4:
        return _questionCard(
          title: 'How do you store your battery?',
          options: _storageOptions,
          selected: _storage,
          onChanged: (v) => setState(() => _storage = v),
        );
      default:
        return _questionCard(
          title: 'What is your battery voltage?',
          options: _voltageOptions,
          selected: _voltage,
          onChanged: (v) => setState(() => _voltage = v),
        );
    }
  }

  Widget _questionCard({
    required String title,
    required List<String> options,
    required String? selected,
    required ValueChanged<String> onChanged,
  }) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.55)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          ...options.map(
            (opt) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => onChanged(opt),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: selected == opt
                        ? theme.colorScheme.primary.withOpacity(0.12)
                        : theme.colorScheme.surfaceContainerHighest.withOpacity(0.35),
                    border: Border.all(
                      color: selected == opt
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outlineVariant.withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        selected == opt ? Icons.check_circle_rounded : Icons.circle_outlined,
                        size: 20,
                        color: selected == opt
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(opt)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult(ThemeData theme, BatteryHealthResult result) {
    final color = _statusColor(result.status);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.18),
                  color.withOpacity(0.06),
                ],
              ),
              border: Border.all(color: color.withOpacity(0.35)),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: 130,
                  height: 130,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: result.score / 100,
                        strokeWidth: 12,
                        color: color,
                        backgroundColor: color.withOpacity(0.18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  result.status,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _sectionCard(
            title: 'Estimated Remaining Lifespan',
            icon: Icons.schedule_rounded,
            child: Text(result.estimatedLifespan),
          ),
          if (result.positives.isNotEmpty) ...[
            const SizedBox(height: 12),
            _sectionCard(
              title: 'What Looks Good',
              icon: Icons.verified_rounded,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: result.positives
                    .map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text('- $e'),
                        ))
                    .toList(),
              ),
            ),
          ],
          const SizedBox(height: 12),
          _sectionCard(
            title: 'Key Issues Detected',
            icon: Icons.warning_amber_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: result.keyIssues
                  .map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text('- $e'),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          _sectionCard(
            title: 'Tips To Extend Battery Life',
            icon: Icons.tips_and_updates_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: result.tips
                  .map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text('- $e'),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          _sectionCard(
            title: 'Replacement Recommendation',
            icon: Icons.build_circle_outlined,
            child: Text(result.replacementGuidance),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _reset,
              child: const Text('Recalculate'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required IconData icon, required Widget child}) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.55)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Excellent':
        return const Color(0xFF1E8E3E);
      case 'Good':
        return const Color(0xFF2CA45C);
      case 'Fair':
        return const Color(0xFFF9A825);
      case 'Poor':
        return const Color(0xFFF57C00);
      default:
        return const Color(0xFFD93025);
    }
  }
}

class BatteryHealthResult {
  final int score;
  final int confidence;
  final String status;
  final String estimatedLifespan;
  final List<String> keyIssues;
  final List<String> positives;
  final List<String> tips;
  final String replacementGuidance;

  const BatteryHealthResult({
    required this.score,
    required this.confidence,
    required this.status,
    required this.estimatedLifespan,
    required this.keyIssues,
    required this.positives,
    required this.tips,
    required this.replacementGuidance,
  });
}
