import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';

abstract class BaseRepository {
  Future<Database> get database async => await DatabaseHelper.instance.database;
} 