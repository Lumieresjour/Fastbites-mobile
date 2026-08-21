/// No-op for web. sqflite is not supported on web.
Future<void> initDatabaseFactory() async {
  // Web uses localStorage or IndexedDB via web-specific storage, not sqflite
}
