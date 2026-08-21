import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/partner.dart';
import 'database_service.dart';
import 'web_partner_storage.dart';

class PartnerService {
  final DatabaseService _databaseService = DatabaseService();

  // Create new partner
  Future<int> createPartner(Partner partner) async {
    try {
      if (kIsWeb) {
        final list = await webGetPartners();
        var nextId = 1;
        if (list.isNotEmpty) {
          final maxId = list.map((m) => (m['id'] ?? 0) as int).fold<int>(0, (prev, e) => e > prev ? e : prev);
          nextId = maxId + 1;
        }
        final map = partner.toMap();
        map['id'] = nextId;
        list.insert(0, map);
        await webSavePartners(list);
        return nextId;
      }
      final db = await _databaseService.database;
      return await db.insert('partners', partner.toMap());
    } catch (e) {
      print('Error creating partner: $e');
      return 0;
    }
  }

  // Get all partners
  Future<List<Partner>> getAllPartners() async {
    try {
      if (kIsWeb) {
        final list = await webGetPartners();
        return list.map((map) => Partner.fromMap(map)).toList();
      }
      final db = await _databaseService.database;
      final result = await db.query('partners', orderBy: 'created_at DESC');
      return result.map((map) => Partner.fromMap(map)).toList();
    } catch (e) {
      print('Error getting partners: $e');
      return [];
    }
  }

  // Get partner by id
  Future<Partner?> getPartnerById(int id) async {
    try {
      if (kIsWeb) {
        final list = await webGetPartners();
        final found = list.firstWhere((m) => (m['id'] ?? 0) == id, orElse: () => {});
        if (found.isNotEmpty) return Partner.fromMap(found);
        return null;
      }
      final db = await _databaseService.database;
      final result = await db.query('partners', where: 'id = ?', whereArgs: [id], limit: 1);
      if (result.isEmpty) return null;
      return Partner.fromMap(result.first);
    } catch (e) {
      print('Error getting partner by id: $e');
      return null;
    }
  }

  // Get partners by status
  Future<List<Partner>> getPartnersByStatus(String status) async {
    try {
      if (kIsWeb) {
        final list = await webGetPartners();
        final filtered = list.where((m) => (m['status'] ?? 'pending') == status).toList();
        return filtered.map((m) => Partner.fromMap(m)).toList();
      }
      final db = await _databaseService.database;
      final result = await db.query('partners', where: 'status = ?', whereArgs: [status], orderBy: 'created_at DESC');
      return result.map((map) => Partner.fromMap(map)).toList();
    } catch (e) {
      print('Error getting partners by status: $e');
      return [];
    }
  }

  // Update partner
  Future<bool> updatePartner(Partner partner) async {
    try {
      if (kIsWeb) {
        final list = await webGetPartners();
        final index = list.indexWhere((m) => (m['id'] ?? 0) == partner.id);
        if (index != -1) {
          list[index] = partner.toMap();
          await webSavePartners(list);
          return true;
        }
        return false;
      }
      final db = await _databaseService.database;
      final result = await db.update(
        'partners',
        partner.toMap(),
        where: 'id = ?',
        whereArgs: [partner.id],
      );
      return result > 0;
    } catch (e) {
      print('Error updating partner: $e');
      return false;
    }
  }

  // Delete partner
  Future<bool> deletePartner(int id) async {
    try {
      if (kIsWeb) {
        final list = await webGetPartners();
        list.removeWhere((m) => (m['id'] ?? 0) == id);
        await webSavePartners(list);
        return true;
      }
      final db = await _databaseService.database;
      final result = await db.delete('partners', where: 'id = ?', whereArgs: [id]);
      return result > 0;
    } catch (e) {
      print('Error deleting partner: $e');
      return false;
    }
  }

  // Get partner count by status
  Future<int> getPartnerCountByStatus(String status) async {
    try {
      final partners = await getPartnersByStatus(status);
      return partners.length;
    } catch (e) {
      print('Error getting partner count: $e');
      return 0;
    }
  }

  // Get all pending partners count
  Future<int> getPendingPartnersCount() async {
    try {
      final partners = await getPartnersByStatus('pending');
      return partners.length;
    } catch (e) {
      print('Error getting pending partners count: $e');
      return 0;
    }
  }

  // Get total active partners
  Future<int> getTotalActivePartners() async {
    try {
      final partners = await getPartnersByStatus('active');
      return partners.length;
    } catch (e) {
      print('Error getting active partners count: $e');
      return 0;
    }
  }

  // Get average rating
  Future<double> getAverageRating() async {
    try {
      final partners = await getAllPartners();
      if (partners.isEmpty) return 0;
      final totalRating = partners.fold<double>(0, (sum, p) => sum + p.rating);
      return totalRating / partners.length;
    } catch (e) {
      print('Error getting average rating: $e');
      return 0;
    }
  }

  // Search partners
  Future<List<Partner>> searchPartners(String query) async {
    try {
      if (kIsWeb) {
        final list = await webGetPartners();
        final filtered = list.where((m) {
          final name = (m['partnerName'] ?? m['partner_name'] ?? '').toString().toLowerCase();
          final owner = (m['ownerName'] ?? m['owner_name'] ?? '').toString().toLowerCase();
          final email = (m['email'] ?? '').toString().toLowerCase();
          final q = query.toLowerCase();
          return name.contains(q) || owner.contains(q) || email.contains(q);
        }).toList();
        return filtered.map((m) => Partner.fromMap(m)).toList();
      }
      final db = await _databaseService.database;
      final result = await db.query(
        'partners',
        where: 'partner_name LIKE ? OR owner_name LIKE ? OR email LIKE ?',
        whereArgs: ['%$query%', '%$query%', '%$query%'],
        orderBy: 'created_at DESC',
      );
      return result.map((map) => Partner.fromMap(map)).toList();
    } catch (e) {
      print('Error searching partners: $e');
      return [];
    }
  }
}
