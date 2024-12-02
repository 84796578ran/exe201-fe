import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('roomspot.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Users table
    await db.execute('''
    CREATE TABLE users (
      id TEXT PRIMARY KEY,
      email TEXT NOT NULL,
      password TEXT NOT NULL,
      fullName TEXT NOT NULL,
      avatar BLOB,
      phone TEXT,
      address TEXT,
      role TEXT NOT NULL
    )
    ''');

    // Posts table with foreign key to users
    await db.execute('''
    CREATE TABLE posts (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      content TEXT NOT NULL,
      address TEXT NOT NULL,
      status TEXT NOT NULL,
      square REAL NOT NULL,
      price REAL NOT NULL,
      forGender TEXT NOT NULL,
      providerId TEXT NOT NULL,
      FOREIGN KEY (providerId) REFERENCES users (id)
    )
    ''');

    // Utilities table with foreign key to posts
    await db.execute('''
    CREATE TABLE utilities (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      postId TEXT NOT NULL,
      FOREIGN KEY (postId) REFERENCES posts (id)
    )
    ''');

    // Ratings table with foreign keys to users and posts
    await db.execute('''
    CREATE TABLE ratings (
      id TEXT PRIMARY KEY,
      userId TEXT NOT NULL,
      postId TEXT NOT NULL,
      rating INTEGER NOT NULL,
      comment TEXT NOT NULL,
      FOREIGN KEY (userId) REFERENCES users (id),
      FOREIGN KEY (postId) REFERENCES posts (id)
    )
    ''');

    // Orders table with foreign keys to users and posts
    await db.execute('''
    CREATE TABLE orders (
      id TEXT PRIMARY KEY,
      userId TEXT NOT NULL,
      postId TEXT NOT NULL,
      status TEXT NOT NULL,
      checkIn TEXT NOT NULL,
      checkOut TEXT NOT NULL,
      FOREIGN KEY (userId) REFERENCES users (id),
      FOREIGN KEY (postId) REFERENCES posts (id)
    )
    ''');

    // Wishlist table with foreign keys to users and posts
    await db.execute('''
    CREATE TABLE wishlist (
      id TEXT PRIMARY KEY,
      userId TEXT NOT NULL,
      postId TEXT NOT NULL,
      FOREIGN KEY (userId) REFERENCES users (id),
      FOREIGN KEY (postId) REFERENCES posts (id)
    )
    ''');

    // Post images table with foreign key to posts
    await db.execute('''
    CREATE TABLE post_images (
      id TEXT PRIMARY KEY,
      postId TEXT NOT NULL,
      url BLOB NOT NULL,
      FOREIGN KEY (postId) REFERENCES posts (id)
    )
    ''');

    // Load initial data
    await _loadInitialData(db);
  }

  Future<void> _loadInitialData(Database db) async {
    // Load users
    final String userJson =
        await rootBundle.loadString('assets/data/common/user.json');
    final userData = json.decode(userJson);
    int userId = 1;

    for (var user in userData['users']) {
      await db.insert('users', {
        'id': userId.toString(), // Auto-generated ID
        'email': user['email'],
        'password': user['password'],
        'fullName': user['fullName'],
        'avatar': null,
        'phone': user['phone'] ?? '',
        'address': user['address'] ?? '',
        'role': user['role'],
      });
      userId++;
    }

    // Load posts
    final String postJson =
        await rootBundle.loadString('assets/data/provider/post.json');
    final postData = json.decode(postJson);
    int postId = 1;
    int utilityId = 1;
    int ratingId = 1;
    int orderId = 1;
    int wishlistId = 1;

    for (var post in postData['posts']) {
      // Insert post
      final currentPostId = postId.toString();
      await db.insert('posts', {
        'id': currentPostId,
        'title': post['title'],
        'content': post['content'],
        'address': post['address'],
        'status': post['status'],
        'square': post['square'],
        'price': post['price'],
        'forGender': post['for'],
        'providerId': post['providerId'],
      });
      postId++;

      // Insert utilities
      for (var utility in post['utilities']) {
        await db.insert('utilities', {
          'id': utilityId.toString(), // Auto-generated ID
          'name': utility['name'],
          'postId': currentPostId,
        });
        utilityId++;
      }

      // Insert ratings
      for (var rating in post['ratings']) {
        await db.insert('ratings', {
          'id': ratingId.toString(), // Auto-generated ID
          'userId': rating['userId'],
          'postId': currentPostId,
          'rating': rating['rating'],
          'comment': rating['comment'],
        });
        ratingId++;
      }

      // Insert orders
      for (var order in post['orders']) {
        await db.insert('orders', {
          'id': orderId.toString(), // Auto-generated ID
          'userId': order['userId'],
          'postId': currentPostId,
          'status': order['status'],
          'checkIn': order['checkIn'],
          'checkOut': order['checkOut'],
        });
        orderId++;
      }

      // Insert wishlist
      for (var wish in post['wishlist']) {
        await db.insert('wishlist', {
          'id': wishlistId.toString(), // Auto-generated ID
          'userId': wish['userId'],
          'postId': currentPostId,
        });
        wishlistId++;
      }

      // Handle post images
      final images = post['images'] as List;
      for (var image in images) {
        try {
          // Convert base64 string to binary data
          final String base64String = image['url'];
          final Uint8List imageBytes = base64Decode(base64String);
          
          await db.insert('post_images', {
            'id': image['id'],
            'postId': currentPostId,
            'url': imageBytes,
          });
        } catch (e) {
          print('Error processing image for post $currentPostId: $e');
          // Skip this image if there's an error
          continue;
        }
      }
    }
  }

  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'roomspot.db');

    await databaseFactory.deleteDatabase(path);
    _database = null; // Reset the database instance
  }
}
