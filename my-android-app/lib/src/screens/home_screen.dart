import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/notification_service.dart';
import '../services/bike_provider.dart';
import '../services/reminder_provider.dart';
import '../widgets/reset_reminder_dialog.dart';
import '../widgets/add_reminder_dialog.dart';
import '../widgets/brand_button.dart';
import '../widgets/app_back_button.dart';
import '../widgets/location_disclosure_dialog.dart';
import '../models/reminder.dart';
import '../models/bike.dart';

class HomeScreen extends StatefulWidget {
  final int bikeId;
  const HomeScreen({super.key, this.bikeId = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _remindersSectionKey = GlobalKey();

  void _scrollToReminders() {
    final ctx = _remindersSectionKey.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      alignment: 0.08,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final picker = ImagePicker();

    Widget headerActionButton({
      required IconData icon,
      required String tooltip,
      required VoidCallback onTap,
    }) {
      return Semantics(
        button: true,
        label: tooltip,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
      );
    }

    final bottomInset = MediaQuery.of(context).padding.bottom;
    // Clear space for the app's floating bottom navbar.
    const bottomNavClearance = 120.0;
    final listBottomPadding = bottomInset + bottomNavClearance;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Consumer2<BikeProvider, ReminderProvider>(
        builder: (context, bikeProvider, reminderProvider, child) {
          final bike = bikeProvider.bikes.firstWhere(
            (b) => b.id == widget.bikeId,
            orElse: () => Bike(name: 'Unknown Bike', id: -1),
          );

          final reminders = reminderProvider.reminders
              .where((r) => r.bikeId == widget.bikeId)
              .toList();

          return ListView(
            controller: _scrollController,
            padding: EdgeInsets.only(bottom: listBottomPadding),
            children: [
                // Professional Header
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 50, bottom: 32),
                      decoration: BoxDecoration(
                        gradient: AppTheme.headerGradient(context),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(48),
                          bottomRight: Radius.circular(48),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C63FF).withOpacity(0.3),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Header icons
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppBackButton(
                                  color: Colors.white,
                                ),
                                Row(
                                  children: [
                                    headerActionButton(
                                      icon: Icons.notifications_active_rounded,
                                      tooltip: 'Reminders',
                                      onTap: _scrollToReminders,
                                    ),
                                    const SizedBox(width: 10),
                                    headerActionButton(
                                      icon: Icons.settings_rounded,
                                      tooltip: 'App settings',
                                      onTap: () => context.go('/settings'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Bike avatar with shadow
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                // allow changing image
                              },
                              child: CircleAvatar(
                                radius: 56,
                                backgroundColor: Theme.of(context).colorScheme.surface,
                                child: bike.imagePath != null
                                    ? null
                                    : Icon(
                                        Icons.pedal_bike_rounded,
                                        size: 56,
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            bike.name,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                          ),
                          const SizedBox(height: 8),
                          // Total distance badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.speed_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${bike.totalDistance.round()} km',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const SizedBox(height: 16),
                          // Show overdue / next-due info with modern cards
                          Builder(
                            builder: (ctx) {
                              final now = DateTime.now();
                              final active = reminders.where((r) => !r.isCompleted).toList();
                              final overdue = active.where((r) {
                                final isDistanceOverdue = r.dueDistance > 0 && (r.dueDistance - bike.totalDistance) < 0;
                                final isTimeOverdue = r.dueDate != null && r.dueDate!.isBefore(now);
                                return isDistanceOverdue || isTimeOverdue;
                              }).toList();

                              if (overdue.isNotEmpty) {
                                // Show overdue alert card
                                final next = overdue.first;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade400.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.9),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.warning_rounded,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${overdue.length} part${overdue.length > 1 ? 's' : ''} overdue',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                next.title,
                                                style: TextStyle(
                                                  color: Colors.white.withOpacity(0.9),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              if (active.isNotEmpty) {
                                // Find the next due reminder
                                Reminder next = active.first;
                                double bestScore = double.infinity;
                                for (final r in active) {
                                  final remainingKm = r.dueDistance > 0
                                      ? (r.dueDistance - bike.totalDistance).abs().toDouble()
                                      : double.infinity;
                                  final remainingDays = r.dueDate != null
                                      ? r.dueDate!.difference(now).inDays.abs().toDouble()
                                      : double.infinity;
                                  final score = remainingKm < remainingDays ? remainingKm : remainingDays;
                                  if (score < bestScore) {
                                    bestScore = score;
                                    next = r;
                                  }
                                }

                                String subtitle;
                                Color statusColor = Colors.green;
                                if (next.dueDate != null) {
                                  final days = next.dueDate!.difference(now).inDays;
                                  if (days < 0) {
                                    subtitle = '${days.abs()} days overdue';
                                    statusColor = Colors.red;
                                  } else if (days == 0) {
                                    subtitle = 'Due today';
                                    statusColor = Colors.orange;
                                  } else if (days <= 7) {
                                    subtitle = 'Due in $days days';
                                    statusColor = Colors.orange;
                                  } else {
                                    subtitle = 'Due in $days days';
                                    statusColor = Colors.green;
                                  }
                                } else {
                                  final kmLeft = (next.dueDistance - bike.totalDistance).round();
                                  if (kmLeft <= 0) {
                                    subtitle = 'Overdue by ${kmLeft.abs()} km';
                                    statusColor = Colors.red;
                                  } else if (kmLeft <= 100) {
                                    subtitle = '$kmLeft km left';
                                    statusColor = Colors.orange;
                                  } else {
                                    subtitle = '$kmLeft km left';
                                    statusColor = Colors.green;
                                  }
                                }

                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.9),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.schedule_rounded,
                                            color: statusColor,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                next.title,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 14,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                subtitle,
                                                style: TextStyle(
                                                  color: Colors.white.withOpacity(0.9),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              // No reminders
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_circle_rounded,
                                        color: Colors.white.withOpacity(0.9),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'All maintenance up to date',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Padding(
                  key: _remindersSectionKey,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RideTrackerBanner(bike: bike),
                      const SizedBox(height: 16),
                      Text(
                        'Maintenance reminders',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      if (reminders.isEmpty)
                        _buildEmptyState(context)
                      else
                        ...reminders
                            .map((r) => _buildReminderCard(context, r, bike))
                            .toList(),
                      const SizedBox(height: 20),
                      BrandButton.primary(
                        label: 'Add Part',
                        icon: Icons.add_rounded,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AddReminderDialog(
                              initialBikeId: widget.bikeId,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    MaterialColor colorBase,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black26
                  : colorBase.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.6)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark
                    ? colorBase.withOpacity(0.18)
                    : colorBase.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.analytics, size: 16, color: colorBase),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderCard(
    BuildContext context,
    Reminder reminder,
    Bike bike,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Distance Calculation (dueDistance <= 0 means time-only, skip distance check)
    final hasDistanceTarget = reminder.dueDistance > 0;
    final remainingKm = hasDistanceTarget ? (reminder.dueDistance - bike.totalDistance).round() : 0;
    final isDistanceOverdue = hasDistanceTarget && remainingKm < 0;

    // Time Calculation
    String timeString = '';
    bool isTimeOverdue = false;
    int remainingDays = 9999;

    if (reminder.dueDate != null) {
      final now = DateTime.now();
      final difference = reminder.dueDate!.difference(now);
      remainingDays = difference.inDays;
      isTimeOverdue = difference.isNegative;

      if (remainingDays.abs() < 30) {
        timeString = '${remainingDays.abs()}d';
      } else {
        timeString = '${(remainingDays.abs() / 30).round()}m';
      }
    }

    // Determine Logic: specific Overdue takes precedence, then specific due soonest
    final isOverdue = isDistanceOverdue || isTimeOverdue;

    // Construct Display String
    // Construct Display String
    List<String> statusParts = [];

    // Distance Status (skip for time-only reminders)
    if (hasDistanceTarget) {
      if (isDistanceOverdue) {
        statusParts.add('${remainingKm.abs()} km overdue');
      } else {
        statusParts.add('$remainingKm km left');
      }
    }

    // Time Status
    if (reminder.dueDate != null) {
      final days = remainingDays.abs();
      final unit = days == 1 ? 'day' : 'days';

      if (isTimeOverdue) {
        statusParts.add('$days $unit overdue');
      } else {
        statusParts.add('$days $unit left');
      }
    }

    String statusText = statusParts.join(' • ');

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => ResetReminderDialog(
            reminder: reminder,
            onReset: (newIntervalKm, newDate) {
              final newDueDistance = bike.totalDistance + newIntervalKm;
              final updatedReminder = reminder.copyWith(
                dueDistance: newDueDistance,
                dueDate: newDate,
                isCompleted: false,
              );
              Provider.of<ReminderProvider>(
                context,
                listen: false,
              ).updateReminder(updatedReminder);
            },
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black26
                  : const Color(0xFF6C63FF).withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.6)),
        ),
        child: Row(
          children: [
            Container(
              width: 56, // Fixed width for container
              height: 56,
              padding: reminder.imagePath == null
                  ? const EdgeInsets.all(12)
                  : EdgeInsets.zero,
              decoration: BoxDecoration(
                color: isDark
                  ? (isOverdue
                    ? Colors.red.withOpacity(0.18)
                    : colorScheme.primary.withOpacity(0.14))
                  : (isOverdue
                    ? const Color(0xFFFFEBEE)
                    : const Color(0xFFF3E5F5)),
                shape: BoxShape.circle,
                image: reminder.imagePath != null
                    ? DecorationImage(
                        image: MemoryImage(base64Decode(reminder.imagePath!)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: reminder.imagePath == null
                  ? Icon(
                      Icons.build_rounded,
                      color: isOverdue ? Colors.red : const Color(0xFF6C63FF),
                      size: 24,
                    )
                  : null,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    statusText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isOverdue
                          ? colorScheme.error
                          : colorScheme.onSurfaceVariant,
                      fontWeight: isOverdue ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // "Active" pill replaced with specific status pill if needed, or removed for cleaner look.
                  // Let's use a subtle status indicator
                  if (!isOverdue)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.teal.withOpacity(0.18)
                            : const Color(0xFFE0F2F1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Active',
                        style: TextStyle(
                          color: isDark
                              ? Colors.tealAccent.shade100
                              : const Color(0xFF009688),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  if (isOverdue)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE), // Red 50
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Maintenance Required',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            IconButton(
              icon: Icon(Icons.edit, color: colorScheme.onSurfaceVariant, size: 20),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddReminderDialog(reminder: reminder),
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
                size: 20,
              ),
              onPressed: () async {
                final shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete part?'),
                    content: Text('Remove ${reminder.title}?'),
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
                  ),
                );

                if (shouldDelete == true && reminder.id != null) {
                  await context.read<ReminderProvider>().deleteReminder(
                    reminder.id!,
                  );
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Part removed')));
                }
              },
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: colorScheme.onSurfaceVariant,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text('No reminders yet', style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
}

class RideTrackerBanner extends StatefulWidget {
  final Bike bike;
  const RideTrackerBanner({super.key, required this.bike});

  @override
  State<RideTrackerBanner> createState() => _RideTrackerBannerState();
}

class _RideTrackerBannerState extends State<RideTrackerBanner>
    with WidgetsBindingObserver {
  static const _fgCh = MethodChannel('ridefixer/foreground');

  StreamSubscription<Position>? _rideSub;
  Position? _lastRide;
  double _meters = 0;
  Timer? _idleTimer;
  Timer? _notifTimer;
  Bike? _activeBike;

  bool get _isTracking => _rideSub != null;

  /// Reads live service state from native via MethodChannel.
  /// This bypasses the SharedPreferences namespace mismatch — native code writes
  /// to "ridefixer" prefs while Flutter reads from "FlutterSharedPreferences".
  Future<Map<String, dynamic>> _nativeStatus() async {
    try {
      final raw = await _fgCh.invokeMethod<Map<Object?, Object?>>('getStatus');
      return raw?.map((k, v) => MapEntry(k.toString(), v)) ?? {};
    } catch (_) {
      return {};
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When the app returns to the foreground during an active ride, sync
    // _meters from the native service which tracked while we were backgrounded.
    if (state == AppLifecycleState.resumed && _isTracking) {
      _syncMetersFromNative();
    }
  }

  Future<void> _syncMetersFromNative() async {
    try {
      final st = await _nativeStatus();
      final fgMeters = (st['fg_meters'] as num?)?.toDouble() ?? 0.0;
      if (fgMeters > _meters && mounted) {
        setState(() => _meters = fgMeters);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _rideSub?.cancel();
    _idleTimer?.cancel();
    _notifTimer?.cancel();
    super.dispose();
  }



  Future<void> _consumeUnsavedRideIfAny() async {
    try {
      // Read from native "ridefixer" prefs via MethodChannel (not Flutter prefs
      // which are stored in a different SharedPreferences namespace).
      final st = await _nativeStatus();
      final unsaved = (st['fg_unsaved'] as bool?) ?? false;
      if (!unsaved) return;

      final bikeId = (st['fg_unsaved_bikeId'] as int?) ?? 0;
      final meters = (st['fg_unsaved_meters'] as num?)?.toDouble() ?? 0.0;
      if (bikeId <= 0 || meters <= 1) {
        try { await _fgCh.invokeMethod('clearUnsaved'); } catch (_) {}
        return;
      }

      final kmDelta = meters / 1000.0;
      final bp = context.read<BikeProvider>();
      Bike? bike;
      try {
        bike = bp.bikes.firstWhere((b) => b.id == bikeId);
      } catch (_) {
        bike = null;
      }
      if (bike != null) {
        await bp.updateBike(bike.copyWith(totalDistance: bike.totalDistance + kmDelta));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Unsaved ride recovered: ${kmDelta.toStringAsFixed(2)} km')),
          );
        }
      }

      // Clear the unsaved entry from native prefs.
      try { await _fgCh.invokeMethod('clearUnsaved'); } catch (_) {}
      // Also remove Flutter-side fg_meters if it was stored.
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('fg_meters');
      } catch (_) {}
    } catch (_) {}
  }

  Future<bool> _ensurePermission() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied')),
        );
      }
      return false;
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enable location services to track rides'),
          ),
        );
      }
      return false;
    }
    return true;
  }

  void _startIdleTimer() {
    _idleTimer?.cancel();
    _idleTimer = Timer(const Duration(minutes: 2), () {
      if (mounted && _isTracking) {
        _stopTracking(save: true);
      }
    });
  }

  Future<void> _startTracking() async {
    if (_isTracking) return;
    // Show Google Play-compliant location disclosure the first time.
    final accepted = await showLocationDisclosure(context, forRideTracking: true);
    if (!accepted) return;
    if (!await _ensurePermission()) return;

    _meters = 0;
    _lastRide = null;
    _activeBike = widget.bike;

    final settings = Platform.isAndroid
        ? AndroidSettings(accuracy: LocationAccuracy.high, distanceFilter: 10)
        : const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          );

    _rideSub = Geolocator.getPositionStream(locationSettings: settings).listen(
      (position) {
        try {
          // --- accuracy filter ---
          // Only accept fixes with accuracy <= 10 m.
          if (position.accuracy > 10) {
            _lastRide = null;
            return;
          }

          // --- sensor speed filter ---
          // If the phone's fused speed is < 0.8 m/s (~3 km/h) the user is
          // stationary or barely moving — not riding a bike.
          if (position.speed >= 0 && position.speed < 0.8) {
            _lastRide = position;
            return;
          }

          if (_lastRide != null) {
            final delta = Geolocator.distanceBetween(
              _lastRide!.latitude,
              _lastRide!.longitude,
              position.latitude,
              position.longitude,
            );

            final timeDeltaSec = position.timestamp
                .difference(_lastRide!.timestamp)
                .inMilliseconds / 1000.0;
            final impliedSpeed = timeDeltaSec > 0 ? delta / timeDeltaSec : 0.0;

            // delta >= 10 m AND speed reasonable (< 20 m/s = 72 km/h)
            if (delta >= 10 && impliedSpeed < 20) {
              _meters += delta;
              _startIdleTimer();
            }
          }
          _lastRide = position;
          if (mounted) setState(() {});
        } catch (e, st) {
          // ignore: avoid_print
          print('TRACKER: exception in listener: $e\n$st');
        }
      },
      onError: (err) async {
        // Debug: log error and stop tracking
        // ignore: avoid_print
        print('TRACKER: position stream error: $err');
        await _stopTracking(save: false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ride tracking stopped due to an error'),
            ),
          );
        }
      },
    );

    _startIdleTimer();
    // Also start native foreground service so tracking survives app kill
    try {
      // Cancel any Flutter-created tracking notification first to avoid duplicates
      await NotificationService().cancelTrackingNotification();
      const ch = MethodChannel('ridefixer/foreground');
      await ch.invokeMethod('start', {
        'bikeId': _activeBike?.id ?? 0,
      });
    } catch (_) {}
    // Persist active ride state AFTER cancelTrackingNotification so it cannot
    // be wiped by that call. This flag is read by _resumeIfActive on app restart.
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('ride_active', true);
      await prefs.setInt('ride_bikeId', _activeBike?.id ?? 0);
    } catch (_) {}
    // Give the native service a short moment to start and set `fg_running`.
    // Poll via MethodChannel (reads native "ridefixer" prefs, avoiding the
    // SharedPreferences namespace mismatch that made this check always fail).
    try {
      bool fgRunning = false;
      for (var i = 0; i < 10; i++) {
        final st = await _nativeStatus();
        fgRunning = (st['fg_running'] as bool?) ?? false;
        if (fgRunning) break;
        await Future.delayed(const Duration(milliseconds: 100));
      }
      if (!fgRunning) {
        await NotificationService().showOrUpdateTrackingNotification(
          body: '${(_meters / 1000).toStringAsFixed(2)} km',
          payload: 'track:bikeId=${_activeBike?.id ?? 0}',
        );
        _notifTimer?.cancel();
        _notifTimer = Timer.periodic(const Duration(minutes: 1), (_) {
          final km = (_meters / 1000).toStringAsFixed(2);
          NotificationService().showOrUpdateTrackingNotification(
            body: '$km km',
            payload: 'track:bikeId=${_activeBike?.id ?? 0}',
          );
        });
      }
    } catch (_) {
      await NotificationService().showOrUpdateTrackingNotification(
        body: '${(_meters / 1000).toStringAsFixed(2)} km',
        payload: 'track:bikeId=${_activeBike?.id ?? 0}',
      );
      _notifTimer?.cancel();
      _notifTimer = Timer.periodic(const Duration(minutes: 1), (_) {
        final km = (_meters / 1000).toStringAsFixed(2);
        NotificationService().showOrUpdateTrackingNotification(
          body: '$km km',
          payload: 'track:bikeId=${_activeBike?.id ?? 0}',
        );
      });
    }
    if (mounted) setState(() {});
  }

  Future<void> _stopTracking({bool save = true}) async {
    await _rideSub?.cancel();
    _rideSub = null;
    _idleTimer?.cancel();
    _lastRide = null;
    _notifTimer?.cancel();
    _notifTimer = null;
    await NotificationService().cancelTrackingNotification();
    // Prefer whichever source accumulated more distance: native service tracks
    // reliably in background while Flutter may have been throttled.
    try {
      final st = await _nativeStatus();
      final fgMeters = (st['fg_meters'] as num?)?.toDouble() ?? 0.0;
      if (fgMeters > _meters) {
        _meters = fgMeters;
      }
    } catch (_) {}

    if (save && _meters > 1) {
      final kmDelta = _meters / 1000;
      final target = _activeBike ?? widget.bike;
      final updated = target.copyWith(
        totalDistance: target.totalDistance + kmDelta,
      );
      await context.read<BikeProvider>().updateBike(updated);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ride saved: ${kmDelta.toStringAsFixed(2)} km'),
          ),
        );
      }
    }

    // Clear persisted active ride state
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('ride_active');
      await prefs.remove('ride_bikeId');
    } catch (_) {}

    // Stop native foreground service
    try {
      const ch = MethodChannel('ridefixer/foreground');
      await ch.invokeMethod('stop');
    } catch (_) {}

    if (mounted) setState(() => _meters = 0);
    // Reset active bike to the displayed bike
    _activeBike = widget.bike;
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() async {
      await _consumeUnsavedRideIfAny();
      await _resumeIfActive();
    });
  }

  /// If a ride was active when the app was closed/killed, re-attach the GPS
  /// stream so the UI shows "Stop Ride" and tracking continues seamlessly.
  Future<void> _resumeIfActive() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final active = prefs.getBool('ride_active') ?? false;
      if (!active || _isTracking) return;

      final bikeId = prefs.getInt('ride_bikeId') ?? 0;
      // Restore active bike reference
      if (mounted) {
        final bp = context.read<BikeProvider>();
        try {
          _activeBike = bp.bikes.firstWhere((b) => b.id == bikeId);
        } catch (_) {
          _activeBike = widget.bike;
        }
      } else {
        _activeBike = widget.bike;
      }

      // Restore any meters already tracked by the native foreground service
      // via MethodChannel (avoids SharedPreferences namespace mismatch).
      final st = await _nativeStatus();
      _meters = (st['fg_meters'] as num?)?.toDouble() ?? 0.0;

      final settings = Platform.isAndroid
          ? AndroidSettings(accuracy: LocationAccuracy.high, distanceFilter: 10)
          : const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 10,
            );

      _rideSub = Geolocator.getPositionStream(locationSettings: settings).listen(
        (position) {
          try {
            // --- accuracy filter (mirrors _startTracking) ---
            if (position.accuracy > 10) {
              _lastRide = null;
              return;
            }

            // --- sensor speed filter ---
            if (position.speed >= 0 && position.speed < 0.8) {
              _lastRide = position;
              return;
            }

            if (_lastRide != null) {
              final delta = Geolocator.distanceBetween(
                _lastRide!.latitude,
                _lastRide!.longitude,
                position.latitude,
                position.longitude,
              );
              final timeDeltaSec = position.timestamp
                  .difference(_lastRide!.timestamp)
                  .inMilliseconds / 1000.0;
              final impliedSpeed = timeDeltaSec > 0 ? delta / timeDeltaSec : 0.0;

              if (delta >= 10 && impliedSpeed < 20) {
                _meters += delta;
                _startIdleTimer();
              }
            }
            _lastRide = position;
            if (mounted) setState(() {});
          } catch (_) {}
        },
        onError: (_) async {
          await _stopTracking(save: false);
        },
      );

      _startIdleTimer();
      if (mounted) setState(() {});
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final km = _meters / 1000;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : const Color(0xFF6C63FF).withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ride Tracking',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? (_isTracking
                          ? Colors.green.withOpacity(0.18)
                          : colorScheme.surface.withOpacity(0.7))
                      : (_isTracking
                          ? const Color(0xFFE8F5E9)
                          : const Color(0xFFFFF8E1)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _isTracking ? 'Tracking' : 'Idle',
                  style: TextStyle(
                    color: isDark
                        ? (_isTracking
                            ? Colors.greenAccent.shade100
                            : colorScheme.onSurfaceVariant)
                        : (_isTracking
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFFF9A825)),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _isTracking
                ? 'Recording ride distance using GPS. You can lock the screen; a foreground notification keeps tracking on Android.'
                : 'Tap start to record your next ride using GPS.',
            style: TextStyle(color: colorScheme.onSurfaceVariant, height: 1.4),
          ),
          const SizedBox(height: 16),

          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Distance this ride',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${km.toStringAsFixed(2)} km',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 160,
                child: _isTracking
                    ? BrandButton.destructive(
                        label: 'Stop ride',
                        icon: Icons.stop_rounded,
                        onPressed: _stopTracking,
                      )
                    : BrandButton.primary(
                        label: 'Start ride',
                        icon: Icons.play_arrow_rounded,
                        onPressed: _startTracking,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
