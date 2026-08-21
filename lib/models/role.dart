class Role {
  final int? id;
  final String name;
  final String? description;
  final String colorHex;
  final List<String> permissions;
  final int userCount;
  final String? createdAt;
  final String? updatedAt;

  Role({
    this.id,
    required this.name,
    this.description,
    required this.colorHex,
    required this.permissions,
    this.userCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory Role.fromMap(Map<String, dynamic> m) {
    return Role(
      id: m['id'] as int?,
      name: (m['name'] ?? '') as String,
      description: m['description'] as String?,
      colorHex: (m['color_hex'] ?? '#9E9E9E') as String,
      permissions:
          (m['permissions'] is String)
              ? ((m['permissions'] as String).isEmpty
                  ? <String>[]
                  : (m['permissions'] as String).split(','))
              : (m['permissions'] as List<dynamic>?)
                      ?.map((e) => e.toString())
                      .toList() ??
                  <String>[],
      userCount: (m['user_count'] ?? 0) as int,
      createdAt: m['created_at'] as String?,
      updatedAt: m['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toDbMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'color_hex': colorHex,
      'permissions': permissions.join(','),
      'user_count': userCount,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Returns a map shaped like the UI expects: color as a `Color` is not
  /// produced here to keep the model Dart-only. The service will convert
  /// colorHex to a Color when building UI maps.
  Map<String, dynamic> toMap() => toDbMap();

  /// Create a copy of this Role with optional field overrides
  Role copyWith({
    int? id,
    String? name,
    String? description,
    String? colorHex,
    List<String>? permissions,
    int? userCount,
    String? createdAt,
    String? updatedAt,
  }) {
    return Role(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      colorHex: colorHex ?? this.colorHex,
      permissions: permissions ?? this.permissions,
      userCount: userCount ?? this.userCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
