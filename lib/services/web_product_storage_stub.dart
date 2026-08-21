// Stub used when not compiling for web. The functions are never called on non-web platforms.

Future<List<Map<String, dynamic>>> webGetProducts() async => [];
Future<void> webSaveProducts(List<Map<String, dynamic>> products) async {}
