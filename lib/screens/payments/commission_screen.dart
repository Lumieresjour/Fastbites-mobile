import 'package:flutter/material.dart';
import '../../models/commission.dart';
import '../../services/commission_service.dart';
import '../../utils/app_colors.dart';

class CommissionScreen extends StatefulWidget {
  const CommissionScreen({super.key});

  @override
  State<CommissionScreen> createState() => _CommissionScreenState();
}

class _CommissionScreenState extends State<CommissionScreen> {
  List<Commission> commissions = [];
  String selectedFilter = 'all'; // 'all', 'earned', 'pending', 'paid'
  final CommissionService _commissionService = CommissionService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCommissions();
  }

  Future<void> _loadCommissions() async {
    setState(() => _isLoading = true);
    try {
      final loadedCommissions = await _commissionService.getAllCommissions();
      if (loadedCommissions.isEmpty) {
        await _seedSampleCommissions();
        final seededCommissions = await _commissionService.getAllCommissions();
        setState(() {
          commissions = seededCommissions;
          _isLoading = false;
        });
      } else {
        setState(() {
          commissions = loadedCommissions;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading commissions: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _seedSampleCommissions() async {
    final sampleCommissions = [
      Commission(
        id: 1,
        commissionType: 'sales',
        amount: 150000,
        status: 'paid',
        sourceDescription: 'Penjualan order #1001',
        relatedId: '1001',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        paidAt: DateTime.now().subtract(const Duration(days: 5)),
        notes: 'Komisi 10% dari total penjualan',
      ),
      Commission(
        id: 2,
        commissionType: 'sales',
        amount: 200000,
        status: 'paid',
        sourceDescription: 'Penjualan order #1002',
        relatedId: '1002',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        paidAt: DateTime.now().subtract(const Duration(days: 3)),
        notes: 'Komisi 10% dari total penjualan',
      ),
      Commission(
        id: 3,
        commissionType: 'sales',
        amount: 250000,
        status: 'pending',
        sourceDescription: 'Penjualan order #1003',
        relatedId: '1003',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        notes: 'Komisi 10% dari total penjualan',
      ),
      Commission(
        id: 4,
        commissionType: 'referral',
        amount: 100000,
        status: 'earned',
        sourceDescription: 'Referral dari user baru',
        relatedId: 'user_456',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        notes: 'Bonus referral user aktif',
      ),
      Commission(
        id: 5,
        commissionType: 'bonus',
        amount: 500000,
        status: 'paid',
        sourceDescription: 'Bonus performa bulan Desember',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        paidAt: DateTime.now().subtract(const Duration(days: 10)),
        notes: 'Target penjualan tercapai 150%',
      ),
      Commission(
        id: 6,
        commissionType: 'sales',
        amount: 180000,
        status: 'earned',
        sourceDescription: 'Penjualan order #1004',
        relatedId: '1004',
        createdAt: DateTime.now(),
        notes: 'Komisi 10% dari total penjualan',
      ),
    ];
    for (final commission in sampleCommissions) {
      await _commissionService.createCommission(commission);
    }
  }

  List<Commission> _getFilteredCommissions() {
    if (selectedFilter == 'all') {
      return commissions;
    }
    return commissions.where((c) => c.status == selectedFilter).toList();
  }

  double _getTotalEarned() {
    return commissions
        .where((c) => c.status == 'earned' || c.status == 'pending' || c.status == 'paid')
        .fold(0, (sum, c) => sum + c.amount);
  }

  double _getTotalPaid() {
    return commissions.where((c) => c.status == 'paid').fold(0, (sum, c) => sum + c.amount);
  }

  double _getPendingCommission() {
    return commissions.where((c) => c.status == 'earned' || c.status == 'pending').fold(0, (sum, c) => sum + c.amount);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Komisi & Bonus',
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

    final filteredCommissions = _getFilteredCommissions();
    final totalEarned = _getTotalEarned();
    final totalPaid = _getTotalPaid();
    final pending = _getPendingCommission();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Komisi & Bonus',
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
            // Stats Cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Total Komisi',
                          totalEarned,
                          AppColors.primaryGreen,
                          Icons.trending_up,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Sudah Dibayar',
                          totalPaid,
                          AppColors.success,
                          Icons.check_circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Pending',
                          pending,
                          Colors.orange,
                          Icons.hourglass_empty,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Rata-rata/Bulan',
                          totalPaid / 3, // Example: assume 3 months of data
                          Colors.blue,
                          Icons.bar_chart,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Filter Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFilterButton('Semua', 'all'),
                  _buildFilterButton('Diterima', 'earned'),
                  _buildFilterButton('Menunggu', 'pending'),
                  _buildFilterButton('Dibayar', 'paid'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Commissions List
            if (filteredCommissions.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.card_giftcard_outlined,
                      size: 64,
                      color: AppColors.lightGreen,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Belum ada komisi',
                      style: TextStyle(
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
                itemCount: filteredCommissions.length,
                itemBuilder: (context, index) {
                  final commission = filteredCommissions[index];
                  return _buildCommissionCard(commission);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, double amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.lightText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, color: color, size: 16),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Rp${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, String filter) {
    final isSelected = selectedFilter == filter;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = filter;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  Widget _buildCommissionCard(Commission commission) {
    final statusColor = _getStatusColor(commission.status);
    final typeIcon = _getTypeIcon(commission.commissionType);

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
            // Header
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
                          commission.getTypeLabel(),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkText,
                          ),
                        ),
                        if (commission.sourceDescription != null)
                          Text(
                            commission.sourceDescription!,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.lightText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                    commission.getStatusLabel(),
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

            // Amount & Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Jumlah Komisi',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.lightText,
                      ),
                    ),
                    Text(
                      commission.getFormattedAmount(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Tanggal Terima',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.lightText,
                      ),
                    ),
                    Text(
                      commission.getFormattedDate(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            if (commission.paidAt != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.check_circle, color: AppColors.success, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    'Dibayar: ${commission.paidAt!.day}/${commission.paidAt!.month}/${commission.paidAt!.year}',
                    style: const TextStyle(
                      fontSize: 9,
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],

            if (commission.notes != null) ...[
              const SizedBox(height: 8),
              Text(
                commission.notes!,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.lightText,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'earned':
        return AppColors.primaryGreen;
      case 'pending':
        return Colors.orange;
      case 'paid':
        return AppColors.success;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'sales':
        return Icons.shopping_cart;
      case 'referral':
        return Icons.people_alt;
      case 'bonus':
        return Icons.card_giftcard;
      default:
        return Icons.trending_up;
    }
  }
}
