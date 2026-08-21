import 'package:flutter/material.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({Key? key}) : super(key: key);

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  String? selectedPaymentMethod;

  final List<PaymentMethod> paymentMethods = [
    PaymentMethod(
      id: 'dana',
      name: 'DANA',
      subtitle: 'Pembayaran menggunakan DANA',
      icon: Icons.account_balance_wallet,
      color: Colors.blue,
    ),
    PaymentMethod(
      id: 'gopay',
      name: 'GoPay',
      subtitle: 'Pembayaran menggunakan GoPay',
      icon: Icons.payment,
      color: Colors.green,
    ),
    PaymentMethod(
      id: 'ovo',
      name: 'OVO',
      subtitle: 'Pembayaran menggunakan OVO',
      icon: Icons.account_balance_wallet_outlined,
      color: Colors.purple,
    ),
    PaymentMethod(
      id: 'shopeepay',
      name: 'ShopeePay',
      subtitle: 'Pembayaran menggunakan ShopeePay',
      icon: Icons.wallet_membership,
      color: Colors.orange,
    ),
    PaymentMethod(
      id: 'bank_transfer',
      name: 'Transfer Bank',
      subtitle: 'Transfer melalui rekening bank',
      icon: Icons.account_balance,
      color: Colors.indigo,
    ),
    PaymentMethod(
      id: 'credit_card',
      name: 'Kartu Kredit/Debit',
      subtitle: 'Pembayaran menggunakan kartu',
      icon: Icons.credit_card,
      color: Colors.teal,
    ),
    PaymentMethod(
      id: 'cod',
      name: 'Bayar di Tempat (COD)',
      subtitle: 'Bayar saat makanan diterima',
      icon: Icons.money,
      color: Colors.brown,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header section with red background
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFFF5962),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // App bar
                    Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            'Metode Pembayaran',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48), // Balance the back button
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Payment icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.payment,
                        color: Color(0xFFFF5962),
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Title
                    const Text(
                      'Metode Pembayaran',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Subtitle
                    const Text(
                      'Atur cara pembayaran',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          // Content section
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Payment methods list
                ...paymentMethods
                    .map((method) => _buildPaymentMethodItem(method)),
                const SizedBox(height: 16),
                // Save button
                if (selectedPaymentMethod != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle save payment method
                        _savePaymentMethod();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5962),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Simpan Metode Pembayaran',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodItem(PaymentMethod method) {
    final bool isSelected = selectedPaymentMethod == method.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? const Color(0xFFFF5962) : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              selectedPaymentMethod = method.id;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Payment method icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: method.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    method.icon,
                    color: method.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Payment method info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        method.subtitle,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Selection indicator
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFFF5962)
                          : Colors.grey[400]!,
                      width: 2,
                    ),
                    color: isSelected
                        ? const Color(0xFFFF5962)
                        : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 12,
                          color: Colors.white,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _savePaymentMethod() {
    final selectedMethod = paymentMethods.firstWhere(
      (method) => method.id == selectedPaymentMethod,
    );

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Metode pembayaran ${selectedMethod.name} telah dipilih'),
        backgroundColor: const Color(0xFFFF5962),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    // Navigate back with result
    Navigator.pop(context, selectedMethod);
  }
}

class PaymentMethod {
  final String id;
  final String name;
  final String subtitle;
  final IconData icon;
  final Color color;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
