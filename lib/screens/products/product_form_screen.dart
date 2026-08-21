import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../services/database_service.dart';
import '../../utils/app_colors.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class ProductFormScreen extends StatefulWidget {
  final Product? product;
  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameC;
  late TextEditingController _descC;
  late TextEditingController _priceC;
  late TextEditingController _stockC;
  late TextEditingController _skuC;
  bool _saving = false;
  List<String> _assetImages = [];
  String? _selectedImage;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameC = TextEditingController(text: p?.name ?? '');
    _descC = TextEditingController(text: p?.description ?? '');
    _priceC = TextEditingController(text: p != null ? p.price.toString() : '0');
    _stockC = TextEditingController(text: p != null ? p.stock.toString() : '0');
    _skuC = TextEditingController(text: p?.sku ?? '');
    _selectedCategory = p?.category ?? 'makanan';
    _loadAssetImages();
  }

  Future<void> _loadAssetImages() async {
    List<String> assets = [];
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      final imageRegex = RegExp(
        r"\.(png|jpg|jpeg|gif|webp|bmp)",
        caseSensitive: false,
      );
      assets = manifestMap.keys
          .where(
            (k) => k.startsWith('assets/images/') && imageRegex.hasMatch(k),
          )
          .toList(growable: false);
    } catch (e) {
      // Fallback: manually list images if manifest is unavailable (e.g., on web)
      assets = [
        'assets/images/cheffastbites.png',
        'assets/images/chefgt.png',
        'assets/images/donatblueberi.jpg',
        'assets/images/donatchocochip.jpg',
        'assets/images/donatcoklat.jpg',
        'assets/images/donatcoklatmelt.jpg',
        'assets/images/donatkacang.jpg',
        'assets/images/donatkeju.jpg',
        'assets/images/donatoreo.jpg',
        'assets/images/donatpolos.jpg',
        'assets/images/donatstroberi.jpg',
        'assets/images/donatvanilla.jpg',
        'assets/images/donutmatcha.jpg',
        'assets/images/FastbitesAdmin.png',
        'assets/images/FastbitesLoginAdmin.png',
        'assets/images/FastbitesRegisterAdmin.png',
        'assets/images/kopi-americano.jpg',
        'assets/images/kopi-cappucino.jpg',
        'assets/images/kopi-sspresso.jpg',
        'assets/images/loginfastbites.png',
        'assets/images/Pink Donut.jpg',
        'assets/images/Pink_Donut-removebg-preview.png',
        'assets/images/registerfastbites.png',
        'assets/images/tokologoresize.png',
      ];
    }
    final imageRegex = RegExp(
      r"\.(png|jpg|jpeg|gif|webp|bmp)",
      caseSensitive: false,
    );
    setState(() {
      _assetImages = assets;
      _selectedImage =
          widget.product?.image != null &&
                  imageRegex.hasMatch(widget.product!.image!)
              ? widget.product!.image
              : (assets.isNotEmpty ? assets.first : null);
    });
  }

  @override
  void dispose() {
    _nameC.dispose();
    _descC.dispose();
    _priceC.dispose();
    _stockC.dispose();
    _skuC.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final p = Product(
      id: widget.product?.id,
      name: _nameC.text.trim(),
      description: _descC.text.trim(),
      price: double.tryParse(_priceC.text) ?? 0.0,
      stock: int.tryParse(_stockC.text) ?? 0,
      sku: _skuC.text.trim(),
      image: _selectedImage,
      createdAt: widget.product?.createdAt ?? DateTime.now(),
      category: _selectedCategory ?? 'makanan',
    );

    final ok =
        widget.product == null
            ? await DatabaseService().createProduct(p)
            : await DatabaseService().updateProduct(p);

    setState(() => _saving = false);
    if (ok) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Produk' : 'Tambah Produk',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: Text(
              _saving ? 'Menyimpan...' : 'Simpan',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameC,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
                validator:
                    (v) =>
                        v == null || v.trim().isEmpty
                            ? 'Nama wajib diisi'
                            : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descC,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceC,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
                validator:
                    (v) =>
                        (double.tryParse(v ?? '') == null)
                            ? 'Harga tidak valid'
                            : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _stockC,
                decoration: const InputDecoration(labelText: 'Stok'),
                keyboardType: TextInputType.number,
                validator:
                    (v) =>
                        (int.tryParse(v ?? '') == null)
                            ? 'Stok tidak valid'
                            : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _skuC,
                decoration: const InputDecoration(labelText: 'SKU'),
              ),
              const SizedBox(height: 12),
              const Text(
                'Kategori',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory ?? 'makanan',
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'makanan',
                    child: Text('Makanan'),
                  ),
                  DropdownMenuItem(
                    value: 'minuman',
                    child: Text('Minuman'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              // Image selector from assets/images
              FutureBuilder<void>(
                future: Future.value(null),
                builder: (context, snap) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gambar (pilih dari assets)',
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String?>(
                        initialValue: _selectedImage,
                        items:
                            _assetImages
                                .map(
                                  (a) => DropdownMenuItem(
                                    value: a,
                                    child: Text(a.split('/').last),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) => setState(() => _selectedImage = v),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_selectedImage != null)
                        SizedBox(
                          height: 120,
                          child: Image.asset(
                            _selectedImage!,
                            fit: BoxFit.contain,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
