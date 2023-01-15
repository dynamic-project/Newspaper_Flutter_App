import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../model/article.dart';

class DatabaseHelper {
  // Database name and version
  static const String _databaseName = "my_database.db";
  static const int _databaseVersion = 1;

  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  // Database object
  static late Database _database;

  // Get the database
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database;
  }

  // Initialize the database
  _initDatabase() async {
    // Get the directory path for both Android and iOS
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + _databaseName;

    // Open/Create the database at a given path
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Create the tables
  _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE articles (
        id INTEGER PRIMARY KEY,
        title TEXT,
        description TEXT,
        url TEXT,
        urlToImage TEXT,
        publishedAt TEXT
    )
    ''');
  }

  // Insert an article
  Future<int> insertArticle(Article article) async {
    Database db = await database;
    int id = await db.insert('articles', article.toMap());
    return id;
  }

  // Get all articles
  Future<List<Article>?> getArticles() async {
    Database db = await database;
    List<Map> maps = await db.query('articles');
    if (maps.isNotEmpty) {
      return maps.map((map) => Article.fromMap(map)).toList();
    }
    return null;
  }

  // Delete an article
  Future<int> deleteArticle(int id) async {
    Database db = await database;
    return await db.delete('articles', where: 'id = ?', whereArgs: [id]);
  }

  // Close the database
  Future<void> close() async {
    Database db = await database;
    db.close();
  }
}
