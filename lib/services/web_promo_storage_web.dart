import 'dart:convert';
import 'dart:html' as html;

Future<List<Map<String, dynamic>>> webGetPromos() async {
  final raw = html.window.localStorage['fastbites_promos'];
  if (raw == null || raw.isEmpty) return [];
  final decoded = jsonDecode(raw) as List<dynamic>;
  return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
}

Future<void> webSavePromos(List<Map<String, dynamic>> promos) async {
  final encoded = jsonEncode(promos);
  html.window.localStorage['fastbites_promos'] = encoded;
}
