import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/commission.dart';
import 'database_service.dart';
import 'web_commission_storage.dart';

class CommissionService {
  final DatabaseService _databaseService = DatabaseService();

  // Create new commission
  Future<int> createCommission(Commission commission) async {
    try {
      if (kIsWeb) {
        final list = await webGetCommissions();
        var nextId = 1;
        if (list.isNotEmpty) {
          final maxId = list.map((m) => (m['id'] ?? 0) as int).fold<int>(0, (prev, e) => e > prev ? e : prev);
          nextId = maxId + 1;
        }
        final map = commission.toMap();
        map['id'] = nextId;
        list.insert(0, map);
        await webSaveCommissions(list);
        return nextId;
      }
      final db = await _databaseService.database;
      return await db.insert('commissions', commission.toMap());
    } catch (e) {
      print('Error creating commission: $e');
      return 0;
    }
  }

  // Get all commissions
  Future<List<Commission>> getAllCommissions() async {
    try {
      if (kIsWeb) {
        final list = await webGetCommissions();
        return list.map((map) => Commission.fromMap(map)).toList();
      }
      final db = await _databaseService.database;
      final result = await db.query('commissions', orderBy: 'created_at DESC');
      return result.map((map) => Commission.fromMap(map)).toList();
    } catch (e) {
      print('Error getting commissions: $e');
      return [];
    }
  }

  // Get commission by id
  Future<Commission?> getCommissionById(int id) async {
    try {
      if (kIsWeb) {
        final list = await webGetCommissions();
        final found = list.firstWhere((m) => (m['id'] ?? 0) == id, orElse: () => {});
        if (found.isNotEmpty) return Commission.fromMap(found);
        return null;
      }
      final db = await _databaseService.database;
      final result = await db.query('commissions', where: 'id = ?', whereArgs: [id], limit: 1);
      if (result.isEmpty) return null;
      return Commission.fromMap(result.first);
    } catch (e) {
      print('Error getting commission by id: $e');
      return null;
    }
  }

  // Get commissions by type
  Future<List<Commission>> getCommissionsByType(String type) async {
    try {
      if (kIsWeb) {
        final list = await webGetCommissions();
        final filtered = list.where((m) => (m['commission_type'] ?? m['commissionType']) == type).toList();
        return filtered.map((m) => Commission.fromMap(m)).toList();
      }
      final db = await _databaseService.database;
      final result =
          await db.query('commissions', where: 'commission_type = ?', whereArgs: [type], orderBy: 'created_at DESC');
      return result.map((map) => Commission.fromMap(map)).toList();
    } catch (e) {
      print('Error getting commissions by type: $e');
      return [];
    }
  }

  // Get commissions by status
  Future<List<Commission>> getCommissionsByStatus(String status) async {
    try {
      if (kIsWeb) {
        final list = await webGetCommissions();
        final filtered = list.where((m) => (m['status'] ?? 'earned') == status).toList();
        return filtered.map((m) => Commission.fromMap(m)).toList();
      }
      final db = await _databaseService.database;
      final result = await db.query('commissions', where: 'status = ?', whereArgs: [status], orderBy: 'created_at DESC');
      return result.map((map) => Commission.fromMap(map)).toList();
    } catch (e) {
      print('Error getting commissions by status: $e');
      return [];
    }
  }

  // Update commission
  Future<bool> updateCommission(Commission commission) async {
    try {
      if (kIsWeb) {
        final list = await webGetCommissions();
        final idx = list.indexWhere((m) => (m['id'] ?? 0) == commission.id);
        if (idx < 0) return false;
        list[idx] = commission.toMap();
        await webSaveCommissions(list);
        return true;
      }
      final db = await _databaseService.database;
      final result = await db.update('commissions', commission.toMap(), where: 'id = ?', whereArgs: [commission.id]);
      return result > 0;
    } catch (e) {
      print('Error updating commission: $e');
      return false;
    }
  }

  // Delete commission
  Future<bool> deleteCommission(int id) async {
    try {
      if (kIsWeb) {
        final list = await webGetCommissions();
        final newList = list.where((m) => (m['id'] ?? 0) != id).toList();
        await webSaveCommissions(newList);
        return true;
      }
      final db = await _databaseService.database;
      final result = await db.delete('commissions', where: 'id = ?', whereArgs: [id]);
      return result > 0;
    } catch (e) {
      print('Error deleting commission: $e');
      return false;
    }
  }

  // Get total commission by status
  Future<double> getTotalByStatus(String status) async {
    try {
      if (kIsWeb) {
        final commissions = await getCommissionsByStatus(status);
        return commissions.fold<double>(0, (sum, c) => sum + c.amount);
      }
      final db = await _databaseService.database;
      final result = await db.rawQuery(
        'SELECT SUM(amount) as total FROM commissions WHERE status = ?',
        [status],
      );
      if (result.isNotEmpty && result.first['total'] != null) {
        return (result.first['total'] as num).toDouble();
      }
      return 0.0;
    } catch (e) {
      print('Error getting total by status: $e');
      return 0.0;
    }
  }

  // Get total earned (all earned + pending + paid)
  Future<double> getTotalEarned() async {
    try {
      final earned = await getTotalByStatus('earned');
      final pending = await getTotalByStatus('pending');
      final paid = await getTotalByStatus('paid');
      return earned + pending + paid;
    } catch (e) {
      print('Error getting total earned: $e');
      return 0.0;
    }
  }

  // Get total paid
  Future<double> getTotalPaid() async {
    try {
      return await getTotalByStatus('paid');
    } catch (e) {
      print('Error getting total paid: $e');
      return 0.0;
    }
  }
}
