import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('garage.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    // Version mise à 2 pour appliquer la modification de la table commerces
    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _onUpgrade);
  }

  Future _createDB(Database db, int version) async {
    // Table existante pour le garage
    await db.execute('''
      CREATE TABLE garage_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        status TEXT NOT NULL,
        x REAL DEFAULT 0,
        y REAL DEFAULT 0,
        rotation REAL DEFAULT 0
      )
    ''');

    // Table pour les commerces mise à jour avec la colonne pays
    await db.execute('''
      CREATE TABLE commerces (
        id TEXT PRIMARY KEY,
        nom_lieu TEXT,
        pays TEXT,
        type_commerce TEXT,
        est_occupe INTEGER DEFAULT 0,
        proprietaire_id TEXT,
        prix_achat INTEGER,
        latitude REAL,
        longitude REAL
      )
    ''');

    // Table pour les points de livraison réels
    await db.execute('''
      CREATE TABLE lieux_activite (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom_lieu TEXT,
        type_activite TEXT,
        latitude REAL,
        longitude REAL,
        est_disponible INTEGER DEFAULT 1
      )
    ''');

    // Table pour le joueur et son solde
    await db.execute('''
      CREATE TABLE joueur (
        id INTEGER PRIMARY KEY,
        argent INTEGER DEFAULT 1000
      )
    ''');
    await db.execute("INSERT INTO joueur (id, argent) VALUES (1, 1000)");
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Si tu mets à jour une version existante, cela ajoute la colonne pays
      await db.execute("ALTER TABLE commerces ADD COLUMN pays TEXT");
    }
  }

  // --- NOUVELLE FONCTION FILTRE ---
  Future<List<Map<String, dynamic>>> chercherCommercesParPaysEtType(String pays, String type) async {
    final db = await instance.database;
    return await db.query('commerces', where: 'pays = ? AND type_commerce = ?', whereArgs: [pays, type]);
  }

  // --- FONCTIONS JOUEUR ---

  Future<int> getArgent() async {
    final db = await instance.database;
    final res = await db.query('joueur', where: 'id = ?', whereArgs: [1]);
    return res.isNotEmpty ? res.first['argent'] as int : 0;
  }

  Future<void> setArgent(int nouveauSolde) async {
    final db = await instance.database;
    await db.update('joueur', {'argent': nouveauSolde}, where: 'id = ?', whereArgs: [1]);
  }

  Future<void> ajouterFonds(int montant) async {
    final db = await instance.database;
    final soldeActuel = await getArgent();
    await db.update('joueur', {'argent': soldeActuel + montant}, where: 'id = ?', whereArgs: [1]);
  }

  // --- FONCTIONS GARAGE ---

  Future<int> insertItem(String name, String status, double x, double y, double rotation) async {
    final db = await instance.database;
    return await db.insert('garage_items', {
      'name': name,
      'status': status,
      'x': x,
      'y': y,
      'rotation': rotation
    });
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    final db = await instance.database;
    return await db.query('garage_items');
  }

  // --- FONCTIONS COMMERCES ---

  Future<List<Map<String, dynamic>>> getCommercesDisponibles() async {
    final db = await instance.database;
    return await db.query('commerces', where: 'est_occupe = ?', whereArgs: [0]);
  }

  Future<void> acheterCommerce(String id, String proprietaireId) async {
    final db = await instance.database;
    await db.update(
      'commerces',
      {'est_occupe': 1, 'proprietaire_id': proprietaireId},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertCommerce(String id, String nom, String pays, String type, double lat, double lon) async {
    final db = await instance.database;
    return await db.insert('commerces', {
      'id': id,
      'nom_lieu': nom,
      'pays': pays,
      'type_commerce': type,
      'est_occupe': 0,
      'latitude': lat,
      'longitude': lon
    });
  }

  Future<void> initialiserCommercesTest() async {
    final db = await instance.database;
    final result = await db.query('commerces', where: 'id = ?', whereArgs: ['c1']);
    if (result.isEmpty) {
      await insertCommerce('c1', 'Ma Super Pizzeria', 'France', 'pizzeria', 47.190, 2.450); 
    }
  }

  // --- FONCTIONS MISSIONS ---

  Future<int> insertLieuActivite(String nom, String type, double lat, double lon) async {
    final db = await instance.database;
    return await db.insert('lieux_activite', {
      'nom_lieu': nom,
      'type_activite': type,
      'latitude': lat,
      'longitude': lon,
      'est_disponible': 1
    });
  }

  Future<List<Map<String, dynamic>>> getLieuxParType(String type) async {
    final db = await instance.database;
    return await db.query('lieux_activite', where: 'type_activite = ?', whereArgs: [type]);
  }
}