import 'package:flutter/material.dart';
import '../../models/promo.dart';
import '../../services/promo_service.dart';
import '../../utils/app_colors.dart';

class PromoScreen extends StatefulWidget {
  const PromoScreen({super.key});

  @override
  State<PromoScreen> createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen> {
  List<Promo> promos = [];
  String selectedFilter = 'all'; // 'all', 'active', 'upcoming', 'expired'
  final PromoService _promoService = PromoService();

  @override
  void initState() {
    super.initState();
    _loadPromosFromDb();
  }

  Future<void> _loadPromosFromDb() async {
    final dbPromos = await _promoService.getAllPromos();
    if (dbPromos.isEmpty) {
      await _seedPromosIfEmpty();
    }
    final reloaded = await _promoService.getAllPromos();
    setState(() {
      promos = reloaded;
    });
  }

  Future<void> _seedPromosIfEmpty() async {
    final now = DateTime.now();
    // one upcoming promo (startDate in future)
    final upcoming = Promo(
      title: 'Kupon Mendatang: Summer Sale',
      description: 'Diskon spesial untuk musim panas, aktif mulai minggu depan',
      code: 'SUMMER25',
      discountPercent: 25,
      discountAmount: 0,
      minPurchase: 30000,
      startDate: now.add(const Duration(days: 7)),
      endDate: now.add(const Duration(days: 21)),
      category: 'all',
      usageLimit: 200,
      usedCount: 0,
      isActive: true,
    );

    // one expired promo (endDate in past)
    final expired = Promo(
      title: 'Kupon Berakhir: Spring Promo',
      description: 'Promo musim semi yang sudah berakhir',
      code: 'SPRING10',
      discountPercent: 10,
      discountAmount: 0,
      minPurchase: 20000,
      startDate: now.subtract(const Duration(days: 30)),
      endDate: now.subtract(const Duration(days: 1)),
      category: 'all',
      usageLimit: 100,
      usedCount: 100,
      isActive: false,
    );

    await _promoService.createPromo(upcoming);
    await _promoService.createPromo(expired);
  }

  List<Promo> _getFilteredPromos() {
    if (selectedFilter == 'all') {
      return promos;
    } else if (selectedFilter == 'active') {
      return promos.where((p) => p.getStatus() == 'Aktif').toList();
    } else if (selectedFilter == 'upcoming') {
      return promos.where((p) => p.getStatus() == 'Belum dimulai').toList();
    } else if (selectedFilter == 'expired') {
      return promos
          .where((p) => p.getStatus() == 'Berakhir' || p.getStatus() == 'Habis')
          .toList();
    }
    return promos;
  }

  @override
  Widget build(BuildContext context) {
    final filteredPromos = _getFilteredPromos();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Promosi & Kupon',
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
      body: Column(
        children: [
          // Category Filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton('Semua', 'all'),
                _buildFilterButton('Aktif', 'active'),
                _buildFilterButton('Mendatang', 'upcoming'),
                _buildFilterButton('Berakhir', 'expired'),
              ],
            ),
          ),
          // Promos List
          Expanded(
            child:
                filteredPromos.isEmpty
                    ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_offer_outlined,
                            size: 64,
                            color: AppColors.lightGreen,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Belum ada promosi',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.lightText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                    : SingleChildScrollView(
                      child: Column(
                        children: [
                          ...filteredPromos.map((promo) {
                            return _buildPromoCard(promo);
                          }),
                        ],
                      ),
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryGreen,
        onPressed: () => _showPromoForm(),
        child: const Icon(Icons.add),
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

  Widget _buildPromoCard(Promo promo) {
    final statusColor = _getStatusColor(promo.getStatus());

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
            // Title & Status Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        promo.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        promo.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.lightText,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    promo.getStatus(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Discount & Code
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.lightGreen,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hemat hingga',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.lightText,
                        ),
                      ),
                      Text(
                        promo.getDiscountText(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.primaryGreen,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      promo.code,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Usage Progress & Remaining Days
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Penggunaan',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.lightText,
                            ),
                          ),
                          Text(
                            '${promo.usedCount}/${promo.usageLimit}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value:
                              promo.usageLimit > 0
                                  ? promo.usedCount / promo.usageLimit
                                  : 0,
                          minHeight: 6,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            promo.getUsagePercentage() > 80
                                ? AppColors.error
                                : AppColors.primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    promo.getRemainingDays(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Action Buttons for Admin
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => _showPromoForm(promo: promo),
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: const Text('Edit'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primaryGreen,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                      const SizedBox(width: 4),
                      TextButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Hapus Promosi'),
                                  content: Text(
                                    'Hapus promosi "${promo.code}"?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        if (promo.id != null) {
                                          await _promoService.deletePromo(
                                            promo.id!,
                                          );
                                        }
                                        await _loadPromosFromDb();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Promosi "${promo.code}" dihapus',
                                            ),
                                            duration: const Duration(
                                              seconds: 2,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Hapus',
                                        style: TextStyle(
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          );
                        },
                        icon: const Icon(Icons.delete_outline, size: 16),
                        label: const Text('Hapus'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.error,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Aktif':
        return AppColors.success;
      case 'Berakhir':
      case 'Habis':
        return AppColors.error;
      case 'Nonaktif':
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  Future<void> _showPromoForm({Promo? promo}) async {
    final isEditing = promo != null;
    final titleController = TextEditingController(text: promo?.title ?? '');
    final descriptionController = TextEditingController(
      text: promo?.description ?? '',
    );
    final codeController = TextEditingController(text: promo?.code ?? '');
    final discountPercentController = TextEditingController(
      text: (promo?.discountPercent ?? 0).toString(),
    );
    final discountAmountController = TextEditingController(
      text: (promo?.discountAmount ?? 0).toString(),
    );
    final minPurchaseController = TextEditingController(
      text: (promo?.minPurchase ?? 0).toString(),
    );
    final usageLimitController = TextEditingController(
      text: (promo?.usageLimit ?? 0).toString(),
    );
    DateTime startDate = promo?.startDate ?? DateTime.now();
    DateTime endDate =
        promo?.endDate ?? DateTime.now().add(const Duration(days: 7));
    bool isActive = promo?.isActive ?? true;

    await showDialog<void>(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              Future<void> pickStart() async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: startDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => startDate = picked);
              }

              Future<void> pickEnd() async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: endDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => endDate = picked);
              }

              return AlertDialog(
                title: Text(isEditing ? 'Edit Promosi' : 'Tambah Promosi'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Judul'),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: codeController,
                        decoration: const InputDecoration(labelText: 'Kode'),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: discountPercentController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Diskon %',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: discountAmountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Diskon Rp',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: minPurchaseController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Minimal Pembelian',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: pickStart,
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Mulai',
                                ),
                                child: Text(
                                  startDate.toLocal().toIso8601String().split('T').first,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InkWell(
                              onTap: pickEnd,
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Selesai',
                                ),
                                child: Text(
                                  endDate.toLocal().toIso8601String().split('T').first,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: usageLimitController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Limit Penggunaan',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text('Aktif'),
                          const SizedBox(width: 8),
                          Switch(
                            value: isActive,
                            onChanged: (v) => setState(() => isActive = v),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final title = titleController.text.trim();
                      final description = descriptionController.text.trim();
                      final code = codeController.text.trim();
                      final discountPercent =
                          double.tryParse(discountPercentController.text) ??
                          0.0;
                      final discountAmount =
                          double.tryParse(discountAmountController.text) ?? 0.0;
                      final minPurchase =
                          double.tryParse(minPurchaseController.text) ?? 0.0;
                      final usageLimit =
                          int.tryParse(usageLimitController.text) ?? 0;

                      final newPromo = Promo(
                        id: promo?.id,
                        title: title,
                        description: description,
                        code: code,
                        discountPercent: discountPercent,
                        discountAmount: discountAmount,
                        minPurchase: minPurchase,
                        startDate: startDate,
                        endDate: endDate,
                        category: promo?.category ?? 'all',
                        usageLimit: usageLimit,
                        usedCount: promo?.usedCount ?? 0,
                        isActive: isActive,
                      );

                      Navigator.pop(context);
                      if (isEditing) {
                        try {
                          await _promoService.updatePromo(newPromo);
                          await _loadPromosFromDb();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Promosi "${newPromo.code}" diperbarui',
                              ),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Gagal memperbarui promosi: $e'),
                            ),
                          );
                        }
                      } else {
                        try {
                          await _promoService.createPromo(newPromo);
                          await _loadPromosFromDb();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Promosi "${newPromo.code}" dibuat',
                              ),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Gagal membuat promosi: $e'),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                    ),
                    child: Text(isEditing ? 'Simpan' : 'Buat'),
                  ),
                ],
              );
            },
          ),
    );
  }
}
