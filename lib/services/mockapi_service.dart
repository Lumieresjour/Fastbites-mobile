import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/admin.dart';

class MockApiService {
  static const String MOCKAPI_BASE_URL =
      'https://693bc59bb762a4f15c3e383a.mockapi.io/';

  // Endpoints
  static const String usersEndpoint = '/users';
  static const String adminsEndpoint = '/admins';

  static String _getUrl(String endpoint) {
    if (MOCKAPI_BASE_URL.contains('YOUR_PROJECT_ID')) {
      print('mockAPI');

      return 'https://693bc59bb762a4f15c3e383a.mockapi.io/:endpoint';
    }
    return '$MOCKAPI_BASE_URL$endpoint';
  }

  /// Register user baru ke mockAPIF
  Future<bool> registerUser(User user) async {
    try {
      final url = _getUrl(usersEndpoint);
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': user.name,
          'email': user.email,
          'password': user.password,
          'phone': user.phone,
          'address': user.address,
          'created_at': user.createdAt.toIso8601String(),
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        print(
            'Error registering user: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception registering user: $e');
      return false;
    }
  }

  /// Login user dengan email dan password
  Future<User?> loginUser(String email, String password) async {
    try {
      final url = _getUrl(usersEndpoint);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Cari user dengan email dan password yang cocok
        for (var item in data) {
          if (item['email'] == email && item['password'] == password) {
            return User.fromMap(item);
          }
        }
        return null; // Email atau password tidak ditemukan
      } else {
        print(
            'Error logging in user: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception logging in user: $e');
      return null;
    }
  }

  /// Get user by email
  Future<User?> getUserByEmail(String email) async {
    try {
      final url = _getUrl(usersEndpoint);
      // MockAPI mendukung filter dengan query parameter
      final response = await http.get(Uri.parse('$url?email=$email'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return User.fromMap(data.first);
        }
        return null;
      } else {
        print(
            'Error getting user by email: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception getting user by email: $e');
      return null;
    }
  }

  /// Get user by ID
  Future<User?> getUserById(int id) async {
    try {
      final url = _getUrl('$usersEndpoint/$id');
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return User.fromMap(jsonDecode(response.body));
      } else {
        print(
            'Error getting user by id: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception getting user by id: $e');
      return null;
    }
  }

  /// Update user
  Future<bool> updateUser(User user) async {
    try {
      if (user.id == null) return false;

      final url = _getUrl('$usersEndpoint/${user.id}');
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toMap()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error updating user: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception updating user: $e');
      return false;
    }
  }

  /// Delete user
  Future<bool> deleteUser(int id) async {
    try {
      final url = _getUrl('$usersEndpoint/$id');
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('Error deleting user: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception deleting user: $e');
      return false;
    }
  }

  /// Get all users
  Future<List<User>> getAllUsers() async {
    try {
      final url = _getUrl(usersEndpoint);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => User.fromMap(item)).toList();
      } else {
        print(
            'Error getting all users: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Exception getting all users: $e');
      return [];
    }
  }

  /// Register admin baru ke mockAPI
  Future<bool> registerAdmin(Admin admin) async {
    try {
      final url = _getUrl(adminsEndpoint);
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': admin.name,
          'email': admin.email,
          'password': admin.password,
          'created_at': admin.createdAt.toIso8601String(),
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        print(
            'Error registering admin: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception registering admin: $e');
      return false;
    }
  }

  /// Login admin dengan email dan password
  Future<Admin?> loginAdmin(String email, String password) async {
    try {
      final url = _getUrl(adminsEndpoint);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Cari admin dengan email dan password yang cocok
        for (var item in data) {
          if (item['email'] == email && item['password'] == password) {
            return Admin.fromMap(item);
          }
        }
        return null; // Email atau password tidak ditemukan
      } else {
        print(
            'Error logging in admin: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception logging in admin: $e');
      return null;
    }
  }

  /// Get admin by email
  Future<Admin?> getAdminByEmail(String email) async {
    try {
      final url = _getUrl(adminsEndpoint);
      final response = await http.get(Uri.parse('$url?email=$email'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return Admin.fromMap(data.first);
        }
        return null;
      } else {
        print(
            'Error getting admin by email: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception getting admin by email: $e');
      return null;
    }
  }

  /// Get admin by ID
  Future<Admin?> getAdminById(int id) async {
    try {
      final url = _getUrl('$adminsEndpoint/$id');
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return Admin.fromMap(jsonDecode(response.body));
      } else {
        print(
            'Error getting admin by id: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception getting admin by id: $e');
      return null;
    }
  }

  /// Get all admins
  Future<List<Admin>> getAllAdmins() async {
    try {
      final url = _getUrl(adminsEndpoint);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Admin.fromMap(item)).toList();
      } else {
        print(
            'Error getting all admins: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Exception getting all admins: $e');
      return [];
    }
  }

  /// Update admin
  Future<bool> updateAdmin(Admin admin) async {
    try {
      if (admin.id == null) return false;

      final url = _getUrl('$adminsEndpoint/${admin.id}');
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(admin.toMap()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print(
            'Error updating admin: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception updating admin: $e');
      return false;
    }
  }

  /// Delete admin
  Future<bool> deleteAdmin(int id) async {
    try {
      final url = _getUrl('$adminsEndpoint/$id');
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print(
            'Error deleting admin: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception deleting admin: $e');
      return false;
    }
  }
}
