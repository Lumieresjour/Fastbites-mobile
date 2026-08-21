import 'package:flutter/material.dart';
import '../../models/payment.dart';
import '../../services/payment_service.dart';
import '../../utils/app_colors.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<Payment> payments = [];
  String selectedTab = 'withdrawal'; // 'withdrawal', 'history'
  double availableBalance = 2500000.0; // Saldo yang bisa dicairkan
  final PaymentService _paymentService = PaymentService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  Future<void> _loadPayments() async {
    setState(() => _isLoading = true);
    try {
      final loadedPayments = await _paymentService.getAllPayments();
      if (loadedPayments.isEmpty) {
        await _seedSamplePayments();
        final seededPayments = await _paymentService.getAllPayments();
        setState(() {
          payments = seededPayments;
          _isLoading = false;
        });
      } else {
        setState(() {
          payments = loadedPayments;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading payments: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _seedSamplePayments() async {
    final samplePayments = [
      Payment(
        id: 1,
        paymentType: 'withdrawal',
        amount: 1000000,
        status: 'completed',
        bankName: 'BCA',
        accountNumber: '1234567890',
        accountHolder: 'Admin Toko',
        description: 'Pencairan dana penjualan',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        processedAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        transactionId: 'TXN-001-20231205',
      ),
      Payment(
        id: 2,
        paymentType: 'withdrawal',
        amount: 500000,
        status: 'processing',
        bankName: 'Mandiri',
        accountNumber: '9876543210',
        accountHolder: 'Admin Toko',
        description: 'Pencairan dana terbaru',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        transactionId: 'TXN-002-20231207',
      ),
      Payment(
        id: 3,
        paymentType: 'refund',
        amount: 50000,
        status: 'completed',
        description: 'Pengembalian dana dari pembeli',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        processedAt: DateTime.now().subtract(const Duration(days: 4, hours: 1)),
      ),
      Payment(
        id: 4,
        paymentType: 'compensation',
        amount: 100000,
        status: 'completed',
        description: 'Kompensasi untuk order bermasalah',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        processedAt: DateTime.now().subtract(const Duration(days: 9, hours: 5)),
      ),
    ];
    for (final payment in samplePayments) {
      await _paymentService.createPayment(payment);
    }
  }

  List<Payment> _getFilteredPayments() {
    if (selectedTab == 'withdrawal') {
      return payments.where((p) => p.paymentType == 'withdrawal').toList();
    } else {
      return payments;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Pembayaran & Komisi',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.primaryGreen,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final filteredPayments = _getFilteredPayments();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Pembayaran & Komisi',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Saldo Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryGreen, AppColors.lightGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGreen.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saldo Dapat Dicairkan',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp${availableBalance.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _showWithdrawalForm,
                          icon: const Icon(Icons.payment, size: 16),
                          label: const Text('Cairkan Dana'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primaryGreen,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Lihat detail rekening...'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.info_outline, size: 16),
                          label: const Text('Rekening'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white, width: 2),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => selectedTab = 'withdrawal');
                      },
                      child: Column(
                        children: [
                          Text(
                            'Pencairan Dana',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: selectedTab == 'withdrawal' ? FontWeight.bold : FontWeight.normal,
                              color: selectedTab == 'withdrawal' ? AppColors.primaryGreen : AppColors.lightText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (selectedTab == 'withdrawal')
                            Container(
                              height: 2,
                              color: AppColors.primaryGreen,
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => selectedTab = 'history');
                      },
                      child: Column(
                        children: [
                          Text(
                            'History Pembayaran',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: selectedTab == 'history' ? FontWeight.bold : FontWeight.normal,
                              color: selectedTab == 'history' ? AppColors.primaryGreen : AppColors.lightText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (selectedTab == 'history')
                            Container(
                              height: 2,
                              color: AppColors.primaryGreen,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Payments List
            if (filteredPayments.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    const Icon(
                      Icons.receipt_long_outlined,
                      size: 64,
                      color: AppColors.lightGreen,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      selectedTab == 'withdrawal' ? 'Belum ada pencairan' : 'Belum ada history pembayaran',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.lightText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredPayments.length,
                itemBuilder: (context, index) {
                  final payment = filteredPayments[index];
                  return _buildPaymentCard(payment);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCard(Payment payment) {
    final statusColor = _getStatusColor(payment.status);
    final typeIcon = _getPaymentTypeIcon(payment.paymentType);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Type, Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        typeIcon,
                        color: AppColors.primaryGreen,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          payment.getPaymentTypeLabel(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkText,
                          ),
                        ),
                        Text(
                          payment.getFormattedDate(),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.lightText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    payment.getStatusLabel(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Divider
            Container(
              height: 1,
              color: Colors.grey[100],
            ),
            const SizedBox(height: 12),

            // Amount & Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Jumlah',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.lightText,
                      ),
                    ),
                    Text(
                      payment.getFormattedAmount(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
                if (payment.bankName != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        payment.bankName!,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                      Text(
                        payment.accountNumber ?? '',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.lightText,
                        ),
                      ),
                    ],
                  ),
              ],
            ),

            if (payment.description != null) ...[
              const SizedBox(height: 8),
              Text(
                payment.description!,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.lightText,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],

            if (payment.transactionId != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ID Transaksi',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.lightText,
                    ),
                  ),
                  Text(
                    payment.transactionId!,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                      fontFamily: 'Courier',
                    ),
                  ),
                ],
              ),
            ],

            // Action Buttons (if pending/processing)
            if (payment.status == 'pending' || payment.status == 'processing')
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Pembayaran "${payment.getPaymentTypeLabel()}" dibatalkan'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.close, size: 14),
                      label: const Text('Batalkan'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showWithdrawalForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cairkan Dana'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saldo Anda: Rp${availableBalance.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Jumlah (Rp)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixText: 'Rp ',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            const Text(
              'Bank Tujuan',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('BCA - 1234567890'),
                  Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 20),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Permintaan pencairan dana telah diajukan'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
            ),
            child: const Text('Cairkan'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return AppColors.success;
      case 'processing':
        return Colors.orange;
      case 'pending':
        return Colors.blue;
      case 'failed':
      case 'cancelled':
        return AppColors.error;
      default:
        return Colors.grey;
    }
  }

  IconData _getPaymentTypeIcon(String type) {
    switch (type) {
      case 'withdrawal':
        return Icons.account_balance_wallet;
      case 'refund':
        return Icons.assignment_return;
      case 'compensation':
        return Icons.card_giftcard;
      default:
        return Icons.payment;
    }
  }
}
