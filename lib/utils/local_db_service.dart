import 'dart:convert';

import 'package:aitie_demo/features/products/data/models/product_response.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDbService {
  static final LocalDbService instance = LocalDbService._init();
  static Database? _database;

  LocalDbService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('products.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY,
        title TEXT,
        price REAL,
        description TEXT,
        category TEXT,
        image TEXT,
        rating TEXT,
        isFavorite INTEGER,
        isInCart INTEGER,
        quantity INTEGER
      )
    ''');
  }

  Future<void> saveProducts(List<ProductResponse> products) async {
    final db = await instance.database;
    final batch = db.batch();

    for (var product in products) {
      batch.insert(
        'products',
        _convertToDbMap(product),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<ProductResponse>> getAllProducts() async {
    final db = await instance.database;
    final result = await db.query('products');

    return result.map((json) => _convertFromDbMap(json)).toList();
  }

  Map<String, dynamic> _convertToDbMap(ProductResponse product) {
    final map = product.toMap();
    map['rating'] = jsonEncode(product.rating?.toMap());
    map['isFavorite'] = (product.isFavorite ?? false) ? 1 : 0;
    map['isInCart'] = (product.isInCart ?? false) ? 1 : 0;
    return map;
  }

  ProductResponse _convertFromDbMap(Map<String, dynamic> map) {
    return ProductResponse(
      id: map['id'],
      title: map['title'],
      price: map['price'],
      description: map['description'],
      category: map['category'],
      image: map['image'],
      rating: map['rating'] != null
          ? Rating.fromMap(jsonDecode(map['rating']))
          : null,
      isFavorite: map['isFavorite'] == 1,
      isInCart: map['isInCart'] == 1,
      quantity: map['quantity'],
    );
  }

  Future<void> clearDatabase() async {
    final db = await instance.database;
    await db.delete('products');
  }
}
