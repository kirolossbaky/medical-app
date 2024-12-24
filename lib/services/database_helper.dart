import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/medication.dart';
import '../models/schedule.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();
  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'medical_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE medications(
        medicationId TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        activeIngredients TEXT NOT NULL,
        dosage TEXT NOT NULL,
        sideEffects TEXT,
        expiryDate TEXT NOT NULL,
        manufacturer TEXT,
        contraindications TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE schedules(
        scheduleId TEXT PRIMARY KEY,
        medicationId TEXT NOT NULL,
        startDate TEXT NOT NULL,
        endDate TEXT NOT NULL,
        reminderEnabled INTEGER NOT NULL,
        FOREIGN KEY (medicationId) REFERENCES medications (medicationId)
      )
    ''');

    await db.execute('''
      CREATE TABLE dosage_times(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        scheduleId TEXT NOT NULL,
        dosageTime TEXT NOT NULL,
        FOREIGN KEY (scheduleId) REFERENCES schedules (scheduleId)
      )
    ''');

    await db.execute('''
      CREATE TABLE prescriptions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        doctorName TEXT NOT NULL,
        imagePath TEXT NOT NULL,
        notes TEXT
      )
    ''');
  }

  // Medication Methods
  Future<void> insertMedication(Medication medication) async {
    final db = await database;
    await db.insert(
      'medications',
      medication.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Medication>> getMedications() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('medications');
    return List.generate(maps.length, (i) => Medication.fromJson(maps[i]));
  }

  Future<void> updateMedication(Medication medication) async {
    final db = await database;
    await db.update(
      'medications',
      medication.toJson(),
      where: 'medicationId = ?',
      whereArgs: [medication.medicationId],
    );
  }

  Future<void> deleteMedication(String medicationId) async {
    final db = await database;
    await db.delete(
      'medications',
      where: 'medicationId = ?',
      whereArgs: [medicationId],
    );
  }

  // Schedule Methods
  Future<void> insertSchedule(Schedule schedule) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert(
        'schedules',
        {
          'scheduleId': schedule.scheduleId,
          'medicationId': schedule.medicationId,
          'startDate': schedule.startDate.toIso8601String(),
          'endDate': schedule.endDate.toIso8601String(),
          'reminderEnabled': schedule.reminderEnabled ? 1 : 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Insert dosage times
      for (final time in schedule.dosageTimes) {
        await txn.insert(
          'dosage_times',
          {
            'scheduleId': schedule.scheduleId,
            'dosageTime': time.toIso8601String(),
          },
        );
      }
    });
  }

  Future<List<Schedule>> getSchedules() async {
    final db = await database;
    final List<Map<String, dynamic>> scheduleMaps = await db.query('schedules');
    
    return Future.wait(scheduleMaps.map((scheduleMap) async {
      final List<Map<String, dynamic>> timeMaps = await db.query(
        'dosage_times',
        where: 'scheduleId = ?',
        whereArgs: [scheduleMap['scheduleId']],
      );

      final dosageTimes = timeMaps
          .map((timeMap) => DateTime.parse(timeMap['dosageTime'] as String))
          .toList();

      return Schedule(
        scheduleId: scheduleMap['scheduleId'],
        medicationId: scheduleMap['medicationId'],
        startDate: DateTime.parse(scheduleMap['startDate']),
        endDate: DateTime.parse(scheduleMap['endDate']),
        dosageTimes: dosageTimes,
        reminderEnabled: scheduleMap['reminderEnabled'] == 1,
      );
    }));
  }

  // Prescription Methods
  Future<int> insertPrescription(Map<String, dynamic> prescription) async {
    final db = await database;
    return await db.insert('prescriptions', prescription);
  }

  Future<List<Map<String, dynamic>>> getPrescriptions() async {
    final db = await database;
    return await db.query('prescriptions', orderBy: 'date DESC');
  }

  Future<void> deletePrescription(int id) async {
    final db = await database;
    await db.delete(
      'prescriptions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
