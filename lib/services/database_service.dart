import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'web_product_storage.dart';
import 'web_admin_storage.dart';
import 'web_store_storage.dart';
import 'web_settings_storage.dart';
import 'mockapi_service.dart';
import '../models/store.dart';
import '../models/admin.dart';
import '../models/user.dart';
import '../models/product.dart';
import '../models/settings.dart';
import '../models/sales.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;
  final MockApiService _mockApiService = MockApiService();
  
  // Set true untuk menggunakan mockAPI, false untuk menggunakan database lokal
  static const bool useMockApi = true;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    _database ??= await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    // Ensure sqflite_common_ffi is initialized on desktop (non-web) so
    // the global `databaseFactory` used by `openDatabase` is available.
    try {
      if (!kIsWeb) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }
    } catch (e) {
      print('sqflite ffi init skipped: $e');
    }
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fastbites.db');

    // Bump database version to 15 to add category column to products.
    return openDatabase(
      path,
      version: 15,
      onCreate: _createTables,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''CREATE TABLE IF NOT EXISTS products(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT,
            price REAL NOT NULL DEFAULT 0,
            stock INTEGER NOT NULL DEFAULT 0,
            sku TEXT,
            created_at TEXT NOT NULL
          )''');
          oldVersion = 2;
        }
        if (oldVersion < 3) {
          // add image column (nullable)
          try {
            await db.execute('ALTER TABLE products ADD COLUMN image TEXT');
          } catch (e) {
            // ignore if already exists
            print('Could not add image column: $e');
          }
          oldVersion = 3;
        }
        if (oldVersion < 4) {
          // add category column to products
          try {
            await db.execute("ALTER TABLE products ADD COLUMN category TEXT DEFAULT 'makanan'");
          } catch (e) {
            // ignore if already exists
            print('Could not add category column: $e');
          }
          oldVersion = 4;
        }
        if (oldVersion < 5) {
          try {
            await db.execute('''CREATE TABLE IF NOT EXISTS stores(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              description TEXT,
              category TEXT,
              location TEXT,
              opening_hours TEXT,
              logo TEXT,
              phone TEXT,
              email TEXT,
              updated_at TEXT
            )''');
          } catch (e) {
            print('Could not create stores table: $e');
          }
          oldVersion = 5;
        }
        if (oldVersion < 6) {
          try {
            await db.execute('''CREATE TABLE IF NOT EXISTS settings(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              app_name TEXT,
              app_logo TEXT,
              app_description TEXT,
              support_email TEXT,
              whatsapp_number TEXT,
              social_media_links TEXT,
              terms_and_conditions TEXT,
              privacy_policy TEXT,
              notification_enabled INTEGER DEFAULT 1,
              updated_at TEXT
            )''');
          } catch (e) {
            print('Could not create settings table: $e');
          }
          oldVersion = 6;
        }
        if (oldVersion < 7) {
          try {
            await db.execute('''CREATE TABLE IF NOT EXISTS sales(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              product_id INTEGER,
              product_name TEXT,
              quantity INTEGER NOT NULL DEFAULT 0,
              total_price REAL NOT NULL DEFAULT 0,
              sold_at TEXT NOT NULL
            )''');
          } catch (e) {
            print('Could not create sales table: $e');
          }
          oldVersion = 7;
        }
        if (oldVersion < 8) {
          try {
            await db.execute('''CREATE TABLE IF NOT EXISTS promos(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              description TEXT,
              code TEXT UNIQUE NOT NULL,
              discount_percent REAL DEFAULT 0,
              discount_amount REAL DEFAULT 0,
              min_purchase REAL DEFAULT 0,
              start_date TEXT NOT NULL,
              end_date TEXT NOT NULL,
              category TEXT,
              usage_limit INTEGER DEFAULT 0,
              used_count INTEGER DEFAULT 0,
              is_active INTEGER DEFAULT 1,
              image_url TEXT,
              created_at TEXT NOT NULL,
              updated_at TEXT
            )''');
          } catch (e) {
            print('Could not create promos table: $e');
          }
          oldVersion = 8;
        }
        if (oldVersion < 9) {
          try {
            await db.execute('''CREATE TABLE IF NOT EXISTS reviews(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_id TEXT NOT NULL,
              user_name TEXT NOT NULL,
              user_image TEXT,
              product_id TEXT NOT NULL,
              product_name TEXT NOT NULL,
              product_image TEXT,
              rating INTEGER NOT NULL,
              review_text TEXT,
              review_type TEXT,
              created_at TEXT NOT NULL,
              updated_at TEXT
            )''');
          } catch (e) {
            print('Could not create reviews table: $e');
          }
          oldVersion = 9;
        }
        if (oldVersion < 10) {
          try {
            await db.execute('''CREATE TABLE IF NOT EXISTS payments(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              payment_type TEXT NOT NULL,
              amount REAL NOT NULL,
              status TEXT NOT NULL,
              bank_name TEXT,
              account_number TEXT,
              account_holder TEXT,
              description TEXT,
              created_at TEXT NOT NULL,
              processed_at TEXT,
              transaction_id TEXT,
              failure_reason TEXT
            )''');
          } catch (e) {
            print('Could not create payments table: $e');
          }
          oldVersion = 10;
        }
        if (oldVersion < 11) {
          try {
            await db.execute('''CREATE TABLE IF NOT EXISTS commissions(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              commission_type TEXT NOT NULL,
              amount REAL NOT NULL,
              status TEXT NOT NULL,
              source_description TEXT,
              related_id TEXT,
              created_at TEXT NOT NULL,
              paid_at TEXT,
              notes TEXT
            )''');
          } catch (e) {
            print('Could not create commissions table: $e');
          }
          oldVersion = 11;
        }
        if (oldVersion < 12) {
          try {
            await db.execute('''CREATE TABLE IF NOT EXISTS orders(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              order_number TEXT UNIQUE NOT NULL,
              buyer_name TEXT NOT NULL,
              buyer_phone TEXT NOT NULL,
              buyer_email TEXT NOT NULL,
              total_amount REAL NOT NULL,
              payment_status TEXT NOT NULL,
              order_status TEXT NOT NULL,
              shipping_method TEXT NOT NULL,
              shipping_address TEXT NOT NULL,
              shipping_city TEXT NOT NULL,
              shipping_province TEXT NOT NULL,
              shipping_postal_code TEXT NOT NULL,
              courier_name TEXT,
              tracking_number TEXT,
              created_at TEXT NOT NULL,
              paid_at TEXT,
              shipped_at TEXT,
              delivered_at TEXT,
              notes TEXT
            )''');
          } catch (e) {
            print('Could not create orders table: $e');
          }
          oldVersion = 12;
        }
        if (oldVersion < 13) {
          try {
            await db.execute('''CREATE TABLE IF NOT EXISTS partners(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              partner_name TEXT NOT NULL,
              owner_name TEXT NOT NULL,
              email TEXT NOT NULL,
              phone TEXT NOT NULL,
              business_type TEXT NOT NULL,
              business_address TEXT NOT NULL,
              business_city TEXT NOT NULL,
              business_province TEXT NOT NULL,
              business_postal_code TEXT NOT NULL,
              business_registration TEXT NOT NULL,
              tax_id TEXT NOT NULL,
              estimated_monthly_revenue REAL NOT NULL,
              bank_name TEXT NOT NULL,
              bank_account_number TEXT NOT NULL,
              bank_account_holder TEXT NOT NULL,
              status TEXT NOT NULL,
              rating REAL DEFAULT 0,
              total_orders INTEGER DEFAULT 0,
              created_at TEXT NOT NULL,
              approved_at TEXT,
              rejected_at TEXT,
              rejection_reason TEXT,
              notes TEXT
            )''');
            await db.execute(
              'CREATE INDEX IF NOT EXISTS idx_partners_status ON partners(status)',
            );
            await db.execute(
              'CREATE INDEX IF NOT EXISTS idx_partners_created_at ON partners(created_at)',
            );
          } catch (e) {
            print('Could not create partners table: $e');
          }
          oldVersion = 13;
        }
        if (oldVersion < 14) {
          try {
            await db.execute('''CREATE TABLE IF NOT EXISTS roles(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              description TEXT,
              color_hex TEXT NOT NULL,
              permissions TEXT,
              user_count INTEGER DEFAULT 0,
              created_at TEXT,
              updated_at TEXT
            )''');
          } catch (e) {
            print('Could not create roles table: $e');
          }
          oldVersion = 14;
        }
        if (oldVersion < 15) {
          try {
            await db.execute('''CREATE TABLE IF NOT EXISTS users(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              email TEXT UNIQUE NOT NULL,
              password TEXT NOT NULL,
              phone TEXT,
              address TEXT,
              created_at TEXT NOT NULL
            )''');
          } catch (e) {
            print('Could not create users table: $e');
          }
          oldVersion = 15;
        }
      },
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''CREATE TABLE IF NOT EXISTS products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL DEFAULT 0,
        stock INTEGER NOT NULL DEFAULT 0,
        sku TEXT,
        image TEXT,
        category TEXT DEFAULT 'makanan',
        created_at TEXT NOT NULL
      )''');
    await db.execute('''CREATE TABLE IF NOT EXISTS admins(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        created_at TEXT NOT NULL
      )''');
    await db.execute('''CREATE TABLE IF NOT EXISTS stores(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        category TEXT,
        location TEXT,
        opening_hours TEXT,
        logo TEXT,
        phone TEXT,
        email TEXT,
        updated_at TEXT
      )''');
    await db.execute('''CREATE TABLE IF NOT EXISTS settings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        app_name TEXT,
        app_logo TEXT,
        app_description TEXT,
        support_email TEXT,
        whatsapp_number TEXT,
        social_media_links TEXT,
        terms_and_conditions TEXT,
        privacy_policy TEXT,
        notification_enabled INTEGER DEFAULT 1,
        updated_at TEXT
      )''');
    await db.execute('''CREATE TABLE IF NOT EXISTS sales(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER,
        product_name TEXT,
        quantity INTEGER NOT NULL DEFAULT 0,
        total_price REAL NOT NULL DEFAULT 0,
        sold_at TEXT NOT NULL
      )''');
    await db.execute('''CREATE TABLE IF NOT EXISTS promos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        code TEXT UNIQUE NOT NULL,
        discount_percent REAL DEFAULT 0,
        discount_amount REAL DEFAULT 0,
        min_purchase REAL DEFAULT 0,
        start_date TEXT NOT NULL,
        end_date TEXT NOT NULL,
        category TEXT,
        usage_limit INTEGER DEFAULT 0,
        used_count INTEGER DEFAULT 0,
        is_active INTEGER DEFAULT 1,
        image_url TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT
      )''');
    await db.execute('''CREATE TABLE IF NOT EXISTS reviews(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        user_name TEXT NOT NULL,
        user_image TEXT,
        product_id TEXT NOT NULL,
        product_name TEXT NOT NULL,
        product_image TEXT,
        rating INTEGER NOT NULL,
        review_text TEXT,
        review_type TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT
      )''');
    await db.execute('''CREATE TABLE IF NOT EXISTS payments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        payment_type TEXT NOT NULL,
        amount REAL NOT NULL,
        status TEXT NOT NULL,
        bank_name TEXT,
        account_number TEXT,
        account_holder TEXT,
        description TEXT,
        created_at TEXT NOT NULL,
        processed_at TEXT,
        transaction_id TEXT,
        failure_reason TEXT
      )''');
    await db.execute('''CREATE TABLE IF NOT EXISTS commissions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        commission_type TEXT NOT NULL,
        amount REAL NOT NULL,
        status TEXT NOT NULL,
        source_description TEXT,
        related_id TEXT,
        created_at TEXT NOT NULL,
        paid_at TEXT,
        notes TEXT
      )''');
    await db.execute('''CREATE TABLE IF NOT EXISTS orders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_number TEXT UNIQUE NOT NULL,
        buyer_name TEXT NOT NULL,
        buyer_phone TEXT NOT NULL,
        buyer_email TEXT NOT NULL,
        total_amount REAL NOT NULL,
        payment_status TEXT NOT NULL,
        order_status TEXT NOT NULL,
        shipping_method TEXT NOT NULL,
        shipping_address TEXT NOT NULL,
        shipping_city TEXT NOT NULL,
        shipping_province TEXT NOT NULL,
        shipping_postal_code TEXT NOT NULL,
        courier_name TEXT,
        tracking_number TEXT,
        created_at TEXT NOT NULL,
        paid_at TEXT,
        shipped_at TEXT,
        delivered_at TEXT,
        notes TEXT
      )''');
    await db.execute('''CREATE TABLE IF NOT EXISTS partners(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        partner_name TEXT NOT NULL,
        owner_name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        business_type TEXT NOT NULL,
        business_address TEXT NOT NULL,
        business_city TEXT NOT NULL,
        business_province TEXT NOT NULL,
        business_postal_code TEXT NOT NULL,
        business_registration TEXT NOT NULL,
        tax_id TEXT NOT NULL,
        estimated_monthly_revenue REAL NOT NULL,
        bank_name TEXT NOT NULL,
        bank_account_number TEXT NOT NULL,
        bank_account_holder TEXT NOT NULL,
        status TEXT NOT NULL,
        rating REAL DEFAULT 0,
        total_orders INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        approved_at TEXT,
        rejected_at TEXT,
        rejection_reason TEXT,
        notes TEXT
      )''');
    // roles table
    await db.execute('''CREATE TABLE IF NOT EXISTS roles(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        color_hex TEXT NOT NULL,
        permissions TEXT,
        user_count INTEGER DEFAULT 0,
        created_at TEXT,
        updated_at TEXT
        )''');
    // users table
    await db.execute('''CREATE TABLE IF NOT EXISTS users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        phone TEXT,
        address TEXT,
        created_at TEXT NOT NULL
      )''');
  }

  // Register new admin
  Future<bool> registerAdmin(Admin admin) async {
    try {
      // Gunakan mockAPI jika diaktifkan
      if (useMockApi) {
        // Check if admin with email already exists
        final existingAdmin = await _mockApiService.getAdminByEmail(admin.email);
        if (existingAdmin != null) {
          return false; // Email sudah terdaftar
        }
        return await _mockApiService.registerAdmin(admin);
      }

      if (kIsWeb) {
        final list = await webGetAdmins();
        // prevent duplicate email
        final exists = list.any((m) => (m['email'] ?? '') == admin.email);
        if (exists) return false;
        // assign an id
        final nextId =
            (list.isEmpty)
                ? 1
                : ((list
                        .map((m) => (m['id'] ?? 0) as int)
                        .fold<int>(0, (prev, e) => e > prev ? e : prev)) +
                    1);
        final map = admin.toMap();
        map['id'] = nextId;
        list.insert(0, map);
        await webSaveAdmins(list);
        return true;
      }
      final db = await database;
      await db.insert('admins', admin.toMap());
      return true;
    } catch (e) {
      print('Error registering admin: $e');
      return false;
    }
  }

  // --- Product CRUD ---
  Future<bool> createProduct(Product product) async {
    try {
      if (kIsWeb) {
        final list = await webGetProducts();
        // assign an id for web-stored products
        final nextId =
            (list.isEmpty)
                ? 1
                : ((list
                        .map((m) => (m['id'] ?? 0) as int)
                        .fold<int>(0, (prev, e) => e > prev ? e : prev)) +
                    1);
        final map = product.toMap();
        map['id'] = nextId;
        list.insert(0, map);
        await webSaveProducts(list);
        return true;
      }
      final db = await database;
      await db.insert('products', product.toMap());
      return true;
    } catch (e) {
      print('Error creating product: $e');
      return false;
    }
  }

  Future<Product?> getProductById(int id) async {
    try {
      if (kIsWeb) {
        final list = await webGetProducts();
        final found = list.firstWhere(
          (m) => (m['id'] ?? 0) == id,
          orElse: () => {},
        );
        if (found.isNotEmpty) return Product.fromMap(found);
        return null;
      }
      final db = await database;
      final result = await db.query(
        'products',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (result.isNotEmpty) return Product.fromMap(result.first);
      return null;
    } catch (e) {
      print('Error getting product: $e');
      return null;
    }
  }

  Future<List<Product>> getAllProducts() async {
    try {
      if (kIsWeb) {
        final list = await webGetProducts();
        // migrate: if any item missing id, assign sequential ids
        var needsSave = false;
        var maxId = list.fold<int>(
          0,
          (prev, m) => ((m['id'] ?? 0) as int) > prev ? (m['id'] as int) : prev,
        );
        for (var i = 0; i < list.length; i++) {
          final m = list[i];
          if (m['id'] == null || m['id'] == 0) {
            maxId += 1;
            m['id'] = maxId;
            needsSave = true;
          }
          // ensure created_at exists
          if (m['created_at'] == null) {
            m['created_at'] = DateTime.now().toIso8601String();
            needsSave = true;
          }
        }
        if (needsSave) await webSaveProducts(list);
        return list.map((m) => Product.fromMap(m)).toList();
      }
      final db = await database;
      final result = await db.query('products', orderBy: 'created_at DESC');
      return result.map((m) => Product.fromMap(m)).toList();
    } catch (e) {
      print('Error getting products: $e');
      return [];
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      if (kIsWeb) {
        final list = await webGetProducts();
        final idx = list.indexWhere((m) => (m['id'] ?? 0) == product.id);
        if (idx >= 0) {
          list[idx] = product.toMap();
          await webSaveProducts(list);
          return true;
        }
        return false;
      }
      final db = await database;
      final res = await db.update(
        'products',
        product.toMap(),
        where: 'id = ?',
        whereArgs: [product.id],
      );
      return res > 0;
    } catch (e) {
      print('Error updating product: $e');
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      if (kIsWeb) {
        final list = await webGetProducts();
        final newList = list.where((m) => (m['id'] ?? 0) != id).toList();
        await webSaveProducts(newList);
        return true;
      }
      final db = await database;
      final res = await db.delete('products', where: 'id = ?', whereArgs: [id]);
      return res > 0;
    } catch (e) {
      print('Error deleting product: $e');
      return false;
    }
  }

  // Login admin
  Future<Admin?> loginAdmin(String email, String password) async {
    try {
      // Gunakan mockAPI jika diaktifkan
      if (useMockApi) {
        return await _mockApiService.loginAdmin(email, password);
      }

      // Quick web fallback: sqflite isn't available on web, so accept
      // a default admin account for Chrome debugging.
      if (kIsWeb) {
        if (email == 'admin@gmail.com' && password == 'admin123') {
          return Admin(
            id: 1,
            name: 'Administrator',
            email: email,
            password: password,
            createdAt: DateTime.now(),
          );
        }
        return null;
      }
      final db = await database;
      final result = await db.query(
        'admins',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );

      if (result.isNotEmpty) {
        return Admin.fromMap(result.first);
      }
      return null;
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }

  // Get admin by email
  Future<Admin?> getAdminByEmail(String email) async {
    try {
      // Gunakan mockAPI jika diaktifkan
      if (useMockApi) {
        return await _mockApiService.getAdminByEmail(email);
      }

      // Web fallback for default admin
      if (kIsWeb && email == 'admin@gmail.com') {
        return Admin(
          id: 1,
          name: 'Administrator',
          email: email,
          password: 'admin123',
          createdAt: DateTime.now(),
        );
      }
      final db = await database;
      final result = await db.query(
        'admins',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (result.isNotEmpty) {
        return Admin.fromMap(result.first);
      }
      return null;
    } catch (e) {
      print('Error getting admin: $e');
      return null;
    }
  }

  // Get all admins
  Future<List<Admin>> getAllAdmins() async {
    try {
      // Web fallback: return single default admin for Chrome debugging
      if (kIsWeb) {
        return [
          Admin(
            id: 1,
            name: 'Administrator',
            email: 'admin@gmail.com',
            password: 'admin123',
            createdAt: DateTime.now(),
          ),
        ];
      }

      final db = await database;
      final result = await db.query('admins');
      return result.map((map) => Admin.fromMap(map)).toList();
    } catch (e) {
      print('Error getting all admins: $e');
      return [];
    }
  }

  // Update admin
  Future<bool> updateAdmin(Admin admin) async {
    try {
      final db = await database;
      final result = await db.update(
        'admins',
        admin.toMap(),
        where: 'id = ?',
        whereArgs: [admin.id],
      );
      return result > 0;
    } catch (e) {
      print('Error updating admin: $e');
      return false;
    }
  }

  // Delete admin
  Future<bool> deleteAdmin(int id) async {
    try {
      final db = await database;
      final result = await db.delete(
        'admins',
        where: 'id = ?',
        whereArgs: [id],
      );
      return result > 0;
    } catch (e) {
      print('Error deleting admin: $e');
      return false;
    }
  }

  // --- USER METHODS ---

  // Register new user
  Future<bool> registerUser(User user) async {
    try {
      // Gunakan mockAPI jika diaktifkan
      if (useMockApi) {
        return await _mockApiService.registerUser(user);
      }

      if (kIsWeb) {
        // For web, just return true (no actual storage)
        return true;
      }
      final db = await database;
      await db.insert('users', user.toMap());
      return true;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  // Login user
  Future<User?> loginUser(String email, String password) async {
    try {
      // Gunakan mockAPI jika diaktifkan
      if (useMockApi) {
        return await _mockApiService.loginUser(email, password);
      }

      if (kIsWeb) {
        // Quick web fallback: accept any user for web testing
        return User(
          id: 1,
          name: 'Test User',
          email: email,
          password: password,
          createdAt: DateTime.now(),
        );
      }
      final db = await database;
      final result = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );

      if (result.isNotEmpty) {
        return User.fromMap(result.first);
      }
      return null;
    } catch (e) {
      print('Error logging in user: $e');
      return null;
    }
  }

  // Get user by email
  Future<User?> getUserByEmail(String email) async {
    try {
      // Gunakan mockAPI jika diaktifkan
      if (useMockApi) {
        return await _mockApiService.getUserByEmail(email);
      }

      if (kIsWeb) {
        return User(
          id: 1,
          name: 'Test User',
          email: email,
          password: '',
          createdAt: DateTime.now(),
        );
      }
      final db = await database;
      final result = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (result.isNotEmpty) {
        return User.fromMap(result.first);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // Get user by ID
  Future<User?> getUserById(int id) async {
    try {
      // Gunakan mockAPI jika diaktifkan
      if (useMockApi) {
        return await _mockApiService.getUserById(id);
      }

      if (kIsWeb) {
        return User(
          id: id,
          name: 'Test User',
          email: 'user@gmail.com',
          password: 'user123',
          createdAt: DateTime.now(),
        );
      }
      final db = await database;
      final result = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result.isNotEmpty) {
        return User.fromMap(result.first);
      }
      return null;
    } catch (e) {
      print('Error getting user by id: $e');
      return null;
    }
  }

  // Get all users
  Future<List<User>> getAllUsers() async {
    try {
      if (kIsWeb) {
        return [];
      }
      final db = await database;
      final result = await db.query('users');
      return result.map((map) => User.fromMap(map)).toList();
    } catch (e) {
      print('Error getting all users: $e');
      return [];
    }
  }

  // Update user
  Future<bool> updateUser(User user) async {
    try {
      if (kIsWeb) {
        return true;
      }
      final db = await database;
      final result = await db.update(
        'users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
      return result > 0;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  // Delete user
  Future<bool> deleteUser(int id) async {
    try {
      if (kIsWeb) {
        return true;
      }
      final db = await database;
      final result = await db.delete(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
      return result > 0;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }

  // Close database
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }

  // --- Store (single) ---
  Future<Store?> getStore() async {
    try {
      if (kIsWeb) {
        final map = await webGetStore();
        if (map == null || map.isEmpty) return null;
        return Store.fromMap(map);
      }
      final db = await database;
      final result = await db.query('stores', limit: 1);
      if (result.isNotEmpty) return Store.fromMap(result.first);
      return null;
    } catch (e) {
      print('Error getting store: $e');
      return null;
    }
  }

  Future<bool> saveStore(Store store) async {
    try {
      if (kIsWeb) {
        await webSaveStore(store.toMap());
        return true;
      }
      final db = await database;
      // if an id provided, try update
      if (store.id != null) {
        final res = await db.update(
          'stores',
          store.toMap(),
          where: 'id = ?',
          whereArgs: [store.id],
        );
        if (res > 0) return true;
      }
      // otherwise check if any row exists
      final existing = await db.query('stores', limit: 1);
      if (existing.isNotEmpty) {
        final id = existing.first['id'] as int?;
        if (id != null) {
          final res = await db.update(
            'stores',
            store.toMap(),
            where: 'id = ?',
            whereArgs: [id],
          );
          return res > 0;
        }
      }
      // insert new
      await db.insert('stores', store.toMap());
      return true;
    } catch (e) {
      print('Error saving store: $e');
      return false;
    }
  }

  // --- Settings (single) ---
  Future<Settings?> getSettings() async {
    try {
      if (kIsWeb) {
        final map = await webGetSettings();
        if (map == null || map.isEmpty) return null;
        return Settings.fromMap(map);
      }
      final db = await database;
      final result = await db.query('settings', limit: 1);
      if (result.isNotEmpty) return Settings.fromMap(result.first);
      return null;
    } catch (e) {
      print('Error getting settings: $e');
      return null;
    }
  }

  Future<bool> saveSettings(Settings settings) async {
    try {
      if (kIsWeb) {
        await webSaveSettings(settings.toMap());
        return true;
      }
      final db = await database;
      // if an id provided, try update
      if (settings.id != null) {
        final res = await db.update(
          'settings',
          settings.toMap(),
          where: 'id = ?',
          whereArgs: [settings.id],
        );
        if (res > 0) return true;
      }
      // otherwise check if any row exists
      final existing = await db.query('settings', limit: 1);
      if (existing.isNotEmpty) {
        final id = existing.first['id'] as int?;
        if (id != null) {
          final res = await db.update(
            'settings',
            settings.toMap(),
            where: 'id = ?',
            whereArgs: [id],
          );
          return res > 0;
        }
      }
      // insert new
      await db.insert('settings', settings.toMap());
      return true;
    } catch (e) {
      print('Error saving settings: $e');
      return false;
    }
  }

  // Sales methods
  Future<bool> addSales(Sales sales) async {
    try {
      if (kIsWeb) {
        // Store in web localStorage via web storage
        return true; // Placeholder for web
      }
      final db = await database;
      await db.insert('sales', sales.toMap());
      return true;
    } catch (e) {
      print('Error adding sales: $e');
      return false;
    }
  }

  Future<List<Sales>> getAllSales() async {
    try {
      if (kIsWeb) {
        // For web, return empty list (sales data on desktop only)
        return [];
      }
      final db = await database;
      final result = await db.query('sales', orderBy: 'sold_at DESC');
      return result.map((map) => Sales.fromMap(map)).toList();
    } catch (e) {
      print('Error fetching sales: $e');
      return [];
    }
  }

  Future<List<Sales>> getSalesInRange(DateTime start, DateTime end) async {
    try {
      if (kIsWeb) {
        return [];
      }
      final db = await database;
      final result = await db.query(
        'sales',
        where: 'sold_at BETWEEN ? AND ?',
        whereArgs: [start.toIso8601String(), end.toIso8601String()],
        orderBy: 'sold_at DESC',
      );
      return result.map((map) => Sales.fromMap(map)).toList();
    } catch (e) {
      print('Error fetching sales in range: $e');
      return [];
    }
  }

  Future<double> getTotalSalesAmount() async {
    try {
      if (kIsWeb) {
        return 0.0;
      }
      final db = await database;
      final result = await db.rawQuery(
        'SELECT SUM(total_price) as total FROM sales',
      );
      if (result.isNotEmpty) {
        final total = result.first['total'];
        return total != null ? (total as num).toDouble() : 0.0;
      }
      return 0.0;
    } catch (e) {
      print('Error getting total sales: $e');
      return 0.0;
    }
  }

  Future<int> getTotalQuantitySold() async {
    try {
      if (kIsWeb) {
        return 0;
      }
      final db = await database;
      final result = await db.rawQuery(
        'SELECT SUM(quantity) as total FROM sales',
      );
      if (result.isNotEmpty) {
        final total = result.first['total'];
        return total != null ? (total as num).toInt() : 0;
      }
      return 0;
    } catch (e) {
      print('Error getting total quantity sold: $e');
      return 0;
    }
  }

  Future<Map<String, dynamic>> getProductPerformance() async {
    try {
      if (kIsWeb) {
        return {'products': []};
      }
      final db = await database;
      final result = await db.rawQuery('''
        SELECT product_name, SUM(quantity) as total_quantity, SUM(total_price) as revenue
        FROM sales
        GROUP BY product_id
        ORDER BY total_quantity DESC
      ''');
      return {'products': result};
    } catch (e) {
      print('Error getting product performance: $e');
      return {'products': []};
    }
  }

  Future<void> clearAllSales() async {
    try {
      if (kIsWeb) {
        return;
      }
      final db = await database;
      await db.delete('sales');
    } catch (e) {
      print('Error clearing sales: $e');
    }
  }
}
