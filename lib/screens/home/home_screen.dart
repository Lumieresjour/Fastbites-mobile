import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../models/store.dart';
import '../../services/database_service.dart';
import '../auth/login_screen.dart';
import '../products/product_list_screen.dart';
import '../store/profile_screen.dart';
import '../settings/settings_screen.dart';
import '../analytics/analytics_screen.dart';
import '../reviews/review_screen.dart';
import '../admin/admin_dashboard.dart';
import '../orders/shipping_screen.dart';
import '../payments/payment_screen.dart';
import '../payments/commission_screen.dart';
import '../promotions/promo_screen.dart';
import '../partners/partner_screen.dart';

// Clean HomeScreen implementation

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Store? _store;
  bool _storeLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStore();
  }

  Future<void> _loadStore() async {
    try {
      final store = await DatabaseService().getStore();
      setState(() {
        _store = store;
        _storeLoading = false;
      });
    } catch (_) {
      setState(() => _storeLoading = false);
    }
  }

  Widget _buildSummaryRow(String title, String value) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: AppColors.lightText)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    final sidebarItems = [
      {
        'icon': Icons.dashboard,
        'title': 'Dashboard Admin',
        'subtitle': 'Overview & laporan',
      },
      {
        'icon': Icons.storefront,
        'title': 'Manajemen Toko',
        'subtitle': 'Profil & pengaturan toko',
      },
      {
        'icon': Icons.production_quantity_limits,
        'title': 'Manajemen Produk',
        'subtitle': 'Tambah / ubah produk',
      },
      {
        'icon': Icons.shopping_cart,
        'title': 'Order & Pengiriman',
        'subtitle': 'Kelola pesanan',
      },
      {
        'icon': Icons.payment,
        'title': 'Pembayaran & Komisi',
        'subtitle': 'Transaksi & komisi',
      },
      {
        'icon': Icons.local_offer,
        'title': 'Promosi & Kupon',
        'subtitle': 'Kelola promosi',
      },
      {
        'icon': Icons.rate_review,
        'title': 'Ulasan & Kualitas',
        'subtitle': 'Review pelanggan',
      },
      {
        'icon': Icons.bar_chart,
        'title': 'Analytics & Laporan',
        'subtitle': 'Statistik penjualan',
      },
      {
        'icon': Icons.people,
        'title': 'Manajemen Mitra',
        'subtitle': 'Kelola mitra',
      },
      {
        'icon': Icons.settings,
        'title': 'Pengaturan Platform',
        'subtitle': 'Pengaturan & hak akses',
      },
    ];

    final mainContent = SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat datang Kembali, Admin',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Ringkasan singkat profil dan statistik utama toko Anda',
            style: TextStyle(fontSize: 13, color: AppColors.lightText),
          ),
          const SizedBox(height: 12),

          const SizedBox(height: 12),

          // Admin Card
          Card(
            color: AppColors.cardBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 2,
            child: const ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.lightGreen,
                child: Icon(
                  Icons.person,
                  color: AppColors.primaryGreen,
                  size: 30,
                ),
              ),
              title: Text(
                'Admin',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                'admin@admin.com',
                style: TextStyle(color: AppColors.lightText),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Store Card
          _storeLoading
              ? Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 1,
                child: const Padding(
                  padding: EdgeInsets.all(14.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              )
              : Card(
                color: AppColors.cardBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.lightGreen,
                          child: Icon(
                            Icons.storefront,
                            color: AppColors.primaryGreen,
                            size: 28,
                          ),
                        ),
                        title: Text(
                          _store?.name ?? 'DonatLicious',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          _store?.category ?? 'Makanan dan Minuman',
                          style: const TextStyle(color: AppColors.lightText),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppColors.lightText,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _store?.location ??
                                  'Jl.Cut Mutia No 19, Kota Bekasi',
                              style: const TextStyle(
                                color: AppColors.darkText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: AppColors.lightText,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _store?.openingHours ?? '08:00-21:00 WIB',
                              style: const TextStyle(
                                color: AppColors.darkText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

          const SizedBox(height: 18),

          // Statistics grid
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxis = constraints.maxWidth > 700 ? 3 : 2;
              return GridView.count(
                crossAxisCount: crossAxis,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.05,
                children: const [
                  _SmallStat(
                    title: 'Mitra',
                    value: '58',
                    icon: Icons.people,
                    color: AppColors.primaryGreen,
                  ),
                  _SmallStat(
                    title: 'Produk',
                    value: '1.240',
                    icon: Icons.inventory_2,
                    color: Colors.indigo,
                  ),
                  _SmallStat(
                    title: 'Order',
                    value: '3.456',
                    icon: Icons.local_shipping,
                    color: Colors.orange,
                  ),
                  _SmallStat(
                    title: 'Pembayaran',
                    value: 'Rp 128jt',
                    icon: Icons.account_balance_wallet,
                    color: Colors.teal,
                  ),
                  _SmallStat(
                    title: 'Promosi',
                    value: '26',
                    icon: Icons.local_offer,
                    color: Colors.purple,
                  ),
                  _SmallStat(
                    title: 'Ulasan',
                    value: '4.7/5',
                    icon: Icons.rate_review,
                    color: Colors.amber,
                  ),
                  _SmallStat(
                    title: 'Analytics',
                    value: 'Rp 7,5jt Penjualan',
                    icon: Icons.bar_chart,
                    color: Colors.blue,
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 18),

          // Vertical sales summary (white background cards)
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ringkasan Penjualan',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Hari Ini', 'Rp 3.250.000'),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Minggu Ini', 'Rp 21.450.000'),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Bulan Ini', 'Rp 128.000.000'),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Transaksi', '3.456'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Recent activity (simple placeholder)
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 1,
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aktivitas Terbaru',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '� 3 pesanan baru\n� 1 pembayaran masuk\n� 2 promo aktif',
                    style: TextStyle(color: AppColors.lightText),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 28),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: AppColors.primaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        elevation: 4,
      ),
      drawer:
          isWide
              ? null
              : Drawer(child: _buildSidebarContent(context, sidebarItems)),
      body:
          isWide
              ? Row(
                children: [
                  Container(
                    width: 280,
                    color: AppColors.primaryGreen,
                    child: _buildSidebarContent(context, sidebarItems),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: mainContent),
                ],
              )
              : mainContent,
      // FloatingActionButton removed per request
    );
  }
}

