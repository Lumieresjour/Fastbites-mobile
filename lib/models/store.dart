class Store {
  final int? id;
  final String? name;
  final String? description;
  final String? category;
  final String? location;
  final String? openingHours;
  final String? logo; // asset path like 'assets/images/foo.jpg'
  final String? phone;
  final String? email;
  final DateTime? updatedAt;

  Store({
    this.id,
    this.name,
    this.description,
    this.category,
    this.location,
    this.openingHours,
    this.logo,
    this.phone,
    this.email,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'name': name,
    'description': description,
    'category': category,
    'location': location,
    'opening_hours': openingHours,
    'logo': logo,
    'phone': phone,
    'email': email,
    'updated_at': updatedAt?.toIso8601String(),
  };

  factory Store.fromMap(Map<String, dynamic> m) => Store(
    id: m['id'] as int?,
    name: m['name'] as String?,
    description: m['description'] as String?,
    category: m['category'] as String?,
    location: m['location'] as String?,
    openingHours: m['opening_hours'] as String?,
    logo: m['logo'] as String?,
    phone: m['phone'] as String?,
    email: m['email'] as String?,
    updatedAt:
        m['updated_at'] != null
            ? DateTime.tryParse(m['updated_at'] as String)
            : null,
  );
}
