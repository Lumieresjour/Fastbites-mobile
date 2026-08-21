import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  final Function(String) onPaymentSelected;

  const PaymentPage({
    super.key,
    required this.onPaymentSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF5962),
        title: const Text('Pilih Pembayaran'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPaymentCard(
            context,
            'E-Wallet',
            'Gunakan e-wallet untuk pembayaran cepat',
            Icons.account_balance_wallet,
            onPaymentSelected,
          ),
          const SizedBox(height: 16),
          _buildPaymentCard(
            context,
            'Kartu Kredit/Debit',
            'Bayar menggunakan kartu kredit atau debit',
            Icons.credit_card,
            onPaymentSelected,
          ),
          const SizedBox(height: 16),
          _buildPaymentCard(
            context,
            'Transfer Bank',
            'Transfer melalui rekening bank',
            Icons.account_balance,
            onPaymentSelected,
          ),
          const SizedBox(height: 16),
          _buildPaymentCard(
            context,
            'Bayar di Tempat',
            'Bayar tunai saat makanan diterima',
            Icons.payments,
            onPaymentSelected,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Function(String) onPaymentSelected,
  ) {
    return GestureDetector(
      onTap: () {
        onPaymentSelected(title);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFFF5962),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
} 