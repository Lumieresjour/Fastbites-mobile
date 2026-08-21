import 'package:flutter/material.dart';
import 'search_field.dart';
import '../../models/product.dart';
import '../../services/database_service.dart';
import '../../user/beranda/Makanan_card.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  String? _selectedCategory;
  String _searchQuery = '';
  List<Product> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final db = DatabaseService();
      final products = await db.getAllProducts();
      setState(() {
        _products = products;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  List<Product> _getFilteredProducts() {
    return _products.where((product) {
      // Filter berdasarkan kategori
      if (_selectedCategory != null && product.category != _selectedCategory) {
        return false;
      }
      // Filter berdasarkan search query
      if (_searchQuery.isNotEmpty) {
        return product.name
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _getFilteredProducts();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 89, 98),
        automaticallyImplyLeading: false,
        title: SearchField(
          onChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
          },
          onCategoryChanged: (category) {
            setState(() {
              _selectedCategory = category;
            });
          },
          selectedCategory: _selectedCategory,
        ),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _selectedCategory != null
                              ? Icons.filter_list
                              : Icons.search,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _selectedCategory != null
                              ? 'Tidak ada produk di kategori $_selectedCategory'
                              : _searchQuery.isNotEmpty
                                  ? 'Tidak ada produk yang cocok dengan "$_searchQuery"'
                                  : 'Tidak ada produk',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                          mainAxisExtent: 250,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (_, index) {
                          final product = filteredProducts[index];
                          // Gunakan default image jika tidak ada
                          final imageUrl = product.image ?? 'assets/images/Pink_Donut-removebg-preview.png';
                          return MakananCard(
                            judul: product.name,
                            harga: 'Rp. ${product.price}',
                            foto: imageUrl,
                          );
                        },
                      ),
                    ),
                  ),
      ),
    );
  }
}
