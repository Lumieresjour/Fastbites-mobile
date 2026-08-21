import 'dart:convert';
import 'dart:html' as html;

Future<Map<String, dynamic>?> webGetStore() async {
  final raw = html.window.localStorage['fastbites_store'];
  if (raw == null || raw.isEmpty) return null;
  final decoded = jsonDecode(raw) as Map<String, dynamic>;
  return decoded;
}

Future<void> webSaveStore(Map<String, dynamic> store) async {
  final encoded = jsonEncode(store);
  html.window.localStorage['fastbites_store'] = encoded;
}
