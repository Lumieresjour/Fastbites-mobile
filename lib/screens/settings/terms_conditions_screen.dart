import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms & Conditions',
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
              'Ketentuan Umum',
              'Dengan menggunakan platform Fastbites, Anda setuju untuk mematuhi semua ketentuan dan kondisi yang tercantum dalam dokumen ini. Platform ini menyediakan layanan penjualan dan pembelian makanan berkualitas dengan harga terjangkau. Semua pengguna harus berusia minimal 18 tahun atau memiliki izin dari orang tua/wali.',
            ),
            _buildSection(
              'Penggunaan Layanan',
              'Pengguna setuju untuk menggunakan platform ini hanya untuk tujuan yang sah dan sesuai dengan semua hukum dan peraturan yang berlaku. Anda tidak diizinkan untuk:\n\n• Menggunakan platform untuk kegiatan ilegal atau tidak etis\n• Mengirimkan konten yang menyinggung, berbahaya, atau melanggar hak cipta\n• Mengganggu operasi normal platform\n• Mengakses atau mencoba mengakses bagian terlarang dari platform',
            ),
            _buildSection(
              'Akun Pengguna',
              'Setiap pengguna bertanggung jawab untuk menjaga kerahasiaan informasi login mereka. Anda setuju untuk memberikan informasi yang akurat dan lengkap saat mendaftar. Fastbites berhak menangguhkan atau menghapus akun yang melanggar ketentuan ini. Pengguna harus segera melaporkan penggunaan akun yang tidak sah.',
            ),
            _buildSection(
              'Produk dan Layanan',
              'Fastbites menjamin bahwa semua produk yang dijual telah melewati pemeriksaan kualitas dan layak dikonsumsi. Harga produk dapat berubah sewaktu-waktu tanpa pemberitahuan sebelumnya. Fastbites berhak membatasi jumlah pembelian untuk setiap pengguna. Semua produk yang dijual adalah sebagaimana adanya (as-is) kecuali dinyatakan lain secara tertulis.',
            ),
            _buildSection(
              'Pembayaran',
              'Semua transaksi harus dilakukan melalui metode pembayaran yang disediakan oleh platform. Pengguna setuju untuk membayar semua biaya yang terkait dengan pembelian mereka. Fastbites tidak bertanggung jawab atas pembayaran yang terlewat atau ditolak. Pembayaran harus diselesaikan sebelum pengiriman produk dilakukan.',
            ),
            _buildSection(
              'Pengiriman dan Pengembalian',
              'Pengiriman dilakukan sesuai dengan alamat yang didaftarkan oleh pembeli. Fastbites tidak bertanggung jawab atas keterlambatan pengiriman karena faktor di luar kendali, seperti cuaca atau gangguan jalan. Produk yang rusak atau cacat dapat dikembalikan dalam waktu 24 jam setelah penerimaan dengan bukti foto/video. Pengembalian dana akan diproses dalam 5-7 hari kerja setelah verifikasi.',
            ),
            _buildSection(
              'Batasan Tanggung Jawab',
              'Fastbites tidak bertanggung jawab atas:\n\n• Kerugian tidak langsung atau tidak terduga\n• Kehilangan data atau dokumen\n• Penghentian layanan yang tiba-tiba\n• Keputusan pengguna berdasarkan informasi di platform\n\nTanggung jawab Fastbites dibatasi pada jumlah yang dibayarkan pengguna dalam 30 hari terakhir.',
            ),
            _buildSection(
              'Modifikasi Ketentuan',
              'Fastbites berhak mengubah, menambah, atau mengurangi ketentuan ini kapan saja tanpa pemberitahuan sebelumnya. Penggunaan platform setelah perubahan ketentuan berarti Anda menerima ketentuan yang baru. Kami merekomendasikan untuk meninjau ketentuan ini secara berkala.',
            ),
            _buildSection(
              'Penyelesaian Sengketa',
              'Setiap sengketa antara pengguna dan Fastbites akan diselesaikan melalui negosiasi bermusyawarah. Jika negosiasi gagal, sengketa akan diselesaikan melalui arbitrase atau jalur hukum sesuai dengan peraturan perundang-undangan yang berlaku di Indonesia.',
            ),
            _buildSection(
              'Hubungi Kami',
              'Jika Anda memiliki pertanyaan tentang Terms & Conditions ini, silakan hubungi kami:\n\nEmail: fastbites@gmail.com\nWhatsApp: 0812-3456-7890\nInstagram: @fastbites',
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
