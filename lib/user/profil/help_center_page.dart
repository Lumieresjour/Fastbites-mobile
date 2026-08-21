import 'package:flutter/material.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  _HelpCenterPageState createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  final TextEditingController _searchController = TextEditingController();
  List<FAQItem> _faqItems = [];
  List<FAQItem> _filteredFAQItems = [];

  @override
  void initState() {
    super.initState();
    _initializeFAQItems();
    _filteredFAQItems = _faqItems;
  }

  void _initializeFAQItems() {
    _faqItems = [
      FAQItem(
        question: 'Bagaimana cara membuat pesanan?',
        answer:
            'Pilih makanan atau restoran favorit, tambahkan ke keranjang, lalu lanjutkan ke pembayaran. Pastikan alamat pengiriman sudah benar sebelum menyelesaikan pesanan.',
      ),
      FAQItem(
        question: 'Metode pembayaran apa saja yang tersedia?',
        answer:
            'Kami menerima pembayaran tunai, kartu debit/kredit, e-wallet (GoPay, OVO, DANA), dan transfer bank. Pilih metode yang paling nyaman untuk Anda.',
      ),
      FAQItem(
        question: 'Berapa lama waktu pengiriman?',
        answer:
            'Waktu pengiriman biasanya 30-60 menit tergantung jarak dan kondisi lalu lintas. Anda dapat memantau status pesanan secara real-time di aplikasi.',
      ),
      FAQItem(
        question: 'Bagaimana cara membatalkan pesanan?',
        answer:
            'Pesanan dapat dibatalkan dalam 5 menit setelah dikonfirmasi. Buka riwayat pesanan, pilih pesanan yang ingin dibatalkan, lalu tekan tombol "Batalkan Pesanan".',
      ),
      FAQItem(
        question: 'Bagaimana cara menambahkan alamat baru?',
        answer:
            'Masuk ke menu Profil → Alamat → Tambah Alamat Baru. Masukkan detail alamat lengkap dan beri nama untuk memudahkan identifikasi.',
      ),
      FAQItem(
        question: 'Apa yang harus dilakukan jika makanan tidak sesuai?',
        answer:
            'Laporkan masalah melalui menu "Riwayat Pesanan" atau hubungi customer service. Kami akan membantu menyelesaikan masalah dan memberikan solusi terbaik.',
      ),
    ];
  }

  void _filterFAQ(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredFAQItems = _faqItems;
      } else {
        _filteredFAQItems = _faqItems
            .where((item) =>
                item.question.toLowerCase().contains(query.toLowerCase()) ||
                item.answer.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header with profile-like design
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFFF5962),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Back button
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Profile-like header content
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                    child: Column(
                      children: [
                        // Help Center Icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.help_outline,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Pusat Bantuan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'help@fastbites.com',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Search Box
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filterFAQ,
                        decoration: InputDecoration(
                          hintText: 'Cari bantuan...',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          prefixIcon:
                              Icon(Icons.search, color: Colors.grey[500]),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                      ),
                    ),

                    // Menu Items (Profile-style)
                    _buildMenuItem(
                      icon: Icons.phone,
                      iconColor: const Color(0xFFFF5962),
                      title: 'Hubungi Customer Service',
                      subtitle: 'Chat langsung dengan tim support',
                      onTap: () => _contactSupport(),
                    ),

                    _buildMenuItem(
                      icon: Icons.email,
                      iconColor: const Color(0xFFFF5962),
                      title: 'Email Support',
                      subtitle: 'Kirim pertanyaan via email',
                      onTap: () => _emailSupport(),
                    ),

                    _buildMenuItem(
                      icon: Icons.question_answer,
                      iconColor: const Color(0xFFFF5962),
                      title: 'Pertanyaan Umum',
                      subtitle: 'Temukan jawaban cepat',
                      onTap: () => _showFAQDialog(),
                    ),

                    _buildMenuItem(
                      icon: Icons.account_circle,
                      iconColor: const Color(0xFFFF5962),
                      title: 'Akun & Profil',
                      subtitle: 'Bantuan terkait akun Anda',
                      onTap: () => _showCategory('account'),
                    ),

                    _buildMenuItem(
                      icon: Icons.payment,
                      iconColor: const Color(0xFFFF5962),
                      title: 'Pembayaran & Refund',
                      subtitle: 'Masalah pembayaran dan pengembalian',
                      onTap: () => _showCategory('payment'),
                    ),

                    _buildMenuItem(
                      icon: Icons.delivery_dining,
                      iconColor: const Color(0xFFFF5962),
                      title: 'Pengiriman & Kurir',
                      subtitle: 'Info pengiriman dan kurir',
                      onTap: () => _showCategory('delivery'),
                    ),

                    _buildMenuItem(
                      icon: Icons.local_offer,
                      iconColor: const Color(0xFFFF5962),
                      title: 'Promo & Voucher',
                      subtitle: 'Bantuan promo dan voucher',
                      onTap: () => _showCategory('promo'),
                    ),

                    const SizedBox(height: 20),

                    // Contact Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5962),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF5962).withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.support_agent,
                            color: Colors.white,
                            size: 40,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Masih butuh bantuan?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tim customer service kami siap membantu Anda 24/7',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () => _contactSupport(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFFFF5962),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Hubungi Sekarang',
                              style: TextStyle(
                                color: Color(0xFFFF5962),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _contactSupport() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Hubungi Customer Service',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFFFF5962),
            ),
          ),
          content: const Text('Menghubungkan ke customer service...'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xFFFF5962)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _emailSupport() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Email Support',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFFFF5962),
            ),
          ),
          content: const Text('Membuka aplikasi email...'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xFFFF5962)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showFAQDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Pertanyaan Umum',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFFFF5962),
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredFAQItems.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(
                    _filteredFAQItems[index].question,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  iconColor: const Color(0xFFFF5962),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        _filteredFAQItems[index].answer,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Tutup',
                style: TextStyle(color: Color(0xFFFF5962)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCategory(String category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Kategori Bantuan',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFFFF5962),
            ),
          ),
          content: Text('Menampilkan bantuan untuk kategori: $category'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xFFFF5962)),
              ),
            ),
          ],
        );
      },
    );
  }
}

class FAQItem {
  final String question;
  final String answer;
  bool isExpanded;

  FAQItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}
