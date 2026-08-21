import 'dart:html' as html;
import 'dart:convert';

Future<List<Map<String, dynamic>>> webGetPartners() async {
  try {
    final jsonString = html.window.localStorage['fastbites_partners'];
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.cast<Map<String, dynamic>>();
  } catch (e) {
    print('Error getting partners from web storage: $e');
    return [];
  }
}

Future<bool> webSavePartners(List<Map<String, dynamic>> partners) async {
  try {
    html.window.localStorage['fastbites_partners'] = jsonEncode(partners);
    return true;
  } catch (e) {
    print('Error saving partners to web storage: $e');
    return false;
  }
}
