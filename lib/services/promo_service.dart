import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/promo.dart';
import 'database_service.dart';
import 'web_promo_storage.dart';

class PromoService {
  final DatabaseService _databaseService = DatabaseService();

  // Create new promo
  Future<int> createPromo(Promo promo) async {
    try {
      if (kIsWeb) {
        // For web, store promos in localStorage
        final list = await webGetPromos();
        // assign an id
        var nextId = 1;
        if (list.isNotEmpty) {
          final maxId = list.map((m) => (m['id'] ?? 0) as int).fold<int>(0, (prev, e) => e > prev ? e : prev);
          nextId = maxId + 1;
        }
        final map = {
          'id': nextId,
          'title': promo.title,
          'description': promo.description,
          'code': promo.code,
          'discount_percent': promo.discountPercent,
          'discount_amount': promo.discountAmount,
          'min_purchase': promo.minPurchase,
          'start_date': promo.startDate.toIso8601String(),
          'end_date': promo.endDate.toIso8601String(),
          'category': promo.category,
          'usage_limit': promo.usageLimit,
          'used_count': promo.usedCount,
          'is_active': promo.isActive ? 1 : 0,
          'image_url': promo.imageUrl,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };
        list.insert(0, map);
        await webSavePromos(list);
        return nextId;
      }
      final db = await _databaseService.database;
      final result = await db.insert(
        'promos',
        {
          'title': promo.title,
          'description': promo.description,
          'code': promo.code,
          'discount_percent': promo.discountPercent,
          'discount_amount': promo.discountAmount,
          'min_purchase': promo.minPurchase,
          'start_date': promo.startDate.toIso8601String(),
          'end_date': promo.endDate.toIso8601String(),
          'category': promo.category,
          'usage_limit': promo.usageLimit,
          'used_count': promo.usedCount,
          'is_active': promo.isActive ? 1 : 0,
          'image_url': promo.imageUrl,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
      );
      return result;
    } catch (e) {
      print('Error creating promo: $e');
      return 0;
    }
  }

  // Get all promos
  Future<List<Promo>> getAllPromos() async {
    try {
      if (kIsWeb) {
        final list = await webGetPromos();
        return list.map((map) => Promo.fromMap(map)).toList();
      }
      final db = await _databaseService.database;
      final result = await db.query('promos', orderBy: 'created_at DESC');
      return result.map((map) => Promo.fromMap(map)).toList();
    } catch (e) {
      print('Error getting promos: $e');
      return [];
    }
  }

  // Get promo by id
  Future<Promo?> getPromoById(int id) async {
    try {
      if (kIsWeb) {
        final list = await webGetPromos();
        final found = list.firstWhere((m) => (m['id'] ?? 0) == id, orElse: () => {});
        if (found.isNotEmpty) return Promo.fromMap(found);
        return null;
      }
      final db = await _databaseService.database;
      final result = await db.query(
        'promos',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (result.isEmpty) return null;
      return Promo.fromMap(result.first);
    } catch (e) {
      print('Error getting promo by id: $e');
      return null;
    }
  }

  // Get promo by code
  Future<Promo?> getPromoByCode(String code) async {
    try {
      if (kIsWeb) {
        final list = await webGetPromos();
        final found = list.firstWhere((m) => (m['code'] ?? '') == code, orElse: () => {});
        if (found.isNotEmpty) return Promo.fromMap(found);
        return null;
      }
      final db = await _databaseService.database;
      final result = await db.query(
        'promos',
        where: 'code = ?',
        whereArgs: [code],
        limit: 1,
      );
      if (result.isEmpty) return null;
      return Promo.fromMap(result.first);
    } catch (e) {
      print('Error getting promo by code: $e');
      return null;
    }
  }

  // Get active promos
  Future<List<Promo>> getActivePromos() async {
    try {
      if (kIsWeb) {
        final list = await webGetPromos();
        final now = DateTime.now();
        final filtered = list.where((m) {
          try {
            final start = DateTime.parse(m['start_date'] ?? m['startDate']);
            final end = DateTime.parse(m['end_date'] ?? m['endDate']);
            final isActive = (m['is_active'] ?? m['isActive'] ?? 1) == 1;
            final used = (m['used_count'] ?? m['usedCount'] ?? 0) as int;
            final limit = (m['usage_limit'] ?? m['usageLimit'] ?? 0) as int;
            return isActive && start.isBefore(now) && end.isAfter(now) && used < limit;
          } catch (e) {
            return false;
          }
        }).toList();
        return filtered.map((m) => Promo.fromMap(m)).toList();
      }
      final db = await _databaseService.database;
      final now = DateTime.now().toIso8601String();
      final result = await db.query(
        'promos',
        where: 'is_active = 1 AND start_date <= ? AND end_date >= ? AND used_count < usage_limit',
        whereArgs: [now, now],
        orderBy: 'created_at DESC',
      );
      return result.map((map) => Promo.fromMap(map)).toList();
    } catch (e) {
      print('Error getting active promos: $e');
      return [];
    }
  }

  // Update promo
  Future<bool> updatePromo(Promo promo) async {
    try {
      if (kIsWeb) {
        final list = await webGetPromos();
        final idx = list.indexWhere((m) => (m['id'] ?? 0) == promo.id);
        if (idx < 0) return false;
        final map = list[idx];
        map['title'] = promo.title;
        map['description'] = promo.description;
        map['code'] = promo.code;
        map['discount_percent'] = promo.discountPercent;
        map['discount_amount'] = promo.discountAmount;
        map['min_purchase'] = promo.minPurchase;
        map['start_date'] = promo.startDate.toIso8601String();
        map['end_date'] = promo.endDate.toIso8601String();
        map['category'] = promo.category;
        map['usage_limit'] = promo.usageLimit;
        map['used_count'] = promo.usedCount;
        map['is_active'] = promo.isActive ? 1 : 0;
        map['image_url'] = promo.imageUrl;
        map['updated_at'] = DateTime.now().toIso8601String();
        list[idx] = map;
        await webSavePromos(list);
        return true;
      }
      final db = await _databaseService.database;
      final result = await db.update(
        'promos',
        {
          'title': promo.title,
          'description': promo.description,
          'code': promo.code,
          'discount_percent': promo.discountPercent,
          'discount_amount': promo.discountAmount,
          'min_purchase': promo.minPurchase,
          'start_date': promo.startDate.toIso8601String(),
          'end_date': promo.endDate.toIso8601String(),
          'category': promo.category,
          'usage_limit': promo.usageLimit,
          'used_count': promo.usedCount,
          'is_active': promo.isActive ? 1 : 0,
          'image_url': promo.imageUrl,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [promo.id],
      );
      return result > 0;
    } catch (e) {
      print('Error updating promo: $e');
      return false;
    }
  }

  // Increment promo usage
  Future<bool> incrementPromoUsage(int promoId) async {
    try {
      if (kIsWeb) {
        final list = await webGetPromos();
        final idx = list.indexWhere((m) => (m['id'] ?? 0) == promoId);
        if (idx < 0) return false;
        final map = list[idx];
        final used = (map['used_count'] ?? map['usedCount'] ?? 0) as int;
        map['used_count'] = used + 1;
        map['updated_at'] = DateTime.now().toIso8601String();
        list[idx] = map;
        await webSavePromos(list);
        return true;
      }
      final db = await _databaseService.database;
      final promo = await getPromoById(promoId);
      if (promo == null) return false;
      final result = await db.update(
        'promos',
        {
          'used_count': promo.usedCount + 1,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [promoId],
      );
      return result > 0;
    } catch (e) {
      print('Error incrementing promo usage: $e');
      return false;
    }
  }

  // Delete promo
  Future<bool> deletePromo(int id) async {
    try {
      if (kIsWeb) {
        final list = await webGetPromos();
        final newList = list.where((m) => (m['id'] ?? 0) != id).toList();
        final changed = newList.length != list.length;
        if (changed) await webSavePromos(newList);
        return changed;
      }
      final db = await _databaseService.database;
      final result = await db.delete(
        'promos',
        where: 'id = ?',
        whereArgs: [id],
      );
      return result > 0;
    } catch (e) {
      print('Error deleting promo: $e');
      return false;
    }
  }

  // Search promos
  Future<List<Promo>> searchPromos(String query) async {
    try {
      if (kIsWeb) {
        final list = await webGetPromos();
        final q = query.toLowerCase();
        final filtered = list.where((m) {
          final title = (m['title'] ?? '').toString().toLowerCase();
          final code = (m['code'] ?? '').toString().toLowerCase();
          final desc = (m['description'] ?? '').toString().toLowerCase();
          return title.contains(q) || code.contains(q) || desc.contains(q);
        }).toList();
        return filtered.map((m) => Promo.fromMap(m)).toList();
      }
      final db = await _databaseService.database;
      final result = await db.query(
        'promos',
        where: 'title LIKE ? OR code LIKE ? OR description LIKE ?',
        whereArgs: ['%$query%', '%$query%', '%$query%'],
        orderBy: 'created_at DESC',
      );
      return result.map((map) => Promo.fromMap(map)).toList();
    } catch (e) {
      print('Error searching promos: $e');
      return [];
    }
  }
}
