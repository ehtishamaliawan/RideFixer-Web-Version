import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/bike_provider.dart';
import '../services/reminder_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/add_reminder_dialog.dart';

class ReminderListScreen extends StatefulWidget {
  const ReminderListScreen({super.key});

  @override
  State<ReminderListScreen> createState() => _ReminderListScreenState();
}

class _ReminderListScreenState extends State<ReminderListScreen> {
  bool _requestedLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_requestedLoad) return;

    _requestedLoad = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      try {
        await Future.wait([
          context.read<BikeProvider>().loadBikes(),
          context.read<ReminderProvider>().loadReminders(),
        ]);
      } catch (_) {
        // Ignore - UI will show existing data.
      }
    });
  }

  Future<void> _confirmDelete({required int id, required String title}) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete reminder?'),
          content: Text('Delete "$title"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      await context.read<ReminderProvider>().deleteReminder(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Space so the last card scrolls above the floating bottom nav.
    final bottomInset = MediaQuery.of(context).padding.bottom;
    const bottomNavClearance = 110.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Reminders'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppTheme.headerGradient(context)),
        ),
      ),
      body: Consumer2<ReminderProvider, BikeProvider>(
        builder: (context, reminderProvider, bikeProvider, child) {
          final reminders = reminderProvider.reminders;

          if (reminders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off_rounded,
                      size: 80,
                      color: colorScheme.outline,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No reminders set',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => const AddReminderDialog(),
                        );
                      },
                      icon: const Icon(Icons.add_alert),
                      label: const Text('Add Reminder'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + bottomNavClearance),
            itemCount: reminders.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final reminder = reminders[index];
              final bike = bikeProvider.bikes
                  .where((b) => b.id == reminder.bikeId)
                  .cast<dynamic>()
                  .toList()
                  .isNotEmpty
                  ? bikeProvider.bikes.firstWhere((b) => b.id == reminder.bikeId)
                  : null;

              final remainingKm = bike == null
                  ? null
                  : (reminder.dueDistance - bike.totalDistance);

              final isOverdue = remainingKm != null && remainingKm <= 0;
              final distanceLabel = remainingKm == null
                  ? 'Bike not found'
                  : isOverdue
                      ? 'Overdue by ${(-remainingKm).toStringAsFixed(0)} km'
                      : '${remainingKm.toStringAsFixed(0)} km left';

              final dueDate = reminder.dueDate;
              final dueDateLabel = dueDate == null
                  ? null
                  : '${dueDate.day.toString().padLeft(2, '0')}/${dueDate.month.toString().padLeft(2, '0')}/${dueDate.year}';

              return Card(
                elevation: 0,
                color: colorScheme.surfaceContainerHighest,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              reminder.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Edit',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AddReminderDialog(reminder: reminder),
                              );
                            },
                            icon: const Icon(Icons.edit_rounded),
                          ),
                          if (reminder.id != null)
                            IconButton(
                              tooltip: 'Delete',
                              onPressed: () => _confirmDelete(
                                id: reminder.id!,
                                title: reminder.title,
                              ),
                              icon: const Icon(Icons.delete_outline_rounded),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      if (bike != null)
                        Text(
                          bike.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _Pill(
                            icon: Icons.route_rounded,
                            label: distanceLabel,
                            color: isOverdue ? colorScheme.error : colorScheme.primary,
                          ),
                          if (dueDateLabel != null)
                            _Pill(
                              icon: Icons.calendar_month_rounded,
                              label: dueDateLabel,
                              color: colorScheme.tertiary,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const AddReminderDialog(),
          );
        },
        icon: const Icon(Icons.add_alert),
        label: const Text('Add Reminder'),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _Pill({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