// Sidebar content builder used both for Drawer (mobile) and permanent sidebar (wide)
Widget _buildSidebarContent(
  BuildContext context,
  List<Map<String, dynamic>> items,
) {
  return SafeArea(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          color: AppColors.primaryGreen,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text('admin@admin.com', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(8.0),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 4),
            itemBuilder: (context, index) {
              final it = items[index];
              return ListTile(
                leading: Icon(it['icon'], color: AppColors.primaryGreen),
                title: Text(
                  it['title'],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  it['subtitle'] ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.lightText,
                  ),
                ),
                onTap: () {
                  if (it['title'] == 'Dashboard Admin') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AdminDashboardScreen(),
                      ),
                    );
                    return;
                  }

                  if (it['title'] == 'Manajemen Produk') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ProductListScreen(),
                      ),
                    );
                  } else if (it['title'] == 'Manajemen Toko') {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  } else if (it['title'] == 'Order & Pengiriman') {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ShippingScreen()),
                    );
                  } else if (it['title'] == 'Pembayaran & Komisi') {
                    _showPaymentCommissionMenu(context);
                  } else if (it['title'] == 'Promosi & Kupon') {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PromoScreen()),
                    );
                  } else if (it['title'] == 'Ulasan & Kualitas') {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ReviewScreen()),
                    );
                  } else if (it['title'] == 'Manajemen Mitra') {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PartnerScreen()),
                    );
                  } else if (it['title'] == 'Pengaturan Platform') {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  } else if (it['title'] == 'Analytics & Laporan') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AnalyticsScreen(),
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ComingSoonScreen(title: it['title']),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFFFF5962)),
            title: const Text(
              'Keluar',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ),
        const SizedBox(height: 12),
      ],
    ),
  );
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text(
          "Logout",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        content: const Text(
          "Apakah Anda yakin ingin keluar dari akun admin?",
          style: TextStyle(color: Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text(
              "Batal",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5962),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Logout"),
          ),
        ],
      );
    },
  );
}

void _showPaymentCommissionMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder:
        (ctx) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pembayaran & Komisi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(
                  Icons.payment,
                  color: AppColors.primaryGreen,
                ),
                title: const Text('Pencairan Dana & Pembayaran'),
                subtitle: const Text('Kelola transaksi dan pencairan dana'),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PaymentScreen()),
                  );
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(
                  Icons.card_giftcard,
                  color: AppColors.primaryGreen,
                ),
                title: const Text('Komisi & Bonus'),
                subtitle: const Text('Lihat komisi penjualan dan bonus'),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CommissionScreen()),
                  );
                },
              ),
            ],
          ),
        ),
  );
}

class ComingSoonScreen extends StatelessWidget {
  final String title;
  const ComingSoonScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.construction, size: 72, color: AppColors.lightGreen),
            const SizedBox(height: 16),
            Text(
              '$title - Segera hadir',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Halaman ini masih dikosongkan dan akan diisi nanti.'),
          ],
        ),
      ),
    );
  }
}

class _SmallStat extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SmallStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 18.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Icon(icon, color: color, size: 28)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
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
}
