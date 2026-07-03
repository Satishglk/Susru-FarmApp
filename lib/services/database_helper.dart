import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/animal.dart';
import '../models/health_record.dart';
import '../models/breeding_record.dart';
import '../models/emission_log.dart';
import '../models/emergency_contact.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'susru.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE animals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        species TEXT NOT NULL,
        breed TEXT,
        sex TEXT,
        birth_date TEXT,
        notes TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE health_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        animal_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        type TEXT NOT NULL,
        description TEXT,
        medicine TEXT,
        vet_name TEXT,
        next_due_date TEXT,
        FOREIGN KEY (animal_id) REFERENCES animals (id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE breeding_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        animal_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        event_type TEXT NOT NULL,
        sire_info TEXT,
        outcome TEXT,
        expected_due_date TEXT,
        FOREIGN KEY (animal_id) REFERENCES animals (id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE emission_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        species TEXT NOT NULL,
        count INTEGER NOT NULL,
        manure_method TEXT NOT NULL,
        diesel_litres REAL NOT NULL DEFAULT 0,
        electricity_kwh REAL NOT NULL DEFAULT 0,
        calculated_co2e_kg REAL NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE emergency_contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        role TEXT NOT NULL,
        name TEXT NOT NULL,
        phone_number TEXT NOT NULL
      )
    ''');
  }

  // Animals
  Future<int> insertAnimal(Animal a) async =>
      (await database).insert('animals', a.toMap()..remove('id'));

  Future<int> updateAnimal(Animal a) async =>
      (await database).update('animals', a.toMap(),
          where: 'id = ?', whereArgs: [a.id]);

  Future<int> deleteAnimal(int id) async =>
      (await database).delete('animals', where: 'id = ?', whereArgs: [id]);

  Future<List<Animal>> getAnimals() async {
    final rows = await (await database).query('animals', orderBy: 'name');
    return rows.map(Animal.fromMap).toList();
  }

  // Health records
  Future<int> insertHealthRecord(HealthRecord r) async =>
      (await database).insert('health_records', r.toMap()..remove('id'));

  Future<int> deleteHealthRecord(int id) async => (await database)
      .delete('health_records', where: 'id = ?', whereArgs: [id]);

  Future<List<HealthRecord>> getHealthRecords({int? animalId}) async {
    final db = await database;
    final rows = animalId == null
        ? await db.query('health_records', orderBy: 'date DESC')
        : await db.query('health_records',
            where: 'animal_id = ?', whereArgs: [animalId], orderBy: 'date DESC');
    return rows.map(HealthRecord.fromMap).toList();
  }

  // Breeding records
  Future<int> insertBreedingRecord(BreedingRecord r) async =>
      (await database).insert('breeding_records', r.toMap()..remove('id'));

  Future<int> deleteBreedingRecord(int id) async => (await database)
      .delete('breeding_records', where: 'id = ?', whereArgs: [id]);

  Future<List<BreedingRecord>> getBreedingRecords({int? animalId}) async {
    final db = await database;
    final rows = animalId == null
        ? await db.query('breeding_records', orderBy: 'date DESC')
        : await db.query('breeding_records',
            where: 'animal_id = ?', whereArgs: [animalId], orderBy: 'date DESC');
    return rows.map(BreedingRecord.fromMap).toList();
  }

  // Emission logs
  Future<int> insertEmissionLog(EmissionLog e) async =>
      (await database).insert('emission_logs', e.toMap()..remove('id'));

  Future<List<EmissionLog>> getEmissionLogs() async {
    final rows =
        await (await database).query('emission_logs', orderBy: 'date DESC');
    return rows.map(EmissionLog.fromMap).toList();
  }

  // Emergency contacts
  Future<int> insertContact(EmergencyContact c) async =>
      (await database).insert('emergency_contacts', c.toMap()..remove('id'));

  Future<int> updateContact(EmergencyContact c) async =>
      (await database).update('emergency_contacts', c.toMap(),
          where: 'id = ?', whereArgs: [c.id]);

  Future<int> deleteContact(int id) async => (await database)
      .delete('emergency_contacts', where: 'id = ?', whereArgs: [id]);

  Future<List<EmergencyContact>> getContacts() async {
    final rows =
        await (await database).query('emergency_contacts', orderBy: 'role');
    return rows.map(EmergencyContact.fromMap).toList();
  }

  Future<void> seedDemoDataIfEmpty() async {
    final animals = await getAnimals();
    if (animals.isNotEmpty) return;

    final cowId = await insertAnimal(Animal(
      name: 'Lakshmi',
      species: 'Cattle',
      breed: 'Gir',
      sex: 'Female',
      birthDate: '2021-04-12',
      notes: 'Primary milking cow',
    ));
    final buffaloId = await insertAnimal(Animal(
      name: 'Ganga',
      species: 'Buffalo',
      breed: 'Murrah',
      sex: 'Female',
      birthDate: '2020-01-20',
    ));
    await insertAnimal(Animal(
      name: 'Raja',
      species: 'Goat',
      breed: 'Boer',
      sex: 'Male',
      birthDate: '2023-06-05',
    ));

    await insertHealthRecord(HealthRecord(
      animalId: cowId,
      date: '2026-05-10',
      type: 'Vaccination',
      description: 'FMD vaccine',
      vetName: 'Dr. Rao',
      nextDueDate: '2026-11-10',
    ));
    await insertBreedingRecord(BreedingRecord(
      animalId: buffaloId,
      date: '2026-03-01',
      eventType: 'Insemination',
      sireInfo: 'Murrah bull #12',
      expectedDueDate: '2027-01-15',
    ));

    await insertContact(EmergencyContact(
      role: 'Veterinarian',
      name: 'Dr. Rao',
      phoneNumber: '+919876543210',
    ));
    await insertContact(EmergencyContact(
      role: 'Extension Officer',
      name: 'Agri Extension Office',
      phoneNumber: '+919876543211',
    ));
    await insertContact(EmergencyContact(
      role: 'Ambulance',
      name: 'Veterinary Ambulance',
      phoneNumber: '1962',
    ));
  }
}
