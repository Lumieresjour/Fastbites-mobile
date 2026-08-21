import 'package:flutter/material.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat Pesanan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFFF5962),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5, // Contoh data
        itemBuilder: (context, index) {
          return _buildOrderCard(context, index);
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, int index) {
    // Data contoh untuk setiap pesanan
    final orderData = [
      {
        'orderId': 'ORD-001',
        'restaurant': 'Warung Padang Sederhana',
        'date': '12 Juni 2025',
        'time': '14:30',
        'items': ['Rendang', 'Nasi Putih', 'Sayur Bayam'],
        'total': 'Rp 45.000',
        'status': 'Selesai',
        'statusColor': Colors.green,
      },
      {
        'orderId': 'ORD-002',
        'restaurant': 'Pizza Corner',
        'date': '11 Juni 2025',
        'time': '19:15',
        'items': ['Pizza Margherita', 'Coca Cola'],
        'total': 'Rp 85.000',
        'status': 'Selesai',
        'statusColor': Colors.green,
      },
      {
        'orderId': 'ORD-003',
        'restaurant': 'Bakso Malang Pak Kumis',
        'date': '10 Juni 2025',
        'time': '12:45',
        'items': ['Bakso Urat', 'Es Teh Manis'],
        'total': 'Rp 25.000',
        'status': 'Dibatalkan',
        'statusColor': Colors.red,
      },
      {
        'orderId': 'ORD-004',
        'restaurant': 'Sushi Tei',
        'date': '9 Juni 2025',
        'time': '20:00',
        'items': ['Salmon Sashimi', 'California Roll', 'Miso Soup'],
        'total': 'Rp 125.000',
        'status': 'Selesai',
        'statusColor': Colors.green,
      },
      {
        'orderId': 'ORD-005',
        'restaurant': 'Ayam Geprek Bensu',
        'date': '8 Juni 2025',
        'time': '18:30',
        'items': ['Ayam Geprek Level 3', 'Nasi Putih', 'Es Jeruk'],
        'total': 'Rp 35.000',
        'status': 'Selesai',
        'statusColor': Colors.green,
      },
    ];

    final order = orderData[index];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to order detail page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailPage(orderId: order['orderId'] as String),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row dengan ID pesanan dan status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order['orderId'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: (order['statusColor'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order['status'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: order['statusColor'] as Color,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Nama restoran
              Row(
                children: [
                  const Icon(
                    Icons.restaurant,
                    size: 16,
                    color: Color(0xFFFF5962),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order['restaurant'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Tanggal dan waktu
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${order['date']} • ${order['time']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Item pesanan
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Item Pesanan:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      (order['items'] as List<String>).join(', '),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Total dan tombol aksi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Pembayaran',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        order['total'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF5962),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (order['status'] == 'Selesai') ...[
                        OutlinedButton(
                          onPressed: () {
                            // Pesan lagi
                            _showOrderAgainDialog(context, order['restaurant'] as String);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFFF5962)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Pesan Lagi',
                            style: TextStyle(
                              color: Color(0xFFFF5962),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      ElevatedButton(
                        onPressed: () {
                          // Lihat detail
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailPage(orderId: order['orderId'] as String),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5962),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Detail',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOrderAgainDialog(BuildContext context, String restaurant) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pesan Lagi'),
          content: Text('Apakah Anda ingin memesan lagi dari $restaurant?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to restaurant page or add to cart
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Mengarahkan ke $restaurant...'),
                    backgroundColor: const Color(0xFFFF5962),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5962),
              ),
              child: const Text(
                'Ya, Pesan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Halaman Detail Pesanan
class OrderDetailPage extends StatelessWidget {
  final String orderId;
  
  const OrderDetailPage({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail $orderId',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFFF5962),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pesanan Selesai',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Pesanan telah selesai diantar',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Order Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informasi Pesanan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('ID Pesanan', orderId),
                    _buildInfoRow('Tanggal', '12 Juni 2025, 14:30'),
                    _buildInfoRow('Restoran', 'Warung Padang Sederhana'),
                    _buildInfoRow('Metode Pembayaran', 'GoPay'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Items
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detail Pesanan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildItemRow('Rendang', 1, 'Rp 25.000'),
                    _buildItemRow('Nasi Putih', 1, 'Rp 5.000'),
                    _buildItemRow('Sayur Bayam', 1, 'Rp 8.000'),
                    const Divider(),
                    _buildTotalRow('Subtotal', 'Rp 38.000'),
                    _buildTotalRow('Ongkir', 'Rp 5.000'),
                    _buildTotalRow('Biaya Layanan', 'Rp 2.000'),
                    const Divider(),
                    _buildTotalRow('Total', 'Rp 45.000', isTotal: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(String name, int qty, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$name x$qty',
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isTotal ? 16 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isTotal ? Colors.black : Colors.grey[600],
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: FontWeight.bold,
              color: isTotal ? const Color(0xFFFF5962) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}