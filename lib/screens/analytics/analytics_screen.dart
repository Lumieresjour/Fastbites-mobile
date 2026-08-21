import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/sales.dart';
import '../../models/product.dart';
import '../../services/database_service.dart';
import '../../utils/app_colors.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool _loading = true;
  double _totalSales = 0.0;
  int _totalQuantity = 0;
  List<Product> _products = [];
  List<Sales> _recentSales = [];
  final Map<String, int> _productQuantities = {};
  final Map<String, double> _productRevenue = {};

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() => _loading = true);
    try {
      final db = DatabaseService();

      // Get total sales and quantity
      _totalSales = await db.getTotalSalesAmount();
      _totalQuantity = await db.getTotalQuantitySold();

      // If no sales data, use sample data
      if (_totalSales == 0 || _recentSales.isEmpty) {
        // Generate sample data in-memory
        _generateSampleData();
      } else {
        // Get recent sales
        _recentSales = await db.getAllSales();

        // Get product performance
        final performance = await db.getProductPerformance();
        final productsList = (performance['products'] as List);
        for (var item in productsList) {
          _productQuantities[item['product_name'] ?? 'Unknown'] =
              (item['total_quantity'] as num?)?.toInt() ?? 0;
          _productRevenue[item['product_name'] ?? 'Unknown'] =
              ((item['revenue'] as num?)?.toDouble() ?? 0.0);
        }
      }

      // Get products
      _products = await db.getAllProducts();

      setState(() => _loading = false);
    } catch (e) {
      debugPrint('Error loading analytics: $e');
      setState(() => _loading = false);
    }
  }

  void _generateSampleData() {
    // Generate sample sales data for demonstration
    final sampleSales = [
      // Donat Coklat
      Sales(
        productId: 1,
        productName: 'Donat Coklat',
        quantity: 5,
        totalPrice: 75000,
        soldAt: DateTime.now().subtract(const Duration(days: 6)),
      ),
      Sales(
        productId: 1,
        productName: 'Donat Coklat',
        quantity: 8,
        totalPrice: 120000,
        soldAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Sales(
        productId: 1,
        productName: 'Donat Coklat',
        quantity: 7,
        totalPrice: 105000,
        soldAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
      Sales(
        productId: 1,
        productName: 'Donat Coklat',
        quantity: 12,
        totalPrice: 180000,
        soldAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Sales(
        productId: 1,
        productName: 'Donat Coklat',
        quantity: 9,
        totalPrice: 135000,
        soldAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Sales(
        productId: 1,
        productName: 'Donat Coklat',
        quantity: 15,
        totalPrice: 225000,
        soldAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Sales(
        productId: 1,
        productName: 'Donat Coklat',
        quantity: 11,
        totalPrice: 165000,
        soldAt: DateTime.now(),
      ),
      // Donat Vanila
      Sales(
        productId: 2,
        productName: 'Donat Vanila',
        quantity: 3,
        totalPrice: 45000,
        soldAt: DateTime.now().subtract(const Duration(days: 6)),
      ),
      Sales(
        productId: 2,
        productName: 'Donat Vanila',
        quantity: 6,
        totalPrice: 90000,
        soldAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Sales(
        productId: 2,
        productName: 'Donat Vanila',
        quantity: 5,
        totalPrice: 75000,
        soldAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
      Sales(
        productId: 2,
        productName: 'Donat Vanila',
        quantity: 9,
        totalPrice: 135000,
        soldAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Sales(
        productId: 2,
        productName: 'Donat Vanila',
        quantity: 4,
        totalPrice: 60000,
        soldAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Sales(
        productId: 2,
        productName: 'Donat Vanila',
        quantity: 7,
        totalPrice: 105000,
        soldAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Sales(
        productId: 2,
        productName: 'Donat Vanila',
        quantity: 8,
        totalPrice: 120000,
        soldAt: DateTime.now(),
      ),
      // Donat Polos
      Sales(
        productId: 3,
        productName: 'Donat Polos',
        quantity: 10,
        totalPrice: 100000,
        soldAt: DateTime.now().subtract(const Duration(days: 6)),
      ),
      Sales(
        productId: 3,
        productName: 'Donat Polos',
        quantity: 14,
        totalPrice: 140000,
        soldAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Sales(
        productId: 3,
        productName: 'Donat Polos',
        quantity: 18,
        totalPrice: 180000,
        soldAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
      Sales(
        productId: 3,
        productName: 'Donat Polos',
        quantity: 12,
        totalPrice: 120000,
        soldAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Sales(
        productId: 3,
        productName: 'Donat Polos',
        quantity: 16,
        totalPrice: 160000,
        soldAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Sales(
        productId: 3,
        productName: 'Donat Polos',
        quantity: 13,
        totalPrice: 130000,
        soldAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Sales(
        productId: 3,
        productName: 'Donat Polos',
        quantity: 11,
        totalPrice: 110000,
        soldAt: DateTime.now(),
      ),
      // Donat Oreo
      Sales(
        productId: 4,
        productName: 'Donat Oreo',
        quantity: 6,
        totalPrice: 120000,
        soldAt: DateTime.now().subtract(const Duration(days: 6)),
      ),
      Sales(
        productId: 4,
        productName: 'Donat Oreo',
        quantity: 8,
        totalPrice: 160000,
        soldAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Sales(
        productId: 4,
        productName: 'Donat Oreo',
        quantity: 11,
        totalPrice: 220000,
        soldAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
      Sales(
        productId: 4,
        productName: 'Donat Oreo',
        quantity: 7,
        totalPrice: 140000,
        soldAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Sales(
        productId: 4,
        productName: 'Donat Oreo',
        quantity: 9,
        totalPrice: 180000,
        soldAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Sales(
        productId: 4,
        productName: 'Donat Oreo',
        quantity: 10,
        totalPrice: 200000,
        soldAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Sales(
        productId: 4,
        productName: 'Donat Oreo',
        quantity: 6,
        totalPrice: 120000,
        soldAt: DateTime.now(),
      ),
      // Kopi Espresso
      Sales(
        productId: 5,
        productName: 'Kopi Espresso',
        quantity: 12,
        totalPrice: 144000,
        soldAt: DateTime.now().subtract(const Duration(days: 6)),
      ),
      Sales(
        productId: 5,
        productName: 'Kopi Espresso',
        quantity: 15,
        totalPrice: 180000,
        soldAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Sales(
        productId: 5,
        productName: 'Kopi Espresso',
        quantity: 14,
        totalPrice: 168000,
        soldAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
      Sales(
        productId: 5,
        productName: 'Kopi Espresso',
        quantity: 18,
        totalPrice: 216000,
        soldAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Sales(
        productId: 5,
        productName: 'Kopi Espresso',
        quantity: 13,
        totalPrice: 156000,
        soldAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Sales(
        productId: 5,
        productName: 'Kopi Espresso',
        quantity: 16,
        totalPrice: 192000,
        soldAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Sales(
        productId: 5,
        productName: 'Kopi Espresso',
        quantity: 17,
        totalPrice: 204000,
        soldAt: DateTime.now(),
      ),
      // Kopi Latte
      Sales(
        productId: 6,
        productName: 'Kopi Latte',
        quantity: 10,
        totalPrice: 150000,
        soldAt: DateTime.now().subtract(const Duration(days: 6)),
      ),
      Sales(
        productId: 6,
        productName: 'Kopi Latte',
        quantity: 15,
        totalPrice: 225000,
        soldAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Sales(
        productId: 6,
        productName: 'Kopi Latte',
        quantity: 12,
        totalPrice: 180000,
        soldAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
      Sales(
        productId: 6,
        productName: 'Kopi Latte',
        quantity: 14,
        totalPrice: 210000,
        soldAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Sales(
        productId: 6,
        productName: 'Kopi Latte',
        quantity: 11,
        totalPrice: 165000,
        soldAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Sales(
        productId: 6,
        productName: 'Kopi Latte',
        quantity: 13,
        totalPrice: 195000,
        soldAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Sales(
        productId: 6,
        productName: 'Kopi Latte',
        quantity: 10,
        totalPrice: 150000,
        soldAt: DateTime.now(),
      ),
      // Kopi Cappuccino
      Sales(
        productId: 7,
        productName: 'Kopi Cappuccino',
        quantity: 8,
        totalPrice: 136000,
        soldAt: DateTime.now().subtract(const Duration(days: 6)),
      ),
      Sales(
        productId: 7,
        productName: 'Kopi Cappuccino',
        quantity: 13,
        totalPrice: 221000,
        soldAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Sales(
        productId: 7,
        productName: 'Kopi Cappuccino',
        quantity: 10,
        totalPrice: 170000,
        soldAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
      Sales(
        productId: 7,
        productName: 'Kopi Cappuccino',
        quantity: 12,
        totalPrice: 204000,
        soldAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Sales(
        productId: 7,
        productName: 'Kopi Cappuccino',
        quantity: 9,
        totalPrice: 153000,
        soldAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Sales(
        productId: 7,
        productName: 'Kopi Cappuccino',
        quantity: 11,
        totalPrice: 187000,
        soldAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Sales(
        productId: 7,
        productName: 'Kopi Cappuccino',
        quantity: 13,
        totalPrice: 221000,
        soldAt: DateTime.now(),
      ),
    ];

    _recentSales = sampleSales;

    // Calculate totals
    _totalSales = sampleSales.fold(0.0, (sum, sale) => sum + sale.totalPrice);
    _totalQuantity = sampleSales.fold(0, (sum, sale) => sum + sale.quantity);

    // Calculate product performance
    Map<String, int> quantities = {};
    Map<String, double> revenues = {};
    for (var sale in sampleSales) {
      quantities[sale.productName] =
          (quantities[sale.productName] ?? 0) + sale.quantity;
      revenues[sale.productName] =
          (revenues[sale.productName] ?? 0.0) + sale.totalPrice;
    }

    quantities.forEach((product, qty) {
      _productQuantities[product] = qty;
      _productRevenue[product] = revenues[product] ?? 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Analytics & Laporan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _loadAnalytics,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Summary Cards dengan Gradient
                      isMobile
                          ? Column(
                            children: [
                              _modernSummaryCard(
                                'Total Penjualan',
                                'Rp ${_formatNumber(_totalSales)}',
                                Icons.trending_up,
                                [Colors.green[400]!, Colors.green[700]!],
                              ),
                              const SizedBox(height: 16),
                              _modernSummaryCard(
                                'Total Terjual',
                                '$_totalQuantity item',
                                Icons.inventory,
                                [AppColors.primaryGreen, Colors.teal[700]!],
                              ),
                            ],
                          )
                          : Row(
                            children: [
                              Expanded(
                                child: _modernSummaryCard(
                                  'Total Penjualan',
                                  'Rp ${_formatNumber(_totalSales)}',
                                  Icons.trending_up,
                                  [Colors.green[400]!, Colors.green[700]!],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _modernSummaryCard(
                                  'Total Terjual',
                                  '$_totalQuantity item',
                                  Icons.inventory,
                                  [AppColors.primaryGreen, Colors.teal[700]!],
                                ),
                              ),
                            ],
                          ),
                      const SizedBox(height: 32),

                      // Sales Chart dengan Header Modern
                      _buildModernSectionHeader(
                        'Laporan Penjualan',
                        'Ringkasan penjualan harian',
                      ),
                      const SizedBox(height: 12),
                      _buildModernCard(
                        child: _buildSalesChart(isMobile),
                      ),
                      const SizedBox(height: 32),

                      // Product Performance dengan Header Modern
                      _buildModernSectionHeader(
                        'Performa Produk',
                        'Top 5 produk terlaris',
                      ),
                      const SizedBox(height: 12),
                      _buildModernCard(
                        child: _buildProductChart(isMobile),
                      ),
                      const SizedBox(height: 32),

                      // Stock Status dengan Header Modern
                      _buildModernSectionHeader(
                        'Status Stok Produk',
                        'Monitoring ketersediaan stok',
                      ),
                      const SizedBox(height: 12),
                      _buildModernCard(
                        child: Column(
                          children: [
                            ..._products
                                .take(5)
                                .map((product) => _buildModernStockTile(product)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Recent Sales dengan Header Modern
                      _buildModernSectionHeader(
                        'Penjualan Terbaru',
                        'Transaksi terakhir',
                      ),
                      const SizedBox(height: 12),
                      _buildModernCard(
                        child: Column(
                          children: [
                            ..._recentSales
                                .take(5)
                                .map((sale) => _buildModernSalesTile(sale)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
    );
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toStringAsFixed(0);
  }

  Widget _buildModernSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildModernCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: child,
      ),
    );
  }

  Widget _modernSummaryCard(
    String label,
    String value,
    IconData icon,
    List<Color> gradientColors,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernStockTile(Product product) {
    final stockPercentage = (product.stock / 100).clamp(0.0, 1.0);
    final stockColor =
        product.stock < 10
            ? Colors.red
            : product.stock < 50
            ? Colors.orange
            : AppColors.primaryGreen;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: stockColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${product.stock} unit',
                  style: TextStyle(
                    fontSize: 12,
                    color: stockColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: stockPercentage,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(stockColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernSalesTile(Sales sale) {
    final formattedDate = _formatSaleDate(sale.soldAt);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryGreen.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.shopping_bag,
                color: AppColors.primaryGreen,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sale.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        'Qty: ${sale.quantity}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 1,
                        height: 14,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(width: 12),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Rp ${_formatNumber(sale.totalPrice)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColors.primaryGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatSaleDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return date.toString().substring(0, 10);
    }
  }



  Widget _buildSalesChart(bool isMobile) {
    if (_recentSales.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'Belum ada data penjualan',
            style: TextStyle(color: Colors.grey[400]),
          ),
        ),
      );
    }

    // Group sales by date
    Map<String, double> dailySales = {};
    for (var sale in _recentSales) {
      final date = sale.soldAt.toLocal().toString().split(' ')[0];
      dailySales[date] = (dailySales[date] ?? 0) + sale.totalPrice;
    }

    final spots =
        dailySales.entries
            .toList()
            .asMap()
            .entries
            .map(
              (e) => FlSpot(
                e.key.toDouble(),
                dailySales.values.toList()[e.key].toDouble(),
              ),
            )
            .toList();

    final chartHeight = isMobile ? 300.0 : 250.0;
    final chartWidth = isMobile ? 600.0 : double.infinity;

    return SizedBox(
      height: chartHeight,
      width: chartWidth,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 50),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < dailySales.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        dailySales.keys.toList()[value.toInt()].substring(5),
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.primaryGreen,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primaryGreen.withValues(alpha: 0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductChart(bool isMobile) {
    if (_productQuantities.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'Belum ada data produk terjual',
            style: TextStyle(color: Colors.grey[400]),
          ),
        ),
      );
    }

    final topProducts =
        _productQuantities.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    final displayProducts = topProducts.take(5).toList();

    final chartHeight = isMobile ? 350.0 : 250.0;
    final chartWidth = isMobile ? 600.0 : double.infinity;

    return SizedBox(
      height: chartHeight,
      width: chartWidth,
      child: BarChart(
        BarChartData(
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 50),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < displayProducts.length) {
                    final name = displayProducts[value.toInt()].key;
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        children: [
                          for (int i = 0; i < name.length; i += 8)
                            Text(
                              name.substring(i, (i + 8).clamp(0, name.length)),
                              style: const TextStyle(fontSize: 9),
                            ),
                        ],
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups:
              displayProducts
                  .asMap()
                  .entries
                  .map(
                    (e) => BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value.value.toDouble(),
                          color: AppColors.primaryGreen,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }




}
