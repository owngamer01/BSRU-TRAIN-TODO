import 'package:sqflite/sqflite.dart';

abstract class DatabaseInterface {
  Future<Database> onOpen();
  Future<void> onClose();
}