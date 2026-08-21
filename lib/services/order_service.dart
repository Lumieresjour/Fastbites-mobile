import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/order.dart';
import 'database_service.dart';
import 'web_order_storage.dart';

class OrderService {
  final DatabaseService _databaseService = DatabaseService();

  // Create new order
  Future<int> createOrder(Order order) async {
    try {
      if (kIsWeb) {
        final list = await webGetOrders();
        var nextId = 1;
        if (list.isNotEmpty) {
          final maxId = list.map((m) => (m['id'] ?? 0) as int).fold<int>(0, (prev, e) => e > prev ? e : prev);
          nextId = maxId + 1;
        }
        final map = order.toMap();
        map['id'] = nextId;
        list.insert(0, map);
        await webSaveOrders(list);
        return nextId;
      }
      final db = await _databaseService.database;
      return await db.insert('orders', order.toMap());
    } catch (e) {
      print('Error creating order: $e');
      return 0;
    }
  }

  // Get all orders
  Future<List<Order>> getAllOrders() async {
    try {
      if (kIsWeb) {
        final list = await webGetOrders();
        return list.map((map) => Order.fromMap(map)).toList();
      }
      final db = await _databaseService.database;
      final result = await db.query('orders', orderBy: 'created_at DESC');
      return result.map((map) => Order.fromMap(map)).toList();
    } catch (e) {
      print('Error getting orders: $e');
      return [];
    }
  }

  // Get order by id
  Future<Order?> getOrderById(int id) async {
    try {
      if (kIsWeb) {
        final list = await webGetOrders();
        final found = list.firstWhere((m) => (m['id'] ?? 0) == id, orElse: () => {});
        if (found.isNotEmpty) return Order.fromMap(found);
        return null;
      }
      final db = await _databaseService.database;
      final result = await db.query('orders', where: 'id = ?', whereArgs: [id], limit: 1);
      if (result.isEmpty) return null;
      return Order.fromMap(result.first);
    } catch (e) {
      print('Error getting order by id: $e');
      return null;
    }
  }

  // Get orders by status
  Future<List<Order>> getOrdersByStatus(String status) async {
    try {
      if (kIsWeb) {
        final list = await webGetOrders();
        final filtered = list.where((m) => (m['order_status'] ?? m['orderStatus']) == status).toList();
        return filtered.map((m) => Order.fromMap(m)).toList();
      }
      final db = await _databaseService.database;
      final result = await db.query('orders', where: 'order_status = ?', whereArgs: [status], orderBy: 'created_at DESC');
      return result.map((map) => Order.fromMap(map)).toList();
    } catch (e) {
      print('Error getting orders by status: $e');
      return [];
    }
  }

  // Get orders by payment status
  Future<List<Order>> getOrdersByPaymentStatus(String status) async {
    try {
      if (kIsWeb) {
        final list = await webGetOrders();
        final filtered = list.where((m) => (m['payment_status'] ?? m['paymentStatus']) == status).toList();
        return filtered.map((m) => Order.fromMap(m)).toList();
      }
      final db = await _databaseService.database;
      final result = await db.query('orders', where: 'payment_status = ?', whereArgs: [status], orderBy: 'created_at DESC');
      return result.map((map) => Order.fromMap(map)).toList();
    } catch (e) {
      print('Error getting orders by payment status: $e');
      return [];
    }
  }

  // Update order
  Future<bool> updateOrder(Order order) async {
    try {
      if (kIsWeb) {
        final list = await webGetOrders();
        final idx = list.indexWhere((m) => (m['id'] ?? 0) == order.id);
        if (idx < 0) return false;
        list[idx] = order.toMap();
        await webSaveOrders(list);
        return true;
      }
      final db = await _databaseService.database;
      final result = await db.update('orders', order.toMap(), where: 'id = ?', whereArgs: [order.id]);
      return result > 0;
    } catch (e) {
      print('Error updating order: $e');
      return false;
    }
  }

  // Delete order
  Future<bool> deleteOrder(int id) async {
    try {
      if (kIsWeb) {
        final list = await webGetOrders();
        final newList = list.where((m) => (m['id'] ?? 0) != id).toList();
        await webSaveOrders(newList);
        return true;
      }
      final db = await _databaseService.database;
      final result = await db.delete('orders', where: 'id = ?', whereArgs: [id]);
      return result > 0;
    } catch (e) {
      print('Error deleting order: $e');
      return false;
    }
  }

  // Get order count by status
  Future<int> getOrderCountByStatus(String status) async {
    try {
      final orders = await getOrdersByStatus(status);
      return orders.length;
    } catch (e) {
      print('Error getting order count: $e');
      return 0;
    }
  }

  // Get total revenue
  Future<double> getTotalRevenue() async {
    try {
      if (kIsWeb) {
        final list = await webGetOrders();
        return list.fold<double>(0, (sum, o) => sum + ((o['total_amount'] ?? o['totalAmount'] ?? 0) as num).toDouble());
      }
      final db = await _databaseService.database;
      final result = await db.rawQuery('SELECT SUM(total_amount) as total FROM orders WHERE payment_status = ?', ['paid']);
      if (result.isNotEmpty && result.first['total'] != null) {
        return (result.first['total'] as num).toDouble();
      }
      return 0.0;
    } catch (e) {
      print('Error getting total revenue: $e');
      return 0.0;
    }
  }
}
