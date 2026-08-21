import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../models/product.dart';
import 'product_form_screen.dart';
import '../../utils/app_colors.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _loading = true);
    final db = DatabaseService();
    final list = await db.getAllProducts();

    // If no products exist, seed a few default products
    if (list.isEmpty) {
      final now = DateTime.now();
      final defaults = [
        Product(
          name: 'Donat Coklat Berlapis',
          description: 'Donat lembut dengan lapisan coklat premium',
          price: 12000,
          stock: 50,
          sku: 'DN-CHO-001',
          image: null,
          createdAt: now.subtract(const Duration(days: 10)),
          category: 'makanan',
        ),
        Product(
          name: 'Donat Glaze Original',
          description: 'Donat klasik glazed, empuk dan manis pas',
          price: 10000,
          stock: 80,
          sku: 'DN-GLZ-002',
          image: null,
          createdAt: now.subtract(const Duration(days: 8)),
          category: 'makanan',
        ),
        Product(
          name: 'Espresso Premium',
          description: 'Kopi espresso dengan aroma kuat dan crema tebal',
          price: 18000,
          stock: 40,
          sku: 'KP-ESP-003',
          image: null,
          createdAt: now.subtract(const Duration(days: 6)),
          category: 'minuman',
        ),
        Product(
          name: 'Kopi Latte Premium',
          description: 'Latte lembut dengan susu premium',
          price: 20000,
          stock: 35,
          sku: 'KP-LAT-004',
          image: null,
          createdAt: now.subtract(const Duration(days: 5)),
          category: 'minuman',
        ),
        Product(
          name: 'Donat Vanila',
          description: 'Donat dengan taburan gula vanila',
          price: 9000,
          stock: 60,
          sku: 'DN-VAN-005',
          image: null,
          createdAt: now.subtract(const Duration(days: 3)),
          category: 'makanan',
        ),
      ];

      for (final p in defaults) {
        await db.createProduct(p);
      }

      final seeded = await db.getAllProducts();
      setState(() {
        _products = seeded;
        _loading = false;
      });
      return;
    }

    setState(() {
      _products = list;
      _loading = false;
    });
  }

  void _onAdd() async {
    final created = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ProductFormScreen()));
    if (created == true) _loadProducts();
  }

  void _onEdit(Product p) async {
    final updated = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => ProductFormScreen(product: p)));
    if (updated == true) _loadProducts();
  }

  void _onDelete(Product p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder:
          (c) => AlertDialog(
            title: const Text('Hapus produk'),
            content: Text('Hapus produk "${p.name}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(c, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(c, true),
                child: const Text('Hapus'),
              ),
            ],
          ),
    );
    if (ok == true) {
      await DatabaseService().deleteProduct(p.id!);
      _loadProducts();
    }
  }

  Future<void> _showAddStockDialog(Product p) async {
    final controller = TextEditingController(text: '1');
    final result = await showDialog<int>(
      context: context,
      builder:
          (c) => AlertDialog(
            title: const Text('Tambah Stok'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Produk: ${p.name}'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Jumlah yang akan ditambahkan',
                          hintText: 'Masukkan angka, misal 1',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      children: [
                        TextButton(
                          onPressed: () => controller.text = '1',
                          child: const Text('+1'),
                        ),
                        TextButton(
                          onPressed: () => controller.text = '5',
                          child: const Text('+5'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(c),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  final val = int.tryParse(controller.text) ?? 0;
                  Navigator.pop(c, val);
                },
                child: const Text('Tambah'),
              ),
            ],
          ),
    );

    if (result != null && result > 0) {
      final newStock = (p.stock) + result;
      final updated = Product(
        id: p.id,
        name: p.name,
        description: p.description,
        price: p.price,
        stock: newStock,
        sku: p.sku,
        image: p.image,
        createdAt: p.createdAt,
        category: p.category,
      );
      final ok = await DatabaseService().updateProduct(updated);
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Stok ${p.name} bertambah $result (sekarang $newStock)',
            ),
          ),
        );
        await _loadProducts();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gagal memperbarui stok')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manajemen Produk',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: _onAdd,
            icon: const Icon(Icons.add),
            color: Colors.white,
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _products.isEmpty
              ? const Center(
                child: Text(
                  'Belum ada produk. Tekan + untuk tambah.',
                  style: TextStyle(color: AppColors.lightText),
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxis =
                        constraints.maxWidth > 900
                            ? 4
                            : constraints.maxWidth > 600
                            ? 3
                            : 2;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxis,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.74,
                      ),
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final p = _products[index];
                        final imageRegex = RegExp(
                          r"\.(png|jpg|jpeg|gif|webp|bmp)",
                          caseSensitive: false,
                        );
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image / header
                              Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    topRight: Radius.circular(14),
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primaryGreen.withOpacity(0.12),
                                      AppColors.primaryGreen.withOpacity(0.06),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    topRight: Radius.circular(14),
                                  ),
                                  child:
                                      (p.image != null &&
                                              p.image!.isNotEmpty &&
                                              imageRegex.hasMatch(p.image!))
                                          ? Image.asset(
                                            p.image!,
                                            fit: BoxFit.contain,
                                            errorBuilder:
                                                (
                                                  context,
                                                  error,
                                                  stack,
                                                ) => Image.asset(
                                                  'assets/images/donatpolos.jpg',
                                                  fit: BoxFit.contain,
                                                ),
                                          )
                                          : Image.asset(
                                            'assets/images/donatpolos.jpg',
                                            fit: BoxFit.contain,
                                          ),
                                ),
                              ),
                              // Info
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 8.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      p.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Rp ${p.price.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryGreen,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                p.stock > 10
                                                    ? AppColors.primaryGreen
                                                        .withOpacity(0.08)
                                                    : Colors.red.withOpacity(
                                                      0.08,
                                                    ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            'Stok: ${p.stock}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  p.stock > 10
                                                      ? AppColors.primaryGreen
                                                      : Colors.red,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Actions
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 8.0,
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => _onEdit(p),
                                      icon: const Icon(Icons.edit, size: 18),
                                      color: AppColors.primaryGreen,
                                      tooltip: 'Edit',
                                    ),
                                    const SizedBox(width: 6),
                                    IconButton(
                                      onPressed: () => _onDelete(p),
                                      icon: const Icon(Icons.delete, size: 18),
                                      color: AppColors.error,
                                      tooltip: 'Hapus',
                                    ),
                                    const Spacer(),
                                    ElevatedButton(
                                      onPressed: () => _showAddStockDialog(p),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryGreen,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 10,
                                        ),
                                      ),
                                      child: const Text(
                                        'Tambah Stok',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
    );
  }
}
