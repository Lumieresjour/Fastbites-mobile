class Order {
  final int? id;
  final String orderNumber; // e.g., "ORD-2023-001"
  final String buyerName;
  final String buyerPhone;
  final String buyerEmail;
  final double totalAmount;
  final String paymentStatus; // 'paid', 'pending', 'failed'
  final String orderStatus; // 'pending', 'processing', 'shipped', 'delivered', 'cancelled', 'returned'
  final String shippingMethod; // 'regular', 'express', 'same-day'
  final String shippingAddress;
  final String shippingCity;
  final String shippingProvince;
  final String shippingPostalCode;
  final String? courierName; // 'JNE', 'Gojek', etc.
  final String? trackingNumber;
  final DateTime createdAt;
  final DateTime? paidAt;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;
  final List<OrderItem>? items; // List of products in order
  final String? notes;

  Order({
    this.id,
    required this.orderNumber,
    required this.buyerName,
    required this.buyerPhone,
    required this.buyerEmail,
    required this.totalAmount,
    required this.paymentStatus,
    required this.orderStatus,
    required this.shippingMethod,
    required this.shippingAddress,
    required this.shippingCity,
    required this.shippingProvince,
    required this.shippingPostalCode,
    this.courierName,
    this.trackingNumber,
    required this.createdAt,
    this.paidAt,
    this.shippedAt,
    this.deliveredAt,
    this.items,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_number': orderNumber,
      'buyer_name': buyerName,
      'buyer_phone': buyerPhone,
      'buyer_email': buyerEmail,
      'total_amount': totalAmount,
      'payment_status': paymentStatus,
      'order_status': orderStatus,
      'shipping_method': shippingMethod,
      'shipping_address': shippingAddress,
      'shipping_city': shippingCity,
      'shipping_province': shippingProvince,
      'shipping_postal_code': shippingPostalCode,
      'courier_name': courierName,
      'tracking_number': trackingNumber,
      'created_at': createdAt.toIso8601String(),
      'paid_at': paidAt?.toIso8601String(),
      'shipped_at': shippedAt?.toIso8601String(),
      'delivered_at': deliveredAt?.toIso8601String(),
      'notes': notes,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      orderNumber: map['orderNumber'] ?? map['order_number'] ?? '',
      buyerName: map['buyerName'] ?? map['buyer_name'] ?? '',
      buyerPhone: map['buyerPhone'] ?? map['buyer_phone'] ?? '',
      buyerEmail: map['buyerEmail'] ?? map['buyer_email'] ?? '',
      totalAmount: ((map['totalAmount'] ?? map['total_amount'] ?? 0) as num).toDouble(),
      paymentStatus: map['paymentStatus'] ?? map['payment_status'] ?? 'pending',
      orderStatus: map['orderStatus'] ?? map['order_status'] ?? 'pending',
      shippingMethod: map['shippingMethod'] ?? map['shipping_method'] ?? 'regular',
      shippingAddress: map['shippingAddress'] ?? map['shipping_address'] ?? '',
      shippingCity: map['shippingCity'] ?? map['shipping_city'] ?? '',
      shippingProvince: map['shippingProvince'] ?? map['shipping_province'] ?? '',
      shippingPostalCode: map['shippingPostalCode'] ?? map['shipping_postal_code'] ?? '',
      courierName: map['courierName'] ?? map['courier_name'],
      trackingNumber: map['trackingNumber'] ?? map['tracking_number'],
      createdAt: map['createdAt'] is DateTime
          ? map['createdAt']
          : DateTime.parse(map['createdAt'] ?? map['created_at'] ?? DateTime.now().toIso8601String()),
      paidAt: map['paidAt'] is DateTime
          ? map['paidAt']
          : (map['paidAt'] ?? map['paid_at']) != null
              ? DateTime.parse(map['paidAt'] ?? map['paid_at'])
              : null,
      shippedAt: map['shippedAt'] is DateTime
          ? map['shippedAt']
          : (map['shippedAt'] ?? map['shipped_at']) != null
              ? DateTime.parse(map['shippedAt'] ?? map['shipped_at'])
              : null,
      deliveredAt: map['deliveredAt'] is DateTime
          ? map['deliveredAt']
          : (map['deliveredAt'] ?? map['delivered_at']) != null
              ? DateTime.parse(map['deliveredAt'] ?? map['delivered_at'])
              : null,
      notes: map['notes'],
    );
  }

  String getPaymentStatusLabel() {
    switch (paymentStatus) {
      case 'paid':
        return 'Sudah Dibayar';
      case 'pending':
        return 'Menunggu Pembayaran';
      case 'failed':
        return 'Pembayaran Gagal';
      default:
        return paymentStatus;
    }
  }

  String getOrderStatusLabel() {
    switch (orderStatus) {
      case 'pending':
        return 'Menunggu Konfirmasi';
      case 'processing':
        return 'Diproses';
      case 'shipped':
        return 'Dikirim';
      case 'delivered':
        return 'Tiba';
      case 'cancelled':
        return 'Dibatalkan';
      case 'returned':
        return 'Dikembalikan';
      default:
        return orderStatus;
    }
  }

  String getFormattedAmount() {
    return 'Rp${totalAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}';
  }

  String getFormattedDate() {
    return '${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year}';
  }

  int getDaysAgo() {
    return DateTime.now().difference(createdAt).inDays;
  }
}

class OrderItem {
  final int? id;
  final int orderId;
  final int productId;
  final String productName;
  final int quantity;
  final double pricePerUnit;
  final double subtotal;

  OrderItem({
    this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.pricePerUnit,
    required this.subtotal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'price_per_unit': pricePerUnit,
      'subtotal': subtotal,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'],
      orderId: map['orderId'] ?? map['order_id'] ?? 0,
      productId: map['productId'] ?? map['product_id'] ?? 0,
      productName: map['productName'] ?? map['product_name'] ?? '',
      quantity: (map['quantity'] ?? 0) as int,
      pricePerUnit: ((map['pricePerUnit'] ?? map['price_per_unit'] ?? 0) as num).toDouble(),
      subtotal: ((map['subtotal'] ?? 0) as num).toDouble(),
    );
  }
}
