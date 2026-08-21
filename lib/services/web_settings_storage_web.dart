import 'dart:convert';
import 'dart:html' as html;

Future<Map<String, dynamic>?> webGetSettings() async {
  final raw = html.window.localStorage['fastbites_settings'];
  if (raw == null || raw.isEmpty) return null;
  final decoded = jsonDecode(raw) as Map<String, dynamic>;
  return decoded;
}

Future<void> webSaveSettings(Map<String, dynamic> settings) async {
  final encoded = jsonEncode(settings);
  html.window.localStorage['fastbites_settings'] = encoded;
}
