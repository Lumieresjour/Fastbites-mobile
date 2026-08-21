class Payment {
  final int? id;
  final String paymentType; // 'withdrawal', 'refund', 'compensation'
  final double amount;
  final String status; // 'pending', 'processing', 'completed', 'failed', 'cancelled'
  final String? bankName;
  final String? accountNumber;
  final String? accountHolder;
  final String? description;
  final DateTime createdAt;
  final DateTime? processedAt;
  final String? transactionId;
  final String? failureReason;

  Payment({
    this.id,
    required this.paymentType,
    required this.amount,
    required this.status,
    this.bankName,
    this.accountNumber,
    this.accountHolder,
    this.description,
    required this.createdAt,
    this.processedAt,
    this.transactionId,
    this.failureReason,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'payment_type': paymentType,
      'amount': amount,
      'status': status,
      'bank_name': bankName,
      'account_number': accountNumber,
      'account_holder': accountHolder,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'processed_at': processedAt?.toIso8601String(),
      'transaction_id': transactionId,
      'failure_reason': failureReason,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'],
      paymentType: (map['paymentType'] ?? map['payment_type'] ?? 'withdrawal'),
      amount: ((map['amount'] ?? 0) as num).toDouble(),
      status: (map['status'] ?? 'pending'),
      bankName: map['bankName'] ?? map['bank_name'],
      accountNumber: map['accountNumber'] ?? map['account_number'],
      accountHolder: map['accountHolder'] ?? map['account_holder'],
      description: map['description'],
      createdAt: map['createdAt'] is DateTime
          ? map['createdAt']
          : DateTime.parse(map['createdAt'] ?? map['created_at'] ?? DateTime.now().toIso8601String()),
      processedAt: map['processedAt'] is DateTime
          ? map['processedAt']
          : (map['processedAt'] ?? map['processed_at']) != null
              ? DateTime.parse(map['processedAt'] ?? map['processed_at'])
              : null,
      transactionId: map['transactionId'] ?? map['transaction_id'],
      failureReason: map['failureReason'] ?? map['failure_reason'],
    );
  }

  String getStatusLabel() {
    switch (status) {
      case 'pending':
        return 'Menunggu';
      case 'processing':
        return 'Diproses';
      case 'completed':
        return 'Selesai';
      case 'failed':
        return 'Gagal';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  String getPaymentTypeLabel() {
    switch (paymentType) {
      case 'withdrawal':
        return 'Pencairan Dana';
      case 'refund':
        return 'Pengembalian Dana';
      case 'compensation':
        return 'Kompensasi';
      default:
        return paymentType;
    }
  }

  String getFormattedDate() {
    return '${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year}';
  }

  String getFormattedAmount() {
    return 'Rp${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}';
  }
}
