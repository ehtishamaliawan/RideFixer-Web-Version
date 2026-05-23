import 'package:flutter/foundation.dart';
import '../models/bike.dart';
import '../services/database_service.dart';

class BikeProvider with ChangeNotifier {
  List<Bike> _bikes = [];
  final DatabaseService _dbService = DatabaseService();
  bool _loading = true;

  bool get loading => _loading;

  List<Bike> get bikes => _bikes;

  Future<void> loadBikes({bool showGlobalLoader = false}) async {
    if (showGlobalLoader) {
      _loading = true;
      notifyListeners();
    }
    try {
      _bikes = await _dbService.getBikes();
    } finally {
      if (showGlobalLoader) {
        _loading = false;
      }
      notifyListeners();
    }
  }

  Future<int> addBike(Bike bike) async {
    print('Provider adding bike: ${bike.name}');
    final id = await _dbService.insertBike(bike);
    print('Bike inserted into DB with ID: $id');
    await loadBikes();
    return id;
  }

  Future<void> updateBike(Bike bike) async {
    await _dbService.updateBike(bike);
    await loadBikes();
  }

  Future<void> deleteBike(int id) async {
    await _dbService.deleteBike(id);
    await loadBikes();
  }
}
