class Partner {
  final int? id;
  final String partnerName;
  final String ownerName;
  final String email;
  final String phone;
  final String businessType; // 'donat', 'kopi', 'makanan', 'minuman', 'lainnya'
  final String businessAddress;
  final String businessCity;
  final String businessProvince;
  final String businessPostalCode;
  final String businessRegistration; // Nomor SIUP, NIB, atau dokumen lainnya
  final String taxId; // NPWP
  final double estimatedMonthlyRevenue; // Estimasi revenue bulanan
  final String bankName;
  final String bankAccountNumber;
  final String bankAccountHolder;
  final String status; // 'pending', 'approved', 'rejected', 'suspended', 'active'
  final double rating; // Rating dari 1-5
  final int totalOrders;
  final DateTime createdAt;
  final DateTime? approvedAt;
  final DateTime? rejectedAt;
  final String? rejectionReason;
  final String? notes;

  Partner({
    this.id,
    required this.partnerName,
    required this.ownerName,
    required this.email,
    required this.phone,
    required this.businessType,
    required this.businessAddress,
    required this.businessCity,
    required this.businessProvince,
    required this.businessPostalCode,
    required this.businessRegistration,
    required this.taxId,
    required this.estimatedMonthlyRevenue,
    required this.bankName,
    required this.bankAccountNumber,
    required this.bankAccountHolder,
    required this.status,
    this.rating = 0.0,
    this.totalOrders = 0,
    required this.createdAt,
    this.approvedAt,
    this.rejectedAt,
    this.rejectionReason,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'partnerName': partnerName,
      'ownerName': ownerName,
      'email': email,
      'phone': phone,
      'businessType': businessType,
      'businessAddress': businessAddress,
      'businessCity': businessCity,
      'businessProvince': businessProvince,
      'businessPostalCode': businessPostalCode,
      'businessRegistration': businessRegistration,
      'taxId': taxId,
      'estimatedMonthlyRevenue': estimatedMonthlyRevenue,
      'bankName': bankName,
      'bankAccountNumber': bankAccountNumber,
      'bankAccountHolder': bankAccountHolder,
      'status': status,
      'rating': rating,
      'totalOrders': totalOrders,
      'createdAt': createdAt.toIso8601String(),
      'approvedAt': approvedAt?.toIso8601String(),
      'rejectedAt': rejectedAt?.toIso8601String(),
      'rejectionReason': rejectionReason,
      'notes': notes,
    };
  }

  factory Partner.fromMap(Map<String, dynamic> map) {
    return Partner(
      id: map['id'],
      partnerName: map['partnerName'] ?? map['partner_name'] ?? '',
      ownerName: map['ownerName'] ?? map['owner_name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      businessType: map['businessType'] ?? map['business_type'] ?? 'lainnya',
      businessAddress: map['businessAddress'] ?? map['business_address'] ?? '',
      businessCity: map['businessCity'] ?? map['business_city'] ?? '',
      businessProvince: map['businessProvince'] ?? map['business_province'] ?? '',
      businessPostalCode: map['businessPostalCode'] ?? map['business_postal_code'] ?? '',
      businessRegistration: map['businessRegistration'] ?? map['business_registration'] ?? '',
      taxId: map['taxId'] ?? map['tax_id'] ?? '',
      estimatedMonthlyRevenue: (map['estimatedMonthlyRevenue'] ?? map['estimated_monthly_revenue'] ?? 0).toDouble(),
      bankName: map['bankName'] ?? map['bank_name'] ?? '',
      bankAccountNumber: map['bankAccountNumber'] ?? map['bank_account_number'] ?? '',
      bankAccountHolder: map['bankAccountHolder'] ?? map['bank_account_holder'] ?? '',
      status: map['status'] ?? 'pending',
      rating: (map['rating'] ?? 0).toDouble(),
      totalOrders: map['totalOrders'] ?? map['total_orders'] ?? 0,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : (map['created_at'] != null ? DateTime.parse(map['created_at']) : DateTime.now()),
      approvedAt: map['approvedAt'] != null ? DateTime.parse(map['approvedAt']) : (map['approved_at'] != null ? DateTime.parse(map['approved_at']) : null),
      rejectedAt: map['rejectedAt'] != null ? DateTime.parse(map['rejectedAt']) : (map['rejected_at'] != null ? DateTime.parse(map['rejected_at']) : null),
      rejectionReason: map['rejectionReason'] ?? map['rejection_reason'],
      notes: map['notes'],
    );
  }

  String getStatusLabel() {
    switch (status) {
      case 'pending':
        return 'Menunggu Persetujuan';
      case 'approved':
        return 'Disetujui';
      case 'rejected':
        return 'Ditolak';
      case 'suspended':
        return 'Dibekukan';
      case 'active':
        return 'Aktif';
      default:
        return status;
    }
  }

  String getStatusLabelShort() {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'approved':
        return 'Disetujui';
      case 'rejected':
        return 'Ditolak';
      case 'suspended':
        return 'Dibekukan';
      case 'active':
        return 'Aktif';
      default:
        return status;
    }
  }

  String getFormattedDate() {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays == 0) {
      return 'Hari ini';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks minggu lalu';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months bulan lalu';
    }
  }

  String getFormattedRevenue() {
    if (estimatedMonthlyRevenue >= 1000000) {
      return 'Rp${(estimatedMonthlyRevenue / 1000000).toStringAsFixed(1)}M';
    } else if (estimatedMonthlyRevenue >= 1000) {
      return 'Rp${(estimatedMonthlyRevenue / 1000).toStringAsFixed(1)}K';
    } else {
      return 'Rp${estimatedMonthlyRevenue.toStringAsFixed(0)}';
    }
  }

  String getBusinessTypeLabel() {
    switch (businessType) {
      case 'donat':
        return 'Donat';
      case 'kopi':
        return 'Kopi';
      case 'makanan':
        return 'Makanan';
      case 'minuman':
        return 'Minuman';
      case 'lainnya':
        return 'Lainnya';
      default:
        return businessType;
    }
  }
}
