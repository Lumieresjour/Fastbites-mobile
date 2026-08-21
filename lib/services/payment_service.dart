import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/payment.dart';
import 'database_service.dart';
import 'web_payment_storage.dart';

class PaymentService {
  final DatabaseService _databaseService = DatabaseService();

  // Create new payment
  Future<int> createPayment(Payment payment) async {
    try {
      if (kIsWeb) {
        final list = await webGetPayments();
        var nextId = 1;
        if (list.isNotEmpty) {
          final maxId = list.map((m) => (m['id'] ?? 0) as int).fold<int>(0, (prev, e) => e > prev ? e : prev);
          nextId = maxId + 1;
        }
        final map = payment.toMap();
        map['id'] = nextId;
        list.insert(0, map);
        await webSavePayments(list);
        return nextId;
      }
      final db = await _databaseService.database;
      return await db.insert('payments', payment.toMap());
    } catch (e) {
      print('Error creating payment: $e');
      return 0;
    }
  }

  // Get all payments
  Future<List<Payment>> getAllPayments() async {
    try {
      if (kIsWeb) {
        final list = await webGetPayments();
        return list.map((map) => Payment.fromMap(map)).toList();
      }
      final db = await _databaseService.database;
      final result = await db.query('payments', orderBy: 'created_at DESC');
      return result.map((map) => Payment.fromMap(map)).toList();
    } catch (e) {
      print('Error getting payments: $e');
      return [];
    }
  }

  // Get payment by id
  Future<Payment?> getPaymentById(int id) async {
    try {
      if (kIsWeb) {
        final list = await webGetPayments();
        final found = list.firstWhere((m) => (m['id'] ?? 0) == id, orElse: () => {});
        if (found.isNotEmpty) return Payment.fromMap(found);
        return null;
      }
      final db = await _databaseService.database;
      final result = await db.query('payments', where: 'id = ?', whereArgs: [id], limit: 1);
      if (result.isEmpty) return null;
      return Payment.fromMap(result.first);
    } catch (e) {
      print('Error getting payment by id: $e');
      return null;
    }
  }

  // Get payments by type
  Future<List<Payment>> getPaymentsByType(String type) async {
    try {
      if (kIsWeb) {
        final list = await webGetPayments();
        final filtered = list.where((m) => (m['payment_type'] ?? m['paymentType']) == type).toList();
        return filtered.map((m) => Payment.fromMap(m)).toList();
      }
      final db = await _databaseService.database;
      final result = await db.query('payments', where: 'payment_type = ?', whereArgs: [type], orderBy: 'created_at DESC');
      return result.map((map) => Payment.fromMap(map)).toList();
    } catch (e) {
      print('Error getting payments by type: $e');
      return [];
    }
  }

  // Get payments by status
  Future<List<Payment>> getPaymentsByStatus(String status) async {
    try {
      if (kIsWeb) {
        final list = await webGetPayments();
        final filtered = list.where((m) => (m['status'] ?? 'pending') == status).toList();
        return filtered.map((m) => Payment.fromMap(m)).toList();
      }
      final db = await _databaseService.database;
      final result = await db.query('payments', where: 'status = ?', whereArgs: [status], orderBy: 'created_at DESC');
      return result.map((map) => Payment.fromMap(map)).toList();
    } catch (e) {
      print('Error getting payments by status: $e');
      return [];
    }
  }

  // Update payment
  Future<bool> updatePayment(Payment payment) async {
    try {
      if (kIsWeb) {
        final list = await webGetPayments();
        final idx = list.indexWhere((m) => (m['id'] ?? 0) == payment.id);
        if (idx < 0) return false;
        list[idx] = payment.toMap();
        await webSavePayments(list);
        return true;
      }
      final db = await _databaseService.database;
      final result = await db.update('payments', payment.toMap(), where: 'id = ?', whereArgs: [payment.id]);
      return result > 0;
    } catch (e) {
      print('Error updating payment: $e');
      return false;
    }
  }

  // Delete payment
  Future<bool> deletePayment(int id) async {
    try {
      if (kIsWeb) {
        final list = await webGetPayments();
        final newList = list.where((m) => (m['id'] ?? 0) != id).toList();
        await webSavePayments(newList);
        return true;
      }
      final db = await _databaseService.database;
      final result = await db.delete('payments', where: 'id = ?', whereArgs: [id]);
      return result > 0;
    } catch (e) {
      print('Error deleting payment: $e');
      return false;
    }
  }

  // Get total amount by status
  Future<double> getTotalByStatus(String status) async {
    try {
      if (kIsWeb) {
        final payments = await getPaymentsByStatus(status);
        return payments.fold<double>(0, (sum, p) => sum + p.amount);
      }
      final db = await _databaseService.database;
      final result = await db.rawQuery(
        'SELECT SUM(amount) as total FROM payments WHERE status = ?',
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

  // Get pending payments count
  Future<int> getPendingPaymentsCount() async {
    try {
      if (kIsWeb) {
        final payments = await getPaymentsByStatus('pending');
        return payments.length;
      }
      final db = await _databaseService.database;
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM payments WHERE status = ?', ['pending']);
      if (result.isNotEmpty) {
        return (result.first['count'] as int?) ?? 0;
      }
      return 0;
    } catch (e) {
      print('Error getting pending payments count: $e');
      return 0;
    }
  }
}
