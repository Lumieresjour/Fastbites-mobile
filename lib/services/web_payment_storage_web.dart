import 'dart:convert';
import 'dart:html' as html;

Future<List<Map<String, dynamic>>> webGetPayments() async {
  final raw = html.window.localStorage['fastbites_payments'];
  if (raw == null || raw.isEmpty) return [];
  final decoded = jsonDecode(raw) as List<dynamic>;
  return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
}

Future<void> webSavePayments(List<Map<String, dynamic>> payments) async {
  final encoded = jsonEncode(payments);
  html.window.localStorage['fastbites_payments'] = encoded;
}
