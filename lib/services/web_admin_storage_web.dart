import 'dart:convert';
import 'dart:html' as html;

Future<List<Map<String, dynamic>>> webGetAdmins() async {
  final raw = html.window.localStorage['fastbites_admins'];
  if (raw == null || raw.isEmpty) return [];
  final decoded = jsonDecode(raw) as List<dynamic>;
  return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
}

Future<void> webSaveAdmins(List<Map<String, dynamic>> admins) async {
  final encoded = jsonEncode(admins);
  html.window.localStorage['fastbites_admins'] = encoded;
}
