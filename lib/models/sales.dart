class Sales {
  final int? id;
  final int productId;
  final String productName;
  final int quantity;
  final double totalPrice;
  final DateTime soldAt;

  Sales({
    this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.totalPrice,
    required this.soldAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'total_price': totalPrice,
      'sold_at': soldAt.toIso8601String(),
    };
  }

  factory Sales.fromMap(Map<String, dynamic> map) {
    return Sales(
      id: map['id'],
      productId: map['product_id'],
      productName: map['product_name'] ?? '',
      quantity: map['quantity'] ?? 0,
      totalPrice:
          map['total_price'] == null
              ? 0.0
              : ((map['total_price'] is int)
                  ? (map['total_price'] as int).toDouble()
                  : (map['total_price'] as double)),
      soldAt: DateTime.parse(map['sold_at']),
    );
  }
}
