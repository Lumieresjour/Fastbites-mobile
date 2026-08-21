import 'package:flutter/material.dart';
import '../../models/order.dart';
import '../../services/order_service.dart';
import '../../utils/app_colors.dart';

class ShippingScreen extends StatefulWidget {
  const ShippingScreen({super.key});

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  List<Order> orders = [];
  String selectedTab =
      'all'; // 'all', 'pending', 'processing', 'shipped', 'delivered', 'cancelled'
  final OrderService _orderService = OrderService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    try {
      final loadedOrders = await _orderService.getAllOrders();
      if (loadedOrders.isEmpty) {
        await _seedSampleOrders();
        final seededOrders = await _orderService.getAllOrders();
        setState(() {
          orders = seededOrders;
          _isLoading = false;
        });
      } else {
        setState(() {
          orders = loadedOrders;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading orders: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _seedSampleOrders() async {
    final sampleOrders = [
      Order(
        id: 1,
        orderNumber: 'ORD-2023-001',
        buyerName: 'Budi Santoso',
        buyerPhone: '081234567890',
        buyerEmail: 'budi@email.com',
        totalAmount: 250000,
        paymentStatus: 'paid',
        orderStatus: 'delivered',
        shippingMethod: 'express',
        shippingAddress: 'Jl. Merdeka No. 123',
        shippingCity: 'Jakarta',
        shippingProvince: 'DKI Jakarta',
        shippingPostalCode: '12000',
        courierName: 'JNE',
        trackingNumber: 'JNE123456789',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        paidAt: DateTime.now().subtract(const Duration(days: 14)),
        shippedAt: DateTime.now().subtract(const Duration(days: 12)),
        deliveredAt: DateTime.now().subtract(const Duration(days: 10)),
        notes: 'Pengiriman lancar',
      ),
      Order(
        id: 2,
        orderNumber: 'ORD-2023-002',
        buyerName: 'Siti Nurhaliza',
        buyerPhone: '082345678901',
        buyerEmail: 'siti@email.com',
        totalAmount: 450000,
        paymentStatus: 'paid',
        orderStatus: 'shipped',
        shippingMethod: 'regular',
        shippingAddress: 'Jl. Sudirman No. 456',
        shippingCity: 'Bandung',
        shippingProvince: 'Jawa Barat',
        shippingPostalCode: '40123',
        courierName: 'Gojek',
        trackingNumber: 'GOJEK-2023-789',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        paidAt: DateTime.now().subtract(const Duration(days: 4)),
        shippedAt: DateTime.now().subtract(const Duration(days: 2)),
        notes: 'Dalam perjalanan',
      ),
    ];
    for (final order in sampleOrders) {
      await _orderService.createOrder(order);
    }
  }

  List<Order> _getFilteredOrders() {
    if (selectedTab == 'all') {
      return orders;
    }
    return orders.where((o) => o.orderStatus == selectedTab).toList();
  }

  int _getPendingCount() =>
      orders.where((o) => o.orderStatus == 'pending').length;
  int _getProcessingCount() =>
      orders.where((o) => o.orderStatus == 'processing').length;
  int _getShippedCount() =>
      orders.where((o) => o.orderStatus == 'shipped').length;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Order & Pengiriman',
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

    final filteredOrders = _getFilteredOrders();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Order & Pengiriman',
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
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSummaryCard(
                    'Pending',
                    _getPendingCount().toString(),
                    Colors.orange,
                    Icons.hourglass_empty,
                  ),
                  _buildSummaryCard(
                    'Diproses',
                    _getProcessingCount().toString(),
                    Colors.blue,
                    Icons.settings,
                  ),
                  _buildSummaryCard(
                    'Dikirim',
                    _getShippedCount().toString(),
                    AppColors.primaryGreen,
                    Icons.local_shipping,
                  ),
                ],
              ),
            ),

            // Filter Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTabButton('Semua', 'all'),
                    _buildTabButton('Pending', 'pending'),
                    _buildTabButton('Diproses', 'processing'),
                    _buildTabButton('Dikirim', 'shipped'),
                    _buildTabButton('Tiba', 'delivered'),
                    _buildTabButton('Batal', 'cancelled'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Orders List
            if (filteredOrders.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 64,
                      color: AppColors.lightGreen,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Tidak ada pesanan',
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
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  return _buildOrderCard(order);
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
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.lightText),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, String status) {
    final isSelected = selectedTab == status;
    return GestureDetector(
      onTap: () {
        setState(() => selectedTab = status);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
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

  Widget _buildOrderCard(Order order) {
    final statusColor = _getStatusColor(order.orderStatus);
    final paymentColor =
        order.paymentStatus == 'paid' ? AppColors.success : Colors.orange;

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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.orderNumber,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkText,
                          ),
                        ),
                        Text(
                          order.getFormattedDate(),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.lightText,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        order.getOrderStatusLabel(),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Divider
                Container(height: 1, color: Colors.grey[100]),
                const SizedBox(height: 10),

                // Buyer Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pembeli',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.lightText,
                            ),
                          ),
                          Text(
                            order.buyerName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkText,
                            ),
                          ),
                          Text(
                            order.buyerPhone,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.lightText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.lightText,
                          ),
                        ),
                        Text(
                          order.getFormattedAmount(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: paymentColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            order.getPaymentStatusLabel(),
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: paymentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Divider
                Container(height: 1, color: Colors.grey[100]),
                const SizedBox(height: 10),

                // Shipping Info
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: AppColors.primaryGreen,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${order.shippingAddress}, ${order.shippingCity}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.darkText,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${order.shippingProvince} ${order.shippingPostalCode}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.lightText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                if (order.courierName != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.local_shipping_outlined,
                        size: 16,
                        color: AppColors.primaryGreen,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.courierName!,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkText,
                              ),
                            ),
                            Text(
                              'No. Resi: ${order.trackingNumber}',
                              style: const TextStyle(
                                fontSize: 9,
                                color: AppColors.lightText,
                                fontFamily: 'Courier',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],

                // Action Buttons
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (order.orderStatus == 'pending')
                      TextButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Pesanan ${order.orderNumber} dikonfirmasi',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.check, size: 14),
                        label: const Text('Konfirmasi'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primaryGreen,
                        ),
                      ),
                    if (order.orderStatus == 'processing')
                      TextButton.icon(
                        onPressed: () {
                          _showShippingDialog(order);
                        },
                        icon: const Icon(
                          Icons.local_shipping_outlined,
                          size: 14,
                        ),
                        label: const Text('Kirim'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primaryGreen,
                        ),
                      ),
                    // Red 'Batal' button removed per request
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showShippingDialog(Order order) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Input Resi Pengiriman'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Kurir',
                    hintText: 'JNE, Gojek, Grab, dll',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Nomor Resi',
                    hintText: 'Masukkan nomor resi pengiriman',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                    SnackBar(
                      content: Text('Pesanan ${order.orderNumber} dikirim'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                ),
                child: const Text('Konfirmasi Pengiriman'),
              ),
            ],
          ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return AppColors.primaryGreen;
      case 'delivered':
        return AppColors.success;
      case 'cancelled':
      case 'returned':
        return AppColors.error;
      default:
        return Colors.grey;
    }
  }
}
