import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kebijakan Privasi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Pengantar',
              'Kebijakan Privasi ini menjelaskan bagaimana Fastbites mengumpulkan, menggunakan, melindungi, dan membagikan informasi pribadi Anda. Kami berkomitmen untuk melindungi privasi Anda dan memastikan transparansi dalam penggunaan data. Dengan menggunakan platform Fastbites, Anda setuju dengan praktik privasi yang dijelaskan dalam dokumen ini.',
            ),
            _buildSection(
              'Informasi yang Kami Kumpulkan',
              'Kami mengumpulkan informasi berikut:\n\n• Informasi Pendaftaran: Nama, email, nomor telepon, alamat, dan password\n• Informasi Transaksi: Detail pembelian, metode pembayaran, dan riwayat order\n• Informasi Perangkat: Tipe perangkat, sistem operasi, dan browser yang Anda gunakan\n• Informasi Lokasi: Alamat pengiriman dan lokasi geografis (jika diizinkan)\n• Informasi Perilaku: Produk yang dilihat, pencarian, dan aktivitas di platform',
            ),
            _buildSection(
              'Penggunaan Informasi',
              'Kami menggunakan informasi yang dikumpulkan untuk:\n\n• Memberikan dan meningkatkan layanan\n• Memproses transaksi dan pengiriman\n• Mengirim notifikasi dan update penting\n• Personalisasi pengalaman pengguna\n• Analisis dan riset pasar\n• Keamanan dan pencegahan penipuan\n• Mematuhi kewajiban hukum',
            ),
            _buildSection(
              'Keamanan Data',
              'Fastbites menggunakan enkripsi SSL/TLS untuk melindungi data pribadi Anda selama transmisi. Kami menyimpan data Anda di server yang aman dengan kontrol akses yang ketat. Hanya karyawan yang berwenang yang dapat mengakses informasi pribadi Anda. Kami secara berkala melakukan audit keamanan untuk memastikan perlindungan data yang optimal.',
            ),
            _buildSection(
              'Berbagi Informasi',
              'Kami tidak menjual atau menyewakan data pribadi Anda kepada pihak ketiga. Kami hanya membagikan informasi Anda dengan:\n\n• Mitra pengiriman: Untuk memproses pengiriman pesanan\n• Penyedia pembayaran: Untuk memproses transaksi\n• Otoritas hukum: Jika diwajibkan oleh hukum\n• Tim internal Fastbites: Yang membutuhkan akses untuk tugas mereka',
            ),
            _buildSection(
              'Cookie dan Teknologi Pelacakan',
              'Platform kami menggunakan cookie untuk meningkatkan pengalaman pengguna. Cookie disimpan di perangkat Anda dan membantu kami mengingat preferensi Anda. Anda dapat mengatur browser Anda untuk menolak cookie, tetapi ini mungkin mempengaruhi fungsionalitas platform. Kami juga menggunakan analytics untuk memahami bagaimana pengguna berinteraksi dengan platform.',
            ),
            _buildSection(
              'Hak Privasi Pengguna',
              'Anda memiliki hak untuk:\n\n• Mengakses data pribadi Anda\n• Memperbaiki informasi yang tidak akurat\n• Menghapus akun dan data pribadi Anda\n• Membatasi penggunaan data Anda\n• Mengunduh data pribadi Anda dalam format standar\n• Mengajukan keberatan terhadap pemrosesan data',
            ),
            _buildSection(
              'Retensi Data',
              'Kami menyimpan data pribadi Anda selama Anda memiliki akun aktif. Jika Anda menghapus akun, data Anda akan dihapus dalam waktu 30 hari, kecuali kami diwajibkan oleh hukum untuk menyimpannya lebih lama. Data transaksi mungkin disimpan lebih lama untuk keperluan audit dan kewajiban pajak.',
            ),
            _buildSection(
              'Privasi Anak-Anak',
              'Layanan kami tidak ditujukan untuk anak-anak di bawah usia 13 tahun. Kami tidak dengan sengaja mengumpulkan informasi pribadi dari anak-anak. Jika kami mengetahui bahwa informasi anak-anak telah dikumpulkan, kami akan menghapusnya segera. Orang tua yang percaya bahwa anak mereka telah memberikan informasi kepada kami dapat menghubungi kami.',
            ),
            _buildSection(
              'Tautan Eksternal',
              'Platform kami mungkin berisi tautan ke situs web eksternal. Fastbites tidak bertanggung jawab atas kebijakan privasi situs-situs tersebut. Kami merekomendasikan untuk membaca kebijakan privasi situs eksternal sebelum memberikan informasi pribadi Anda.',
            ),
            _buildSection(
              'Perubahan Kebijakan Privasi',
              'Fastbites dapat memperbarui Kebijakan Privasi ini dari waktu ke waktu. Kami akan memberitahukan Anda tentang perubahan signifikan melalui email atau notifikasi di platform. Penggunaan berkelanjutan dari platform setelah perubahan berarti Anda menerima kebijakan yang diperbarui.',
            ),
            _buildSection(
              'Hubungi Kami',
              'Jika Anda memiliki pertanyaan atau kekhawatiran tentang privasi Anda, silakan hubungi kami:\n\nEmail: fastbites@gmail.com\nWhatsApp: 0812-3456-7890\nInstagram: @fastbites\n\nTim kami siap membantu Anda dalam waktu 24 jam kerja.',
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightGreen.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primaryGreen, width: 1),
              ),
              child: Text(
                'Terakhir diperbarui: ${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return months[month - 1];
  }
}
