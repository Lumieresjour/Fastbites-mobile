import 'dart:convert';
import 'dart:html' as html;

Future<List<Map<String, dynamic>>> webGetCommissions() async {
  final raw = html.window.localStorage['fastbites_commissions'];
  if (raw == null || raw.isEmpty) return [];
  final decoded = jsonDecode(raw) as List<dynamic>;
  return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
}

Future<void> webSaveCommissions(List<Map<String, dynamic>> commissions) async {
  final encoded = jsonEncode(commissions);
  html.window.localStorage['fastbites_commissions'] = encoded;
}
