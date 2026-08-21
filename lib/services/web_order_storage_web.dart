import 'dart:convert';
import 'dart:html' as html;

Future<List<Map<String, dynamic>>> webGetOrders() async {
  final raw = html.window.localStorage['fastbites_orders'];
  if (raw == null || raw.isEmpty) return [];
  final decoded = jsonDecode(raw) as List<dynamic>;
  return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
}

Future<void> webSaveOrders(List<Map<String, dynamic>> orders) async {
  final encoded = jsonEncode(orders);
  html.window.localStorage['fastbites_orders'] = encoded;
}
