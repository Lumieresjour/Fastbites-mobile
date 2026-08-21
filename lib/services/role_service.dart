import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'database_service.dart';
import '../models/role.dart';

class RoleService {
  // In-memory storage for web platform (since sqflite is not available on web)
  static final List<Role> _webRoles = [];

  Future<List<Role>> getAllRoles() async {
    if (kIsWeb) {
      return List.from(_webRoles);
    }

    try {
      final db = await DatabaseService().database;
      final maps = await db.query('roles', orderBy: 'id ASC');
      return maps.map((m) => Role.fromMap(m)).toList();
    } catch (e) {
      print('Error fetching roles: $e');
      return [];
    }
  }

  Future<bool> createRole(Role role) async {
    if (kIsWeb) {
      // Generate ID for web (simple increment)
      int newId =
          _webRoles.isEmpty
              ? 1
              : (_webRoles
                      .map((r) => r.id ?? 0)
                      .reduce((a, b) => a > b ? a : b) +
                  1);
      _webRoles.add(role.copyWith(id: newId));
      return true;
    }

    try {
      final db = await DatabaseService().database;
      await db.insert('roles', role.toDbMap());
      return true;
    } catch (e) {
      print('Error creating role: $e');
      return false;
    }
  }

  Future<bool> updateRole(Role role) async {
    if (kIsWeb) {
      final index = _webRoles.indexWhere((r) => r.id == role.id);
      if (index >= 0) {
        _webRoles[index] = role;
        return true;
      }
      return false;
    }

    try {
      final db = await DatabaseService().database;
      final count = await db.update(
        'roles',
        role.toDbMap(),
        where: 'id = ?',
        whereArgs: [role.id],
      );
      return count > 0;
    } catch (e) {
      print('Error updating role: $e');
      return false;
    }
  }

  Future<bool> deleteRole(int id) async {
    if (kIsWeb) {
      final index = _webRoles.indexWhere((r) => r.id == id);
      if (index >= 0) {
        _webRoles.removeAt(index);
        return true;
      }
      return false;
    }

    try {
      final db = await DatabaseService().database;
      final count = await db.delete('roles', where: 'id = ?', whereArgs: [id]);
      return count > 0;
    } catch (e) {
      print('Error deleting role: $e');
      return false;
    }
  }

  /// Helpers to convert between Role and UI-friendly Map expected by the
  /// existing screen (it uses `color` as a `Color` object and `permissions`
  /// as a List<String>).
  Map<String, dynamic> roleToUiMap(Role r) {
    Color color = _colorFromHex(r.colorHex);
    return {
      'id': r.id,
      'name': r.name,
      'description': r.description ?? '',
      'color': color,
      'colorHex': r.colorHex,
      'permissions': r.permissions,
      'userCount': r.userCount,
    };
  }

  List<Map<String, dynamic>> rolesToUiMaps(List<Role> list) =>
      list.map(roleToUiMap).toList();

  Color _colorFromHex(String hex) {
    final h = hex.replaceAll('#', '');
    final v = int.tryParse(h, radix: 16) ?? 0x9E9E9E;
    if (h.length == 6) {
      return Color(0xFF000000 | v);
    }
    return Color(v);
  }
}
