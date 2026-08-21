class Product {
  final int? id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String sku;
  final String? image; // asset path like 'assets/images/foo.jpg'
  final DateTime createdAt;
  final String category; // 'makanan' or 'minuman'

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.sku,
    this.image,
    required this.createdAt,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'sku': sku,
      'image': image,
      'created_at': createdAt.toIso8601String(),
      'category': category,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'] ?? '',
      price:
          map['price'] == null
              ? 0.0
              : ((map['price'] is int)
                  ? (map['price'] as int).toDouble()
                  : (map['price'] as double)),
      stock: map['stock'] ?? 0,
      sku: map['sku'] ?? '',
      image: map['image'] as String?,
      createdAt: DateTime.parse(map['created_at']),
      category: map['category'] ?? 'makanan',
    );
  }
}
