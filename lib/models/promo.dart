class Promo {
  final int? id;
  final String title;
  final String description;
  final String code;
  final double discountPercent;
  final double discountAmount;
  final double minPurchase;
  final DateTime startDate;
  final DateTime endDate;
  final String category; // 'all', 'donuts', 'coffee', 'food'
  final int usageLimit;
  final int usedCount;
  final bool isActive;
  final String? imageUrl;

  Promo({
    this.id,
    required this.title,
    required this.description,
    required this.code,
    required this.discountPercent,
    required this.discountAmount,
    required this.minPurchase,
    required this.startDate,
    required this.endDate,
    required this.category,
    required this.usageLimit,
    required this.usedCount,
    required this.isActive,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'code': code,
      'discountPercent': discountPercent,
      'discountAmount': discountAmount,
      'minPurchase': minPurchase,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'category': category,
      'usageLimit': usageLimit,
      'usedCount': usedCount,
      'isActive': isActive,
      'imageUrl': imageUrl,
    };
  }

  factory Promo.fromMap(Map<String, dynamic> map) {
    return Promo(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      code: map['code'] ?? '',
      // support both snake_case (from DB) and camelCase (from code)
      discountPercent: ((map['discountPercent'] ?? map['discount_percent'] ?? 0) as num).toDouble(),
      discountAmount: ((map['discountAmount'] ?? map['discount_amount'] ?? 0) as num).toDouble(),
      minPurchase: ((map['minPurchase'] ?? map['min_purchase'] ?? 0) as num).toDouble(),
      startDate: map['startDate'] is DateTime
        ? map['startDate']
        : DateTime.parse(map['startDate'] ?? map['start_date'] ?? DateTime.now().toIso8601String()),
      endDate: map['endDate'] is DateTime
        ? map['endDate']
        : DateTime.parse(map['endDate'] ?? map['end_date'] ?? DateTime.now().toIso8601String()),
      category: map['category'] ?? map['cat'] ?? 'all',
      usageLimit: (map['usageLimit'] ?? map['usage_limit'] ?? 0) as int,
      usedCount: (map['usedCount'] ?? map['used_count'] ?? 0) as int,
      isActive: (map['isActive'] ?? map['is_active'] ?? 1) is int
        ? ((map['isActive'] ?? map['is_active'] ?? 1) as int) == 1
        : (map['isActive'] ?? map['is_active'] ?? true) == true,
      imageUrl: map['imageUrl'] ?? map['image_url'],
    );
  }

  bool get isExpired => DateTime.now().isAfter(endDate);

  bool get isNotStarted => DateTime.now().isBefore(startDate);

  String getStatus() {
    if (!isActive) {
      return 'Nonaktif';
    }
    if (isExpired) {
      return 'Berakhir';
    }
    if (isNotStarted) {
      return 'Belum dimulai';
    }
    if (usedCount >= usageLimit && usageLimit > 0) {
      return 'Habis';
    }
    return 'Aktif';
  }

  String getDiscountText() {
    if (discountPercent > 0) {
      return '${discountPercent.toStringAsFixed(0)}%';
    }
    return 'Rp${discountAmount.toStringAsFixed(0)}';
  }

  int getUsagePercentage() {
    if (usageLimit == 0) return 0;
    return ((usedCount / usageLimit) * 100).toInt();
  }

  String getRemainingDays() {
    final now = DateTime.now();
    if (isExpired) {
      return 'Berakhir';
    }
    final difference = endDate.difference(now).inDays;
    if (difference == 0) {
      return 'Hari ini';
    }
    return '$difference hari lagi';
  }
}
