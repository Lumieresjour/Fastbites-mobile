import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Initializes sqflite_common_ffi for desktop (Windows/macOS/Linux).
Future<void> initDatabaseFactory() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}
