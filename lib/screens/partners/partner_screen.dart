import 'package:flutter/material.dart';
import '../../models/partner.dart';
import '../../services/partner_service.dart';
import '../../utils/app_colors.dart';

class PartnerScreen extends StatefulWidget {
  const PartnerScreen({super.key});

  @override
  State<PartnerScreen> createState() => _PartnerScreenState();
}

class _PartnerScreenState extends State<PartnerScreen> {
  List<Partner> partners = [];
  String selectedStatus =
      'all'; // 'all', 'pending', 'approved', 'active', 'rejected', 'suspended'
  final PartnerService _partnerService = PartnerService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPartners();
  }

  Future<void> _loadPartners() async {
    setState(() => _isLoading = true);
    try {
      final loadedPartners = await _partnerService.getAllPartners();
      if (loadedPartners.isEmpty) {
        await _seedSamplePartners();
        final seededPartners = await _partnerService.getAllPartners();
        setState(() {
          partners = seededPartners;
          _isLoading = false;
        });
      } else {
        setState(() {
          partners = loadedPartners;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading partners: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _seedSamplePartners() async {
    final samplePartners = [
      Partner(
        id: 1,
        partnerName: 'Donat Lezat Jaya',
        ownerName: 'Bambang Suryanto',
        email: 'bambang@donatjaya.com',
        phone: '081234567890',
        businessType: 'donat',
        businessAddress: 'Jl. Merdeka No. 123',
        businessCity: 'Jatimulya',
        businessProvince: 'Jawa Barat',
        businessPostalCode: '12000',
        businessRegistration: 'SIUP-JABAR-2023-001',
        taxId: '12.345.678.9-123.000',
        estimatedMonthlyRevenue: 50000000,
        bankName: 'BCA',
        bankAccountNumber: '1234567890',
        bankAccountHolder: 'Bambang Suryanto',
        status: 'active',
        rating: 4.8,
        totalOrders: 245,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        approvedAt: DateTime.now().subtract(const Duration(days: 55)),
        notes: 'Mitra berkualitas tinggi',
      ),
      Partner(
        id: 2,
        partnerName: 'Kopi Premium Suara',
        ownerName: 'Siti Nurhaliza',
        email: 'siti@kopipremium.com',
        phone: '082345678901',
        businessType: 'kopi',
        businessAddress: 'Jl. Sudirman No. 456',
        businessCity: 'Bekasi Timur',
        businessProvince: 'Jawa Barat',
        businessPostalCode: '40123',
        businessRegistration: 'SIUP-JABAR-2023-045',
        taxId: '23.456.789.0-234.000',
        estimatedMonthlyRevenue: 75000000,
        bankName: 'Mandiri',
        bankAccountNumber: '9876543210',
        bankAccountHolder: 'Siti Nurhaliza',
        status: 'active',
        rating: 4.6,
        totalOrders: 189,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        approvedAt: DateTime.now().subtract(const Duration(days: 40)),
        notes: 'Produk kualitas terbaik',
      ),
      Partner(
        id: 3,
        partnerName: 'Manis Donat Harapan',
        ownerName: 'Ahmad Rahman',
        email: 'ahmad@donatharapan.com',
        phone: '083456789012',
        businessType: 'makanan',
        businessAddress: 'Jl. Ahmad Yani No. 789',
        businessCity: 'Harapan Indah',
        businessProvince: 'Jawa Barat',
        businessPostalCode: '60123',
        businessRegistration: 'SIUP-JABAR-2023-078',
        taxId: '34.567.890.1-345.000',
        estimatedMonthlyRevenue: 60000000,
        bankName: 'BRI',
        bankAccountNumber: '1122334455',
        bankAccountHolder: 'Ahmad Rahman',
        status: 'pending',
        rating: 0,
        totalOrders: 0,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        notes: 'Menunggu verifikasi dokumen',
      ),
      Partner(
        id: 4,
        partnerName: 'Kopi Sudut Jalan',
        ownerName: 'Dewi Lestari',
        email: 'dewi@kopisudutjalan.com',
        phone: '084567890123',
        businessType: 'minuman',
        businessAddress: 'Jl. Gatot Subroto No. 321',
        businessCity: 'Jatibening',
        businessProvince: 'Jawa Barat',
        businessPostalCode: '20123',
        businessRegistration: 'SIUP-JABAR-2023-092',
        taxId: '45.678.901.2-456.000',
        estimatedMonthlyRevenue: 35000000,
        bankName: 'BNI',
        bankAccountNumber: '6655443322',
        bankAccountHolder: 'Dewi Lestari',
        status: 'approved',
        rating: 4.5,
        totalOrders: 0,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        approvedAt: DateTime.now().subtract(const Duration(days: 10)),
        notes: 'Baru disetujui, belum ada transaksi',
      ),
    ];
    for (final partner in samplePartners) {
      await _partnerService.createPartner(partner);
    }
  }

  List<Partner> _getFilteredPartners() {
    if (selectedStatus == 'all') {
      return partners;
    }
    return partners.where((p) => p.status == selectedStatus).toList();
  }

  int _getPendingCount() => partners.where((p) => p.status == 'pending').length;
  int _getApprovedCount() =>
      partners.where((p) => p.status == 'approved').length;
  int _getActiveCount() => partners.where((p) => p.status == 'active').length;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Manajemen Mitra',
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

    final filteredPartners = _getFilteredPartners();
    final pendingCount = _getPendingCount();
    final approvedCount = _getApprovedCount();
    final activeCount = _getActiveCount();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Manajemen Mitra',
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
            // Summary Cards
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          'Menunggu Persetujuan',
                          pendingCount.toString(),
                          Colors.orange,
                          Icons.hourglass_empty,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSummaryCard(
                          'Disetujui',
                          approvedCount.toString(),
                          Colors.blue,
                          Icons.check_circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          'Aktif',
                          activeCount.toString(),
                          AppColors.primaryGreen,
                          Icons.verified,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSummaryCard(
                          'Total Mitra',
                          partners.length.toString(),
                          Colors.purple,
                          Icons.people,
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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterButton('Semua', 'all'),
                    const SizedBox(width: 8),
                    _buildFilterButton('Pending', 'pending'),
                    const SizedBox(width: 8),
                    _buildFilterButton('Disetujui', 'approved'),
                    const SizedBox(width: 8),
                    _buildFilterButton('Aktif', 'active'),
                    const SizedBox(width: 8),
                    _buildFilterButton('Ditolak', 'rejected'),
                    const SizedBox(width: 8),
                    _buildFilterButton('Dibekukan', 'suspended'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Partners List
            if (filteredPartners.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.business_outlined,
                      size: 64,
                      color: AppColors.lightGreen,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Tidak ada mitra',
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
                itemCount: filteredPartners.length,
                itemBuilder: (context, index) {
                  final partner = filteredPartners[index];
                  return _buildPartnerCard(partner);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String label,
    String count,
    Color color,
    IconData icon,
  ) {
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
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.lightText),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, String status) {
    final isSelected = selectedStatus == status;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStatus = status;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildPartnerCard(Partner partner) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.lightGreen, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        partner.partnerName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        partner.ownerName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.lightText,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(partner.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getStatusColor(partner.status),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    partner.getStatusLabelShort(),
                    style: TextStyle(
                      color: _getStatusColor(partner.status),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Info Row 1
            Row(
              children: [
                const Icon(Icons.business, size: 14, color: AppColors.lightText),
                const SizedBox(width: 6),
                Text(
                  partner.getBusinessTypeLabel(),
                  style: const TextStyle(fontSize: 12, color: AppColors.lightText),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.location_on, size: 14, color: AppColors.lightText),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${partner.businessCity}, ${partner.businessProvince}',
                    style: const TextStyle(fontSize: 12, color: AppColors.lightText),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Info Row 2
            Row(
              children: [
                const Icon(Icons.phone, size: 14, color: AppColors.lightText),
                const SizedBox(width: 6),
                Text(
                  partner.phone,
                  style: const TextStyle(fontSize: 12, color: AppColors.lightText),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.email, size: 14, color: AppColors.lightText),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    partner.email,
                    style: const TextStyle(fontSize: 12, color: AppColors.lightText),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Info Row 3
            Row(
              children: [
                const Icon(Icons.attach_money, size: 14, color: AppColors.lightText),
                const SizedBox(width: 6),
                Text(
                  'Est. ${partner.getFormattedRevenue()}/bulan',
                  style: const TextStyle(fontSize: 12, color: AppColors.lightText),
                ),
                const SizedBox(width: 16),
                if (partner.rating > 0)
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${partner.rating.toStringAsFixed(1)}/5.0',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.lightText,
                        ),
                      ),
                    ],
                  )
                else
                  const Text(
                    'Belum ada rating',
                    style: TextStyle(fontSize: 12, color: AppColors.lightText),
                  ),
              ],
            ),
            if (partner.totalOrders > 0) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.shopping_cart,
                    size: 14,
                    color: AppColors.lightText,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${partner.totalOrders} order',
                    style: const TextStyle(fontSize: 12, color: AppColors.lightText),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 10),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  partner.getFormattedDate(),
                  style: const TextStyle(fontSize: 10, color: AppColors.lightText),
                ),
                Row(
                  children: [
                    if (partner.status == 'pending')
                      _buildActionButton('Setujui', Colors.green, () {
                        _showApprovalDialog(partner);
                      }),
                    if (partner.status == 'pending') const SizedBox(width: 8),
                    if (partner.status == 'pending')
                      _buildActionButton('Tolak', Colors.red, () {
                        _showRejectionDialog(partner);
                      }),
                    if (partner.status == 'active' ||
                        partner.status == 'approved')
                      _buildActionButton('Suspend', Colors.orange, () {
                        _suspendPartner(partner);
                      }),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.blue;
      case 'active':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'suspended':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  void _showApprovalDialog(Partner partner) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Setujui Mitra'),
            content: Text('Setujui permohonan mitra ${partner.partnerName}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  final updatedPartner = Partner(
                    id: partner.id,
                    partnerName: partner.partnerName,
                    ownerName: partner.ownerName,
                    email: partner.email,
                    phone: partner.phone,
                    businessType: partner.businessType,
                    businessAddress: partner.businessAddress,
                    businessCity: partner.businessCity,
                    businessProvince: partner.businessProvince,
                    businessPostalCode: partner.businessPostalCode,
                    businessRegistration: partner.businessRegistration,
                    taxId: partner.taxId,
                    estimatedMonthlyRevenue: partner.estimatedMonthlyRevenue,
                    bankName: partner.bankName,
                    bankAccountNumber: partner.bankAccountNumber,
                    bankAccountHolder: partner.bankAccountHolder,
                    status: 'approved',
                    rating: partner.rating,
                    totalOrders: partner.totalOrders,
                    createdAt: partner.createdAt,
                    approvedAt: DateTime.now(),
                    notes: partner.notes,
                  );
                  await _partnerService.updatePartner(updatedPartner);
                  await _loadPartners();
                },
                child: const Text('Setujui'),
              ),
            ],
          ),
    );
  }

  void _showRejectionDialog(Partner partner) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Tolak Mitra'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Tolak permohonan mitra ${partner.partnerName}?'),
                const SizedBox(height: 12),
                TextField(
                  controller: reasonController,
                  decoration: InputDecoration(
                    hintText: 'Alasan penolakan (opsional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  final updatedPartner = Partner(
                    id: partner.id,
                    partnerName: partner.partnerName,
                    ownerName: partner.ownerName,
                    email: partner.email,
                    phone: partner.phone,
                    businessType: partner.businessType,
                    businessAddress: partner.businessAddress,
                    businessCity: partner.businessCity,
                    businessProvince: partner.businessProvince,
                    businessPostalCode: partner.businessPostalCode,
                    businessRegistration: partner.businessRegistration,
                    taxId: partner.taxId,
                    estimatedMonthlyRevenue: partner.estimatedMonthlyRevenue,
                    bankName: partner.bankName,
                    bankAccountNumber: partner.bankAccountNumber,
                    bankAccountHolder: partner.bankAccountHolder,
                    status: 'rejected',
                    rating: partner.rating,
                    totalOrders: partner.totalOrders,
                    createdAt: partner.createdAt,
                    rejectedAt: DateTime.now(),
                    rejectionReason: reasonController.text,
                    notes: partner.notes,
                  );
                  await _partnerService.updatePartner(updatedPartner);
                  await _loadPartners();
                },
                child: const Text('Tolak'),
              ),
            ],
          ),
    );
  }

  void _suspendPartner(Partner partner) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Suspend Mitra'),
            content: Text('Suspend akun mitra ${partner.partnerName}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  final updatedPartner = Partner(
                    id: partner.id,
                    partnerName: partner.partnerName,
                    ownerName: partner.ownerName,
                    email: partner.email,
                    phone: partner.phone,
                    businessType: partner.businessType,
                    businessAddress: partner.businessAddress,
                    businessCity: partner.businessCity,
                    businessProvince: partner.businessProvince,
                    businessPostalCode: partner.businessPostalCode,
                    businessRegistration: partner.businessRegistration,
                    taxId: partner.taxId,
                    estimatedMonthlyRevenue: partner.estimatedMonthlyRevenue,
                    bankName: partner.bankName,
                    bankAccountNumber: partner.bankAccountNumber,
                    bankAccountHolder: partner.bankAccountHolder,
                    status: 'suspended',
                    rating: partner.rating,
                    totalOrders: partner.totalOrders,
                    createdAt: partner.createdAt,
                    approvedAt: partner.approvedAt,
                    notes: partner.notes,
                  );
                  await _partnerService.updatePartner(updatedPartner);
                  await _loadPartners();
                },
                child: const Text('Suspend'),
              ),
            ],
          ),
    );
  }
}
