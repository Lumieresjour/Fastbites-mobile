class Commission {
  final int? id;
  final String commissionType; // 'sales', 'referral', 'bonus'
  final double amount;
  final String status; // 'earned', 'pending', 'paid'
  final String? sourceDescription; // e.g., "Penjualan order #123"
  final String? relatedId; // order_id, referral_id, etc.
  final DateTime createdAt;
  final DateTime? paidAt;
  final String? notes;

  Commission({
    this.id,
    required this.commissionType,
    required this.amount,
    required this.status,
    this.sourceDescription,
    this.relatedId,
    required this.createdAt,
    this.paidAt,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'commission_type': commissionType,
      'amount': amount,
      'status': status,
      'source_description': sourceDescription,
      'related_id': relatedId,
      'created_at': createdAt.toIso8601String(),
      'paid_at': paidAt?.toIso8601String(),
      'notes': notes,
    };
  }

  factory Commission.fromMap(Map<String, dynamic> map) {
    return Commission(
      id: map['id'],
      commissionType: (map['commissionType'] ?? map['commission_type'] ?? 'sales'),
      amount: ((map['amount'] ?? 0) as num).toDouble(),
      status: (map['status'] ?? 'earned'),
      sourceDescription: map['sourceDescription'] ?? map['source_description'],
      relatedId: map['relatedId'] ?? map['related_id'],
      createdAt: map['createdAt'] is DateTime
          ? map['createdAt']
          : DateTime.parse(map['createdAt'] ?? map['created_at'] ?? DateTime.now().toIso8601String()),
      paidAt: map['paidAt'] is DateTime
          ? map['paidAt']
          : (map['paidAt'] ?? map['paid_at']) != null
              ? DateTime.parse(map['paidAt'] ?? map['paid_at'])
              : null,
      notes: map['notes'],
    );
  }

  String getStatusLabel() {
    switch (status) {
      case 'earned':
        return 'Diterima';
      case 'pending':
        return 'Menunggu';
      case 'paid':
        return 'Sudah Dibayar';
      default:
        return status;
    }
  }

  String getTypeLabel() {
    switch (commissionType) {
      case 'sales':
        return 'Komisi Penjualan';
      case 'referral':
        return 'Komisi Referral';
      case 'bonus':
        return 'Bonus';
      default:
        return commissionType;
    }
  }

  String getFormattedDate() {
    return '${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year}';
  }

  String getFormattedAmount() {
    return 'Rp${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}';
  }

  int getDaysAgo() {
    return DateTime.now().difference(createdAt).inDays;
  }
}
