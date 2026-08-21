import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import '../../models/store.dart';
import '../../services/database_service.dart';
import '../../utils/app_colors.dart';

class UpdateProfileScreen extends StatefulWidget {
  final Store? store;
  const UpdateProfileScreen({super.key, this.store});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameC;
  late TextEditingController _descC;
  late TextEditingController _categoryC;
  late TextEditingController _locationC;
  late TextEditingController _hoursC;
  late TextEditingController _phoneC;
  late TextEditingController _emailC;

  bool _loading = true;
  bool _saving = false;

  List<String> _assetImages = [];
  String? _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameC = TextEditingController(text: widget.store?.name ?? '');
    _descC = TextEditingController(text: widget.store?.description ?? '');
    _categoryC = TextEditingController(text: widget.store?.category ?? '');
    _locationC = TextEditingController(text: widget.store?.location ?? '');
    _hoursC = TextEditingController(text: widget.store?.openingHours ?? '');
    _phoneC = TextEditingController(text: widget.store?.phone ?? '');
    _emailC = TextEditingController(text: widget.store?.email ?? '');
    _selectedImage = widget.store?.logo;
    _loadAssetImages();
    setState(() => _loading = false);
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
    setState(() {
      _assetImages = assets;
      if (_selectedImage == null && _assetImages.isNotEmpty) {
        _selectedImage = _assetImages.first;
      }
    });
  }

  @override
  void dispose() {
    _nameC.dispose();
    _descC.dispose();
    _categoryC.dispose();
    _locationC.dispose();
    _hoursC.dispose();
    _phoneC.dispose();
    _emailC.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final store = Store(
      id: widget.store?.id,
      name: _nameC.text.trim(),
      description: _descC.text.trim(),
      category: _categoryC.text.trim(),
      location: _locationC.text.trim(),
      openingHours: _hoursC.text.trim(),
      logo: _selectedImage,
      phone: _phoneC.text.trim(),
      email: _emailC.text.trim(),
      updatedAt: DateTime.now(),
    );

    final ok = await DatabaseService().saveStore(store);
    setState(() => _saving = false);
    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan informasi toko')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Profil Toko',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // Image preview + selector
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        width: 110,
                                        height: 110,
                                        color: Colors.grey[100],
                                        child:
                                            _selectedImage != null
                                                ? Image.asset(
                                                  _selectedImage!,
                                                  fit: BoxFit.contain,
                                                )
                                                : const Icon(
                                                  Icons.storefront,
                                                  size: 48,
                                                  color: AppColors.primaryGreen,
                                                ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Logo / Banner',
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
                                                        child: Text(
                                                          a.split('/').last,
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                            onChanged:
                                                (v) => setState(
                                                  () => _selectedImage = v,
                                                ),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Form fields
                                TextFormField(
                                  controller: _nameC,
                                  decoration: InputDecoration(
                                    labelText: 'Nama Toko',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  validator:
                                      (v) =>
                                          v == null || v.trim().isEmpty
                                              ? 'Nama toko wajib diisi'
                                              : null,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _descC,
                                  decoration: InputDecoration(
                                    labelText: 'Deskripsi Toko',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  maxLines: 4,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _categoryC,
                                  decoration: InputDecoration(
                                    labelText: 'Kategori Toko',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _locationC,
                                  decoration: InputDecoration(
                                    labelText: 'Lokasi Toko',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _hoursC,
                                  decoration: InputDecoration(
                                    labelText:
                                        'Jam Buka (contoh: 08:00 - 21:00)',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _phoneC,
                                  decoration: InputDecoration(
                                    labelText: 'Nomor Telepon',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _emailC,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return null;
                                    }
                                    final emailRegex = RegExp(
                                      r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}",
                                    );
                                    return emailRegex.hasMatch(v)
                                        ? null
                                        : 'Email tidak valid';
                                  },
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            onPressed: _saving ? null : _save,
            child: Text(
              _saving ? 'Menyimpan...' : 'Simpan Informasi Toko',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
