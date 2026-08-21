class Admin {
  final int? id;
  final String name;
  final String email;
  final String password;
  final DateTime createdAt;

  Admin({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.createdAt,
  });

  // Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Create Admin from database Map
  factory Admin.fromMap(Map<String, dynamic> map) {
    // Handle ID yang bisa string (dari mockAPI) atau int (dari SQLite)
    int? id;
    if (map['id'] != null) {
      id = map['id'] is int ? map['id'] : int.tryParse(map['id'].toString());
    }
    
    return Admin(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'Admin(id: $id, name: $name, email: $email, createdAt: $createdAt)';
  }
}
