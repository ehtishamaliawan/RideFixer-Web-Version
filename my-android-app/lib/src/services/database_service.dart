import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/bike.dart';
import '../models/reminder.dart';
import '../models/service_log.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  bool _useMock = false;
  final List<Bike> _mockBikes = [];
  final List<Reminder> _mockReminders = [];

  Future<Database> get database async {
    if (_useMock) throw Exception('Using Mock DB');
    if (_database != null) return _database!;
    try {
      _database = await _initDatabase();
      return _database!;
    } catch (e) {
      print('Database initialization failed: $e');
      print('Falling back to in-memory storage.');
      _useMock = true;
      throw Exception('Using Mock DB');
    }
  }

  Future<Database> _initDatabase() async {
    try {
      final path = join(await getDatabasesPath(), 'ridefixer.db');
      return await openDatabase(
        path,
        version: 3,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      // Re-throw to trigger fallback in getter
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS bikes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        brand TEXT,
        model TEXT,
        type TEXT,
        imagePath TEXT,
        totalDistance REAL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS reminders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bikeId INTEGER,
        title TEXT,
        dueDistance REAL,
        dueDate TEXT,
        isCompleted INTEGER,
        imagePath TEXT
      )
    ''');
    // Add service_logs table creation
    await db.execute('''
      CREATE TABLE IF NOT EXISTS service_logs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bikeId INTEGER,
        title TEXT,
        date TEXT,
        cost REAL,
        notes TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add imagePath to reminders if migrating from v1
      await db.execute('ALTER TABLE reminders ADD COLUMN imagePath TEXT');
    }
    if (oldVersion < 3) {
      // Add 'type' column to bikes for new bike types
      try {
        await db.execute(
          'ALTER TABLE bikes ADD COLUMN type TEXT DEFAULT "Bike"',
        );
      } catch (_) {}
    }
    if (oldVersion < 4) {
      // Create service_logs table if migrating from v3 or earlier
      await db.execute('''
        CREATE TABLE IF NOT EXISTS service_logs(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          bikeId INTEGER,
          title TEXT,
          date TEXT,
          cost REAL,
          notes TEXT
        )
      ''');
    }
  }

  Future<int> insertBike(Bike bike) async {
    try {
      final db = await database;
      return await db.insert('bikes', bike.toMap());
    } catch (e) {
      if (_useMock) {
        final newBike = Bike(
          id: _mockBikes.length + 1,
          name: bike.name,
          brand: bike.brand,
          model: bike.model,
          type: bike.type,
          imagePath: bike.imagePath,
          totalDistance: bike.totalDistance,
        );
        _mockBikes.add(newBike);
        return newBike.id!;
      }
      rethrow;
    }
  }

  Future<List<Bike>> getBikes() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('bikes');
      return List.generate(maps.length, (i) => Bike.fromMap(maps[i]));
    } catch (e) {
      if (_useMock) {
        return List.from(_mockBikes);
      }
      return [];
    }
  }

  Future<int> updateBike(Bike bike) async {
    try {
      final db = await database;
      return await db.update(
        'bikes',
        bike.toMap(),
        where: 'id = ?',
        whereArgs: [bike.id],
      );
    } catch (e) {
      if (_useMock) {
        final index = _mockBikes.indexWhere((b) => b.id == bike.id);
        if (index != -1) {
          _mockBikes[index] = bike;
          return 1;
        }
        return 0;
      }
      return 0;
    }
  }

  Future<int> deleteBike(int id) async {
    try {
      final db = await database;
      return await db.delete('bikes', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      if (_useMock) {
        _mockBikes.removeWhere((b) => b.id == id);
        return 1;
      }
      return 0;
    }
  }

  // Reminders
  Future<int> insertReminder(Reminder reminder) async {
    try {
      final db = await database;
      return await db.insert('reminders', reminder.toMap());
    } catch (e) {
      if (_useMock) {
        final newReminder = reminder.copyWith(id: _mockReminders.length + 1);
        _mockReminders.add(newReminder);
        return newReminder.id!;
      }
      rethrow;
    }
  }

  Future<List<Reminder>> getReminders() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('reminders');
      return List.generate(maps.length, (i) => Reminder.fromMap(maps[i]));
    } catch (e) {
      if (_useMock) {
        return List.from(_mockReminders);
      }
      return [];
    }
  }

  Future<int> updateReminder(Reminder reminder) async {
    try {
      final db = await database;
      return await db.update(
        'reminders',
        reminder.toMap(),
        where: 'id = ?',
        whereArgs: [reminder.id],
      );
    } catch (e) {
      if (_useMock) {
        final index = _mockReminders.indexWhere((r) => r.id == reminder.id);
        if (index != -1) {
          _mockReminders[index] = reminder;
          return 1;
        }
        return 0;
      }
      return 0;
    }
  }

  Future<int> deleteReminder(int id) async {
    try {
      final db = await database;
      return await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      if (_useMock) {
        _mockReminders.removeWhere((r) => r.id == id);
        return 1;
      }
      return 0;
    }
  }

  // SERVICE LOGS
  Future<int> addServiceLog(ServiceLog log) async {
    final db = await database;
    return await db.insert('service_logs', log.toMap());
  }

  Future<List<ServiceLog>> getServiceLogs(int bikeId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'service_logs',
      where: 'bikeId = ?',
      whereArgs: [bikeId],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => ServiceLog.fromMap(maps[i]));
  }
}
