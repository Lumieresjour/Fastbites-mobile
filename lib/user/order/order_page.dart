import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFFF5962),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Pesanan Saya",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Enhanced Tab Bar with improved animations
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: const Color(0xFFFF5962),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      indicatorSize: TabBarIndicatorSize
                          .tab, // Indikator mengikuti ukuran tab penuh
                      indicatorPadding: const EdgeInsets.all(
                          4), // Padding agar tidak menyentuh tepi
                      dividerColor: Colors
                          .transparent, // Hilangkan garis panjang di bawah
                      labelColor: Colors.white,
                      unselectedLabelColor: const Color(0xFFFF5962),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                      splashFactory:
                          NoSplash.splashFactory, // Hilangkan efek ripple
                      overlayColor: WidgetStateProperty.all(
                          Colors.transparent), // Hilangkan overlay
                      tabs: const [
                        Tab(text: "Aktif"),
                        Tab(text: "Selesai"),
                        Tab(text: "Dibatalkan"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildActiveOrders(),
                  _buildCompletedOrders(),
                  _buildCancelledOrders(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveOrders() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildOrderCard(
          orderNumber: "ORD-001",
          restaurantName: "Doughzen - Pakuwon Mall Bekasi",
          items: "1x Donat Coklat",
          status: "Sedang Disiapkan",
          statusColor: Colors.orange,
          price: "Rp 7.250",
          date: "Hari ini, 14:30",
          isActive: true,
        ),
        _buildOrderCard(
          orderNumber: "ORD-002",
          restaurantName: "Doughzen - Marga Mulya",
          items: "1x Donat Choco Chip",
          status: "Dalam Perjalanan",
          statusColor: Colors.blue,
          price: "Rp 7.250",
          date: "Hari ini, 15:45",
          isActive: true,
        ),
      ],
    );
  }

  Widget _buildCompletedOrders() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildOrderCard(
          orderNumber: "ORD-003",
          restaurantName: "Doughzen - Pakuwon Mall Bekasi",
          items: "1x Donat Oreo",
          status: "Selesai",
          statusColor: Colors.green,
          price: "Rp 7.250",
          date: "Kemarin, 19:20",
          isActive: false,
        ),
        _buildOrderCard(
          orderNumber: "ORD-004",
          restaurantName: "Doughzen - Pakuwon Mall Bekasi",
          items: "1x Donat Vanilla",
          status: "Selesai",
          statusColor: Colors.green,
          price: "Rp 7.250",
          date: "2 hari lalu, 18:15",
          isActive: false,
        ),
        _buildOrderCard(
          orderNumber: "ORD-005",
          restaurantName: "Doughzen - Pakuwon Mall Bekasi",
          items: "1x Donat Coklat Melt",
          status: "Selesai",
          statusColor: Colors.green,
          price: "Rp 7.250",
          date: "3 hari lalu, 12:30",
          isActive: false,
        ),
      ],
    );
  }

  Widget _buildCancelledOrders() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildOrderCard(
          orderNumber: "ORD-006",
          restaurantName: "Doughzen - Marga Mulya",
          items: "1x Donat Vanilla",
          status: "Dibatalkan",
          statusColor: Colors.red,
          price: "Rp 7.250",
          date: "1 minggu lalu, 20:00",
          isActive: false,
        ),
        Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Icon(
                Icons.cancel_outlined,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 20),
              Text(
                "Tidak ada pesanan lain yang dibatalkan",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard({
    required String orderNumber,
    required String restaurantName,
    required String items,
    required String status,
    required Color statusColor,
    required String price,
    required String date,
    required bool isActive,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  orderNumber,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF5962),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Restaurant Name
            Text(
              restaurantName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 8),

            // Items
            Text(
              items,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 12),

            // Price and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF5962),
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),

            if (isActive) ...[
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _showCancelDialog(context, orderNumber);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        foregroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Batalkan"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showTrackingDialog(context, orderNumber);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5962),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Lacak Pesanan"),
                    ),
                  ),
                ],
              ),
            ] else if (!isActive && status == "Selesai") ...[
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _showReorderDialog(context, restaurantName);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFF5962)),
                        foregroundColor: const Color(0xFFFF5962),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Pesan Lagi"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showReviewDialog(context, restaurantName);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5962),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Beri Ulasan"),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, String orderNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Batalkan Pesanan",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content:
              Text("Apakah Anda yakin ingin membatalkan pesanan $orderNumber?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Tidak", style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("Pesanan $orderNumber telah dibatalkan")),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child:
                  const Text("Ya, Batalkan", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showTrackingDialog(BuildContext context, String orderNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Lacak Pesanan",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Status pesanan $orderNumber:"),
              const SizedBox(height: 20),
              _buildTrackingStep("Pesanan Diterima", true),
              _buildTrackingStep("Sedang Disiapkan", true),
              _buildTrackingStep("Siap Diantar", false),
              _buildTrackingStep("Dalam Perjalanan", false),
              _buildTrackingStep("Sampai Tujuan", false),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style:
                  ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5962)),
              child: const Text("Tutup", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTrackingStep(String title, bool isCompleted) {
    return Row(
      children: [
        Icon(
          isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isCompleted ? Colors.green : Colors.grey,
          size: 20,
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            color: isCompleted ? Colors.green : Colors.grey,
            fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  void _showReorderDialog(BuildContext context, String restaurantName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title:
              const Text("Pesan Lagi", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text("Ingin memesan lagi dari $restaurantName?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Batal", style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Mengarahkan ke $restaurantName...")),
                );
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5962)),
              child: const Text("Ya, Pesan", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showReviewDialog(BuildContext context, String restaurantName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Beri Ulasan",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Bagaimana pengalaman Anda dengan $restaurantName?"),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return const Icon(
                    Icons.star_border,
                    color: Color(0xFFFF5962),
                    size: 30,
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Batal", style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Terima kasih atas ulasan Anda!")),
                );
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5962)),
              child: const Text("Kirim", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
