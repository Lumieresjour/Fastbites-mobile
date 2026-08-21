import 'package:flutter/material.dart';

class FavoritPage extends StatefulWidget {
  const FavoritPage({Key? key}) : super(key: key);

  @override
  State<FavoritPage> createState() => _FavoritPageState();
}

class _FavoritPageState extends State<FavoritPage> {
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = 'Semua';

  // Data favorit dummy
  List<Map<String, dynamic>> favoritList = [
    {
      'nama': 'Nasi Gudeg Jogja',
      'restoran': 'Warung Bu Sari',
      'harga': 25000,
      'rating': 4.5,
      'kategori': 'Makanan',
      'gambar': 'nasi_gudeg.jpg',
      'isFavorite': true,
      'deskripsi': 'Nasi gudeg khas Jogja dengan ayam dan telur',
    },
    {
      'nama': 'Es Teh Manis',
      'restoran': 'Kedai Segar',
      'harga': 5000,
      'rating': 4.2,
      'kategori': 'Minuman',
      'gambar': 'es_teh.jpg',
      'isFavorite': true,
      'deskripsi': 'Es teh manis segar untuk cuaca panas',
    },
    {
      'nama': 'Ayam Geprek Sambal Ijo',
      'restoran': 'Geprek Mas Yanto',
      'harga': 18000,
      'rating': 4.7,
      'kategori': 'Makanan',
      'gambar': 'ayam_geprek.jpg',
      'isFavorite': true,
      'deskripsi': 'Ayam geprek dengan sambal ijo pedas mantap',
    },
    {
      'nama': 'Kopi Arabica',
      'restoran': 'Coffee Corner',
      'harga': 15000,
      'rating': 4.6,
      'kategori': 'Minuman',
      'gambar': 'kopi_arabica.jpg',
      'isFavorite': true,
      'deskripsi': 'Kopi arabica premium dengan aroma khas',
    },
    {
      'nama': 'Mie Ayam Bakso',
      'restoran': 'Mie Ayam Pak Kumis',
      'harga': 12000,
      'rating': 4.3,
      'kategori': 'Makanan',
      'gambar': 'mie_ayam.jpg',
      'isFavorite': true,
      'deskripsi': 'Mie ayam dengan bakso dan pangsit goreng',
    },
  ];  

  List<String> categories = ['Semua', 'Makanan', 'Minuman', 'Snack'];

  List<Map<String, dynamic>> get filteredFavorit {
    if (selectedCategory == 'Semua') {
      return favoritList
          .where((item) =>
              item['nama']
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              item['restoran']
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
          .toList();
    } else {
      return favoritList
          .where((item) =>
              item['kategori'] == selectedCategory &&
              (item['nama']
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase()) ||
                  item['restoran']
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase())))
          .toList();
    }
  }

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
          'Menu Favorit',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => _showMoreOptions(),
          ),
        ],
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
                    'Moka',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Moka@gmail.com',
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
                hintText: 'Cari makanan atau restoran favorit...',
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
                setState(() {});
              },
            ),
          ),

          // Filter kategori
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;
                return Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: FilterChip(
                    label: Text(
                      category,
                      style: TextStyle(
                        color:
                            isSelected ? Colors.white : const Color(0xFFFF5962),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: const Color(0xFFFF5962),
                    side: const BorderSide(color: Color(0xFFFF5962)),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Info jumlah favorit
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(
                  Icons.favorite,
                  color: Color(0xFFFF5962),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '${filteredFavorit.length} makanan dan restoran favorit',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Daftar favorit
          Expanded(
            child: filteredFavorit.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada favorit',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tambahkan makanan favorit Anda',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredFavorit.length,
                    itemBuilder: (context, index) {
                      final item = filteredFavorit[index];
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
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF5962).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.fastfood,
                              color: Color(0xFFFF5962),
                              size: 30,
                            ),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item['nama'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  item['isFavorite']
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: const Color(0xFFFF5962),
                                ),
                                onPressed: () => _toggleFavorite(index),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                item['restoran'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['deskripsi'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF5962)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      item['kategori'],
                                      style: const TextStyle(
                                        color: Color(0xFFFF5962),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.orange[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    item['rating'].toString(),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Rp ${item['harga'].toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                    style: const TextStyle(
                                      color: Color(0xFFFF5962),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () => _showDetailItem(item),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTambahFavoritDialog(),
        backgroundColor: const Color(0xFFFF5962),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _toggleFavorite(int index) {
    setState(() {
      filteredFavorit[index]['isFavorite'] =
          !filteredFavorit[index]['isFavorite'];
      if (!filteredFavorit[index]['isFavorite']) {
        // Hapus dari daftar favorit
        favoritList.removeWhere(
            (item) => item['nama'] == filteredFavorit[index]['nama']);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          filteredFavorit[index]['isFavorite']
              ? 'Ditambahkan ke favorit'
              : 'Dihapus dari favorit',
        ),
        backgroundColor: const Color(0xFFFF5962),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showDetailItem(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item['nama'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Restoran: ${item['restoran']}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Kategori: ${item['kategori']}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Rating: ${item['rating']} ⭐',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Harga: Rp ${item['harga'].toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF5962),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Deskripsi:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item['deskripsi'],
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showPesanDialog(item);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5962),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Pesan Sekarang',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTambahFavoritDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Favorit'),
          content: const Text(
              'Fitur tambah favorit manual akan segera tersedia.\nAnda bisa menambah favorit dari menu restoran.'),
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

  void _showPesanDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pesan Makanan'),
          content: Text('Pesan ${item['nama']} dari ${item['restoran']}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pesanan berhasil ditambahkan ke keranjang!'),
                    backgroundColor: Color(0xFFFF5962),
                  ),
                );
              },
              child: const Text('Pesan'),
            ),
          ],
        );
      },
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.clear_all, color: Color(0xFFFF5962)),
                title: const Text('Hapus Semua Favorit'),
                onTap: () {
                  Navigator.pop(context);
                  _showHapusSemuaDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Color(0xFFFF5962)),
                title: const Text('Bagikan Daftar Favorit'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur berbagi akan segera tersedia!'),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showHapusSemuaDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Semua Favorit'),
          content: const Text(
              'Apakah Anda yakin ingin menghapus semua makanan dan restoran favorit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  favoritList.clear();
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Semua favorit berhasil dihapus!'),
                    backgroundColor: Color(0xFFFF5962),
                  ),
                );
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
