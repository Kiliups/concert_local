import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseRepo {
  static const CONCERT_TABLE = "concerts";
  static final DatabaseRepo _instance = DatabaseRepo._internal();
  static Database? _database;

  factory DatabaseRepo() {
    return _instance;
  }

  DatabaseRepo._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Initialize the database if it doesn't exist
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get the path to the documents directory.
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'concert_database.db');

    // Open the database and create it if it doesn't exist.
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create the tables in the database
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $CONCERT_TABLE(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        date DATETIME,
        location TEXT,
        ticketRef TEXT,
        imageRef TEXT
      )
    ''');
  }
}
