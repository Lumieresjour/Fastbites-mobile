import 'package:flutter/material.dart';

class AddressPage extends StatelessWidget {
  final Function(String) onAddressSelected;

  const AddressPage({
    super.key,
    required this.onAddressSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF5962),
        title: const Text('Pilih Alamat'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAddressCard(
            context,
            'Alamat Rumah',
            'Jl. Contoh No. 123, Kota, Provinsi',
            onAddressSelected,
          ),
          const SizedBox(height: 16),
          _buildAddressCard(
            context,
            'Alamat Kantor',
            'Jl. Perusahaan No. 456, Kota, Provinsi',
            onAddressSelected,
          ),
          const SizedBox(height: 16),
          _buildAddressCard(
            context,
            'Alamat Kos',
            'Jl. Kos No. 789, Kota, Provinsi',
            onAddressSelected,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement add new address
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur menambah alamat akan segera hadir!'),
                  backgroundColor: Color(0xFFFF5962),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5962),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Tambah Alamat Baru',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(
    BuildContext context,
    String title,
    String address,
    Function(String) onAddressSelected,
  ) {
    return GestureDetector(
      onTap: () {
        onAddressSelected(address);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: Color(0xFFFF5962)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              address,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 