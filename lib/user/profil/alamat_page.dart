import 'package:flutter/material.dart';

class AlamatPage extends StatefulWidget {
  const AlamatPage({Key? key}) : super(key: key);

  @override
  State<AlamatPage> createState() => _AlamatPageState();
}

class _AlamatPageState extends State<AlamatPage> {
  final TextEditingController _searchController = TextEditingController();
  String selectedAlamat = '';

  // Data alamat dummy
  List<Map<String, dynamic>> alamatList = [
    {
      'nama': 'Moka',
      'telepon': '081234567890',
      'alamat': 'Jl. Sudirman No. 123, Jakarta Selatan, DKI Jakarta 12190',
      'isPinned': true,
      'isSelected': true,
    },
    {
      'nama': 'Rumah Orang Tua',
      'telepon': '081234567891',
      'alamat': 'Jl. Kebon Jeruk No. 45, Jakarta Barat, DKI Jakarta 11530',
      'isPinned': false,
      'isSelected': false,
    },
    {
      'nama': 'Kantor',
      'telepon': '081234567892',
      'alamat': 'Jl. Thamrin No. 67, Jakarta Pusat, DKI Jakarta 10340',
      'isPinned': false,
      'isSelected': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF5962),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Daftar Alamat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header dengan info user
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFFF5962),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: Column(
                children: [
                  // Profile section
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Semua Alamat',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Kelola Alamat Pengiriman',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari alamat...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onChanged: (value) {
                // Implementasi pencarian
                setState(() {});
              },
            ),
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Aksi tambah alamat
                      _showTambahAlamatDialog();
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Tambah Alamat',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5962),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Aksi pilih alamat
                    _showPilihAlamatDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFFFF5962)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Pilih Alamat',
                    style: TextStyle(color: Color(0xFFFF5962)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Daftar alamat
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: alamatList.length,
              itemBuilder: (context, index) {
                final alamat = alamatList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5962).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        alamat['isPinned'] ? Icons.push_pin : Icons.location_on,
                        color: const Color(0xFFFF5962),
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            alamat['nama'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (alamat['isSelected'])
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF5962),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Dipilih',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          alamat['telepon'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          alamat['alamat'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            InkWell(
                              onTap: () => _showUbahAlamatDialog(index),
                              child: const Text(
                                'Ubah',
                                style: TextStyle(
                                  color: Color(0xFFFF5962),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            InkWell(
                              onTap: () => _togglePin(index),
                              child: Text(
                                alamat['isPinned'] ? 'Unpin' : 'Pin',
                                style: const TextStyle(
                                  color: Color(0xFFFF5962),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () => _selectAlamat(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showTambahAlamatDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Alamat'),
          content: const Text('Fitur tambah alamat akan segera tersedia.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showPilihAlamatDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Alamat'),
          content: const Text('Silakan pilih alamat dari daftar di bawah.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showUbahAlamatDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ubah Alamat'),
          content: Text('Ubah alamat: ${alamatList[index]['nama']}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Implementasi ubah alamat
              },
              child: const Text('Ubah'),
            ),
          ],
        );
      },
    );
  }

  void _togglePin(int index) {
    setState(() {
      alamatList[index]['isPinned'] = !alamatList[index]['isPinned'];
    });
  }

  void _selectAlamat(int index) {
    setState(() {
      // Reset semua alamat
      for (var alamat in alamatList) {
        alamat['isSelected'] = false;
      }
      // Pilih alamat yang diklik
      alamatList[index]['isSelected'] = true;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
