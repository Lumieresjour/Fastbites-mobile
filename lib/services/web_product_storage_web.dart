import 'dart:convert';
import 'dart:html' as html;

Future<List<Map<String, dynamic>>> webGetProducts() async {
  final raw = html.window.localStorage['fastbites_products'];
  if (raw == null || raw.isEmpty) return [];
  final decoded = jsonDecode(raw) as List<dynamic>;
  return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
}

Future<void> webSaveProducts(List<Map<String, dynamic>> products) async {
  final encoded = jsonEncode(products);
  html.window.localStorage['fastbites_products'] = encoded;
}
