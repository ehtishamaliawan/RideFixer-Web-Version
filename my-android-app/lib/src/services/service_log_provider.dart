import 'package:flutter/material.dart';
import '../models/service_log.dart';
import 'database_service.dart';

class ServiceLogProvider with ChangeNotifier {
  List<ServiceLog> _logs = [];
  List<ServiceLog> get logs => _logs;

  final DatabaseService _dbService = DatabaseService();

  Future<void> loadLogs(int bikeId) async {
    _logs = await _dbService.getServiceLogs(bikeId);
    notifyListeners();
  }

  Future<void> addLog(ServiceLog log) async {
    await _dbService.addServiceLog(log);
    await loadLogs(log.bikeId);
  }
}
