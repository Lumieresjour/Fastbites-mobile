import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import '../../models/settings.dart';
import '../../services/database_service.dart';
import '../../utils/app_colors.dart';

class UpdateSettingsScreen extends StatefulWidget {
  final Settings? settings;
  const UpdateSettingsScreen({super.key, this.settings});

  @override
  State<UpdateSettingsScreen> createState() => _UpdateSettingsScreenState();
}

class _UpdateSettingsScreenState extends State<UpdateSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _appNameC;
  late TextEditingController _appDescC;
  late TextEditingController _emailC;
  late TextEditingController _whatsappC;
  late TextEditingController _instagramC;
  late TextEditingController _facebookC;
  late TextEditingController _termsC;
  late TextEditingController _privacyC;

  bool _loading = true;
  bool _saving = false;
  bool _notificationEnabled = true;

  List<String> _assetImages = [];
  String? _selectedImage;

  @override
  void initState() {
    super.initState();
    _appNameC = TextEditingController(text: widget.settings?.appName ?? '');
    _appDescC = TextEditingController(
      text: widget.settings?.appDescription ?? '',
    );
    _emailC = TextEditingController(text: widget.settings?.supportEmail ?? '');
    _whatsappC = TextEditingController(
      text: widget.settings?.whatsappNumber ?? '',
    );
    _instagramC = TextEditingController(
      text: widget.settings?.socialMediaLinks?['instagram'] ?? '',
    );
    _facebookC = TextEditingController(
      text: widget.settings?.socialMediaLinks?['facebook'] ?? '',
    );
    _termsC = TextEditingController(
      text: widget.settings?.termsAndConditions ?? '',
    );
    _privacyC = TextEditingController(
      text: widget.settings?.privacyPolicy ?? '',
    );
    _notificationEnabled = widget.settings?.notificationEnabled ?? true;
    _selectedImage = widget.settings?.appLogo;
    _initAssets();
  }

  Future<void> _initAssets() async {
    List<String> images = [];
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      images =
          manifestMap.keys
              .where((String key) => key.contains('assets/images/'))
              .toList();
    } catch (e) {
      // Fallback: manually list images if manifest is unavailable (e.g., on web)
      images = [
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
      _assetImages = images;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _appNameC.dispose();
    _appDescC.dispose();
    _emailC.dispose();
    _whatsappC.dispose();
    _instagramC.dispose();
    _facebookC.dispose();
    _termsC.dispose();
    _privacyC.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _saving = true);
      try {
        final updatedSettings = Settings(
          appName: _appNameC.text,
          appLogo: _selectedImage,
          appDescription: _appDescC.text,
          supportEmail: _emailC.text,
          whatsappNumber: _whatsappC.text,
          socialMediaLinks: {
            'instagram': _instagramC.text,
            'facebook': _facebookC.text,
          },
          termsAndConditions: _termsC.text,
          privacyPolicy: _privacyC.text,
          notificationEnabled: _notificationEnabled,
          updatedAt: DateTime.now(),
        );
        await DatabaseService().saveSettings(updatedSettings);
        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      } finally {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Pengaturan Platform'),
        backgroundColor: AppColors.primaryGreen,
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          children: [
                            // 1. Nama Aplikasi + Logo
                            _sectionHeader('1. Aplikasi'),
                            const SizedBox(height: 12),
                            _buildInputField(
                              controller: _appNameC,
                              label: 'Nama Aplikasi',
                              hint: 'Masukkan nama aplikasi',
                              icon: Icons.apps,
                            ),
                            const SizedBox(height: 16),
                            _buildInputField(
                              controller: _appDescC,
                              label: 'Deskripsi Aplikasi',
                              hint: 'Masukkan deskripsi aplikasi',
                              icon: Icons.description,
                              maxLines: 3,
                            ),
                            const SizedBox(height: 16),
                            _buildLogoDropdown(),
                            const SizedBox(height: 24),

                            // 2. Kontak & Informasi Operasional
                            _sectionHeader('2. Kontak & Informasi Operasional'),
                            const SizedBox(height: 12),
                            _buildInputField(
                              controller: _emailC,
                              label: 'Email Support',
                              hint: 'Masukkan email support',
                              icon: Icons.email,
                            ),
                            const SizedBox(height: 16),
                            _buildInputField(
                              controller: _whatsappC,
                              label: 'WhatsApp',
                              hint: 'Masukkan nomor WhatsApp',
                              icon: Icons.phone,
                            ),
                            const SizedBox(height: 16),
                            _buildInputField(
                              controller: _instagramC,
                              label: 'Instagram',
                              hint: 'Masukkan @username',
                              icon: Icons.camera_alt,
                            ),
                            const SizedBox(height: 16),
                            _buildInputField(
                              controller: _facebookC,
                              label: 'Facebook',
                              hint: 'Masukkan username/url Facebook',
                              icon: Icons.language,
                            ),
                            const SizedBox(height: 24),

                            // 3. Notifikasi
                            _sectionHeader('3. Notifikasi'),
                            const SizedBox(height: 12),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 1,
                              child: SwitchListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                title: const Text(
                                  'Notifikasi Pesanan',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: const Text(
                                  'Aktifkan untuk menerima notifikasi pesanan masuk',
                                ),
                                value: _notificationEnabled,
                                onChanged: (bool val) {
                                  setState(() => _notificationEnabled = val);
                                },
                                activeThumbColor: AppColors.primaryGreen,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // 4. Aturan Produk/Pesanan
                            _sectionHeader('4. Aturan Produk/Pesanan'),
                            const SizedBox(height: 12),
                            _buildInputField(
                              controller: _termsC,
                              label: 'Terms & Conditions',
                              hint: 'Masukkan syarat dan ketentuan',
                              icon: Icons.rule,
                              maxLines: 3,
                            ),
                            const SizedBox(height: 16),
                            _buildInputField(
                              controller: _privacyC,
                              label: 'Kebijakan Privasi',
                              hint: 'Masukkan kebijakan privasi',
                              icon: Icons.privacy_tip,
                              maxLines: 3,
                            ),
                            const SizedBox(height: 24),

                            // 5. Tema/Tampilan Dasar
                            _sectionHeader('5. Tema/Tampilan Dasar'),
                            const SizedBox(height: 12),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Tema Aplikasi',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Hijau & Putih',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryGreen,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // 6. Keamanan Admin
                            _sectionHeader('6. Keamanan Admin'),
                            const SizedBox(height: 12),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 1,
                              child: const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Ubah Password',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Fitur sedang dalam pengembangan',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.lock,
                                          color: AppColors.primaryGreen,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 1,
                              child: const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Role & Akses',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Fitur sedang dalam pengembangan',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.person,
                                          color: AppColors.primaryGreen,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _saving ? Colors.grey : AppColors.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            onPressed: _saving ? null : _saveSettings,
            icon:
                _saving
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Icon(Icons.save),
            label: Text(
              _saving ? 'Menyimpan...' : 'Simpan Pengaturan',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primaryGreen),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightGreen, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _buildLogoDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedImage,
      items: [
        const DropdownMenuItem(value: null, child: Text('Pilih Logo Aplikasi')),
        ..._assetImages.map(
          (img) => DropdownMenuItem(
            value: img,
            child: Row(
              children: [
                Image.asset(img, width: 30, height: 30),
                const SizedBox(width: 10),
                Text(img.split('/').last),
              ],
            ),
          ),
        ),
      ],
      onChanged: (value) {
        setState(() => _selectedImage = value);
      },
      decoration: InputDecoration(
        labelText: 'Logo Aplikasi',
        hintText: 'Pilih logo aplikasi',
        prefixIcon: const Icon(Icons.image, color: AppColors.primaryGreen),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightGreen, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
