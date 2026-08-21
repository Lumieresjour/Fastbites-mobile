class User {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String? address;
  final DateTime createdAt;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.address,
    required this.createdAt,
  });

  // Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'address': address,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Create User from database Map
  factory User.fromMap(Map<String, dynamic> map) {
    // Handle ID yang bisa string (dari mockAPI) atau int (dari SQLite)
    int? id;
    if (map['id'] != null) {
      id = map['id'] is int ? map['id'] : int.tryParse(map['id'].toString());
    }
    
    return User(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      phone: map['phone'],
      address: map['address'],
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, createdAt: $createdAt)';
  }
}
