import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../config/parts_config.dart';
import '../models/bike.dart';
import '../services/bike_provider.dart';
import '../widgets/bike_card.dart';
import '../widgets/app_back_button.dart';
import 'add_bike_onboarding.dart';
import '../services/reminder_provider.dart';
import '../models/reminder.dart';
import 'ebike_error_screen.dart';

class BikeListScreen extends StatefulWidget {
  const BikeListScreen({super.key});

  @override
  State<BikeListScreen> createState() => _BikeListScreenState();
}

class _BikeListScreenState extends State<BikeListScreen> {
  @override
  Widget build(BuildContext context) {
    const double headerHeight = 220;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Future<void> handleBack() async {
      final router = GoRouter.of(context);
      if (router.canPop()) {
        router.pop();
        return;
      }
      router.go('/home');
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        handleBack();
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: Stack(
          children: [
          // Background Gradient Header
          Container(
            height: headerHeight,
            decoration: BoxDecoration(
              gradient: AppTheme.headerGradient(context),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(48),
                bottomRight: Radius.circular(48),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C63FF).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
          ),

          

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Content
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBackButton(
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'My Garage',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Manage your fleet',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),

                    ],
                  ),
                ),

                // List Content
                Expanded(
                  child: Consumer<BikeProvider>(
                    builder: (context, provider, child) {
                      if (provider.bikes.isEmpty) {
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.only(top: headerHeight * 0.5),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(32),
                                    decoration: BoxDecoration(
                                      color: colorScheme.surface,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: isDark
                                              ? Colors.black26
                                              : Colors.indigo.withOpacity(0.1),
                                          blurRadius: 30,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.pedal_bike_rounded,
                                      size: 80,
                                      color: const Color(0xFF6C63FF).withOpacity(0.5),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'No bikes found',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onSurface,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: 250,
                                    child: Text(
                                      'Add your first ride to start tracking maintenance.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: colorScheme.onSurfaceVariant,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      final reminderProvider = context.watch<ReminderProvider>();
                      final now = DateTime.now();

                      return ListView.separated(
                        padding: EdgeInsets.fromLTRB(
                          24,
                          headerHeight * 0.3,
                          24,
                          MediaQuery.of(context).padding.bottom + 80,
                        ),
                        itemCount: provider.bikes.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          final bike = provider.bikes[index];
                          final remindersForBike = reminderProvider.reminders
                              .where((r) => r.bikeId == bike.id)
                              .toList();

                          final overdueList = remindersForBike.where((r) {
                            final isDistanceOverdue = r.dueDistance > 0 && (r.dueDistance - bike.totalDistance) < 0;
                            final isTimeOverdue = r.dueDate != null && r.dueDate!.isBefore(now);
                            return !r.isCompleted && (isDistanceOverdue || isTimeOverdue);
                          }).toList();

                          final overdueCount = overdueList.length;

                          String? subtitle;
                          String? statusLabel;
                          Color? statusColor;

                          if (overdueCount > 0) {
                            subtitle = '$overdueCount overdue';
                            statusLabel = overdueList.first.title;
                            statusColor = Colors.red.shade700;
                          } else if (remindersForBike.isNotEmpty) {
                            Reminder next = remindersForBike.first;
                            double bestScore = double.infinity;
                            for (final r in remindersForBike) {
                              if (r.isCompleted) continue;
                              final remainingDays = r.dueDate != null
                                  ? r.dueDate!.difference(now).inDays.abs().toDouble()
                                  : double.infinity;
                              final remainingKm = r.dueDistance > 0
                                  ? (r.dueDistance - bike.totalDistance).abs().toDouble()
                                  : double.infinity;
                              final score = remainingDays < remainingKm ? remainingDays : remainingKm;
                              if (score < bestScore) {
                                bestScore = score;
                                next = r;
                              }
                            }

                            subtitle = 'Next: ${next.title}';
                            if (next.dueDate != null) {
                              final days = next.dueDate!.difference(now).inDays;
                              if (days < 0) {
                                statusLabel = '${days.abs()}d overdue';
                                statusColor = Colors.red.shade700;
                              } else if (days == 0) {
                                statusLabel = 'Due today';
                                statusColor = Colors.red.shade700;
                              } else if (days <= 7) {
                                statusLabel = 'Due in ${days}d';
                                statusColor = Colors.orange.shade700;
                              } else if (days > 30) {
                                statusLabel = 'Due in ${days}d';
                                statusColor = Colors.green.shade700;
                              } else {
                                statusLabel = 'Due in ${days}d';
                                statusColor = Colors.grey.shade700;
                              }
                            } else {
                              final kmLeft = (next.dueDistance - bike.totalDistance).round();
                              if (kmLeft <= 0) {
                                statusLabel = 'Overdue ${kmLeft.abs()} km';
                                statusColor = Colors.red.shade700;
                              } else if (kmLeft <= 100) {
                                statusLabel = '$kmLeft km left';
                                statusColor = Colors.orange.shade700;
                              } else {
                                statusLabel = '$kmLeft km left';
                                statusColor = Colors.green.shade700;
                              }
                            }
                          }

                          return BikeCard(
                            bike: bike,
                            overdueCount: overdueCount,
                            subtitle: subtitle,
                            statusLabel: statusLabel,
                            statusColor: statusColor,
                            onTap: () => context.push('/garage/dashboard/${bike.id}'),
                            onDelete: () => provider.deleteBike(bike.id!),
                            onEdit: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AddBikeOnboarding(initialBike: bike),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Floating Action Button
          Positioned(
            bottom: 140,
            right: 24,
            child: Container(
              decoration: BoxDecoration(
                gradient: AppTheme.headerGradient(context),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(isDark ? 0.22 : 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: FloatingActionButton.extended(
                heroTag: 'addBikeFab',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AddBikeOnboarding()),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                label: const Text(
                  'Add Bike',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }

  Future<void> _addSampleBikes(BuildContext context) async {
    final types = ['Bike', 'E-Bike'];
    final bikeProvider = Provider.of<BikeProvider>(context, listen: false);
    final reminderProvider = Provider.of<ReminderProvider>(
      context,
      listen: false,
    );
    final Map<String, int> created = {};
    for (final t in types) {
      final bike = Bike(name: 'Sample $t', type: t, totalDistance: 0.0);
      final id = await bikeProvider.addBike(bike);
      var count = 0;
      final parts = partsConfig[t] ?? partsConfig['Bike']!;
      final now = DateTime.now();
      final mileage = 0;
      for (final p in parts) {
        final title = p['title'] as String;
        final double delta = (p['distance'] is num)
            ? (p['distance'] as num).toDouble()
            : 0.0;
        final int months = (p['months'] is int)
            ? p['months'] as int
            : (p['months'] is num ? (p['months'] as num).toInt() : 0);
        final dueDate = months > 0
            ? now.add(Duration(days: months * 30))
            : null;
        await reminderProvider.addReminder(
          Reminder(
            bikeId: id,
            title: title,
            dueDistance: mileage + delta,
            dueDate: dueDate,
          ),
        );
        count++;
      }
      created[t] = count;
    }
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Added sample bikes: $created')));
    }
  }
}
