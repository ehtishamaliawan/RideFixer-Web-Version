import 'package:flutter/foundation.dart';
import '../models/reminder.dart';
import '../services/database_service.dart';

class ReminderProvider with ChangeNotifier {
  List<Reminder> _reminders = [];
  final DatabaseService _dbService = DatabaseService();

  List<Reminder> get reminders => _reminders;

  Future<void> loadReminders() async {
    _reminders = await _dbService.getReminders();
    notifyListeners();
  }

  Future<void> addReminder(Reminder reminder) async {
    await _dbService.insertReminder(reminder);
    await loadReminders();
  }

  Future<void> updateReminder(Reminder reminder) async {
    await _dbService.updateReminder(reminder);
    await loadReminders();
  }

  bool hasDuplicateTitle({
    required int bikeId,
    required String title,
    int? excludeId,
  }) {
    final normalized = title.trim().toLowerCase();
    return _reminders.any(
      (r) =>
          r.bikeId == bikeId &&
          r.title.trim().toLowerCase() == normalized &&
          (excludeId == null || r.id != excludeId),
    );
  }

  Future<void> deleteReminder(int id) async {
    await _dbService.deleteReminder(id);
    await loadReminders();
  }
}
