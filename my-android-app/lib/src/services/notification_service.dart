import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reminder.dart';
import '../models/bike.dart';

class NotificationService {
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  String? _lastPayload;

  /// Initialize notifications. Optionally provide a navigator key (not required).
  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) async {
        try {
          _lastPayload = response.payload;
          final payload = response.payload ?? '';
          if (payload.startsWith('track:bikeId=')) {
            final parts = payload.split('=');
            final id = int.tryParse(parts.length > 1 ? parts[1] : '') ?? 0;
            if (id > 0) {
              try {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('ride_active', true);
                await prefs.setInt('ride_bikeId', id);
              } catch (_) {}
            }
          }
        } catch (_) {}
      },
    );

    // Android permission (Android 13+); ignored on other platforms
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  /// Consume and clear the last notification payload (if any).
  String? consumeLastPayload() {
    final p = _lastPayload;
    _lastPayload = null;
    return p;
  }

  /// Schedule one daily notification if there are overdue reminders. Cancels existing if none.
  Future<void> scheduleDailyOverdueReminder({
    required List<Reminder> reminders,
    required List<Bike> bikes,
  }) async {
    // Backward compatible entrypoint (older call sites). The app now uses weekly
    // cadence for overdue reminders.
    return scheduleWeeklyOverdueReminder(reminders: reminders, bikes: bikes);
  }

  /// Schedule one weekly notification if there are overdue reminders. Cancels existing if none.
  Future<void> scheduleWeeklyOverdueReminder({
    required List<Reminder> reminders,
    required List<Bike> bikes,
  }) async {
    if (!_initialized) await init();

    final bikeById = {for (final b in bikes) b.id: b};

    final overdue = reminders.where((r) {
      if (r.isCompleted) return false;
      final bike = bikeById[r.bikeId];
      if (bike == null) return false;
      final isDistanceOverdue = r.dueDistance > 0 && (r.dueDistance - bike.totalDistance) < 0;
      final isTimeOverdue =
          r.dueDate != null && r.dueDate!.isBefore(DateTime.now());
      return isDistanceOverdue || isTimeOverdue;
    }).toList();

    if (overdue.isEmpty) {
      await _plugin.cancel(_notificationId);
      return;
    }

    final titles = overdue.take(3).map((r) => r.title).toList();
    final titleText = overdue.length == 1
        ? '1 part is overdue'
        : '${overdue.length} parts are overdue';
    final bodyText = titles.join(', ');

    final scheduleTime = _nextRandomWeeklyNightTime();

    // If we already scheduled a future weekly reminder, don't reschedule.
    try {
      final prefs = await SharedPreferences.getInstance();
      final prevType = prefs.getString('overdue_schedule_type');
      final prevMs = prefs.getInt('overdue_scheduled_at');
      if (prevType == 'weekly' && prevMs != null) {
        final prev = DateTime.fromMillisecondsSinceEpoch(prevMs, isUtc: true);
        if (prev.isAfter(DateTime.now().toUtc())) {
          return;
        }
      }
    } catch (_) {}

    // Cancel any previous overdue notification before scheduling a new one
    // so the platform has only a single scheduled instance with our id.
    await _plugin.cancel(_notificationId);

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      'Overdue Maintenance',
      channelDescription: 'Weekly reminder when parts are overdue',
      importance: Importance.high,
      priority: Priority.high,
    );

    try {
      await _plugin.zonedSchedule(
        _notificationId,
        titleText,
        bodyText,
        scheduleTime,
        const NotificationDetails(android: androidDetails),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('overdue_scheduled_at', scheduleTime.toUtc().millisecondsSinceEpoch);
        await prefs.setString('overdue_schedule_type', 'weekly');
      } catch (_) {}
      // ignore: avoid_print
      print('NOTIF: scheduled weekly overdue at $scheduleTime title="$titleText" body="$bodyText"');
    } catch (e) {
      // If scheduling fails (e.g., no exact alarm permission), skip scheduling.
      // Optionally: fall back to immediate show.
      // ignore: avoid_print
      print('NOTIF: scheduleWeeklyOverdueReminder failed: $e');
    }
  }

  tz.TZDateTime _nextRandomWeeklyNightTime() {
    final now = tz.TZDateTime.now(tz.local);
    final rng = Random(now.millisecondsSinceEpoch);

    // Pick a random day within the next 7 days.
    final addDays = rng.nextInt(7);
    final base = now.add(Duration(days: addDays));

    final hour = 20 + rng.nextInt(3); // 20,21,22
    final minute = rng.nextInt(60);
    var scheduled = tz.TZDateTime(
      tz.local,
      base.year,
      base.month,
      base.day,
      hour,
      minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  tz.TZDateTime _nextRandomNightTime() {
    final now = tz.TZDateTime.now(tz.local);
    final rng = Random(now.millisecondsSinceEpoch);
    final hour = 20 + rng.nextInt(3); // 20,21,22
    final minute = rng.nextInt(60);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  Future<void> showTestNotification() async {
    if (!_initialized) await init();

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      'Overdue Maintenance',
      channelDescription: 'Weekly reminder when parts are overdue',
      importance: Importance.high,
      priority: Priority.high,
    );

    await _plugin.show(
      _notificationId,
      'Notifications are enabled',
      'RideFixer will remind you about overdue maintenance.',
      const NotificationDetails(android: androidDetails),
    );
  }

  static const _notificationId = 9001;
  static const _channelId = 'overdue_maintenance_channel';

  // Tracking notification defaults
  static const trackingNotificationId = 10002;
  static const trackingChannelId = 'ride_tracking_channel';

  Future<void> showOrUpdateTrackingNotification({
    int id = trackingNotificationId,
    String? title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized) await init();

    final androidDetails = AndroidNotificationDetails(
      trackingChannelId,
      'Ride Tracking',
      channelDescription: 'Ongoing ride tracking',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      onlyAlertOnce: true,
      playSound: false,
    );

    await _plugin.show(
      id,
      title ?? 'Ride tracking active',
      body,
      NotificationDetails(android: androidDetails),
      payload: payload,
    );
    // Debug logging
    // ignore: avoid_print
    print('NOTIF: showOrUpdateTrackingNotification id=$id body="$body" payload="$payload"');
  }

  Future<void> cancelTrackingNotification({
    int id = trackingNotificationId,
  }) async {
    if (!_initialized) await init();
    await _plugin.cancel(id);
    // Do NOT remove ride_active here — that is _stopTracking()'s responsibility.
    // Removing it here would wipe the flag while a ride is still active,
    // preventing ride state from being restored after app backgrounding/kill.
  }

  /// Cancel the overdue/daily notification (used when user mutes notifications).
  Future<void> cancelOverdueNotification() async {
    if (!_initialized) await init();
    await _plugin.cancel(_notificationId);
  }

  /// Show an overdue notification immediately (used for debugging / manual test).
  Future<void> showOverdueNow({required String title, required String body}) async {
    if (!_initialized) await init();

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      'Overdue Maintenance',
      channelDescription: 'Weekly reminder when parts are overdue',
      importance: Importance.high,
      priority: Priority.high,
    );

    try {
      await _plugin.show(
        _notificationId,
        title,
        body,
        const NotificationDetails(android: androidDetails),
      );
      // ignore: avoid_print
      print('NOTIF: show overdue now title="$title" body="$body"');
    } catch (e) {
      // ignore: avoid_print
      print('NOTIF: showOverdueNow failed: $e');
    }
  }
}
