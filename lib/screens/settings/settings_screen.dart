import 'package:flutter/material.dart';

import '../../models/settings.dart';
import '../../services/database_service.dart';
import '../../utils/app_colors.dart';
import 'terms_conditions_screen.dart';
import 'privacy_policy_screen.dart';
import 'change_password_screen.dart';
import 'role_access_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _loading = true;
  Settings? _settings;
  // New granular notification toggles
  bool _notifOrderNew = true;
  bool _notifLowStock = true;
  bool _notifOrderCancelled = true;
  bool _notifPaymentSuccess = true;
  bool _notifNewReview = true;

  @override
  void initState() {
    super.initState();
    _ensureSettings();
  }

  Future<void> _ensureSettings() async {
    setState(() => _loading = true);
    var s = await DatabaseService().getSettings();
    if (s == null) {
      final defaultSettings = Settings(
        appName: 'Fastbites Admin',
        appLogo: 'assets/images/FastbitesAdmin.png',
        appDescription:
            'Fastbites Merupakan Platform penjualan makanan sisa berkualitas dengan harga terjangkau, dan masih layak di konsumsi',
        supportEmail: 'fastbites@gmail.com',
        whatsappNumber: '0812-3456-7890',
        socialMediaLinks: {
          'instagram': '@fastbites_id',
          'facebook': 'fastbites.id',
        },
        termsAndConditions:
            'Terms & Conditions - Silakan baca kebijakan layanan kami dengan seksama...',
        privacyPolicy:
            'Kebijakan Privasi - Data pribadi Anda dilindungi sesuai regulasi...',
        notificationEnabled: true,
        updatedAt: DateTime.now(),
      );
      await DatabaseService().saveSettings(defaultSettings);
      s = defaultSettings;
    }
    _settings = s;
    // initialize granular toggles from existing setting (fallback)
    _notifOrderNew = s.notificationEnabled;
    _notifLowStock = s.notificationEnabled;
    _notifOrderCancelled = s.notificationEnabled;
    _notifPaymentSuccess = s.notificationEnabled;
    _notifNewReview = s.notificationEnabled;
    setState(() => _loading = false);
  }

  Future<void> _saveNotificationPrefs() async {
    // Persist a combined flag into the existing settings.notificationEnabled field
    final anyEnabled =
        _notifOrderNew ||
        _notifLowStock ||
        _notifOrderCancelled ||
        _notifPaymentSuccess ||
        _notifNewReview;
    if (_settings != null) {
      final updated = Settings(
        appName: _settings!.appName,
        appLogo: _settings!.appLogo,
        appDescription: _settings!.appDescription,
        supportEmail: _settings!.supportEmail,
        whatsappNumber: _settings!.whatsappNumber,
        socialMediaLinks: _settings!.socialMediaLinks,
        termsAndConditions: _settings!.termsAndConditions,
        privacyPolicy: _settings!.privacyPolicy,
        notificationEnabled: anyEnabled,
        updatedAt: DateTime.now(),
      );
      await DatabaseService().saveSettings(updated);
      _settings = updated;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengaturan Platform',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
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
                      child: ListView(
                        children: [
                          // 1. Nama Aplikasi + Logo
                          _sectionHeader('Tentang Aplikasi'),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (_settings?.appLogo != null)
                                    Image.asset(
                                      _settings!.appLogo!,
                                      width: 160,
                                      height: 160,
                                      fit: BoxFit.contain,
                                    )
                                  else
                                    Container(
                                      width: 160,
                                      height: 160,
                                      decoration: BoxDecoration(
                                        color: AppColors.lightGreen,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.apps,
                                        size: 48,
                                        color: AppColors.primaryGreen,
                                      ),
                                    ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _settings?.appName ?? '-',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _settings?.appDescription ?? '-',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 2. Kontak & Informasi Operasional
                          _sectionHeader('Kontak & Informasi'),
                          _settingsTile(
                            Icons.email,
                            'Email Support',
                            _settings?.supportEmail ?? '-',
                            null,
                          ),
                          _settingsTile(
                            Icons.phone,
                            'WhatsApp',
                            _settings?.whatsappNumber ?? '-',
                            null,
                          ),
                          if (_settings?.socialMediaLinks != null &&
                              _settings!.socialMediaLinks!.isNotEmpty)
                            ..._settings!.socialMediaLinks!.entries.map(
                              (e) => _settingsTile(
                                Icons.language,
                                e.key.capitalize(),
                                e.value,
                                null,
                              ),
                            ),
                          const SizedBox(height: 20),

                          // 3. Notifikasi
                          _sectionHeader('Notifikasi'),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 1,
                            child: Column(
                              children: [
                                SwitchListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  title: const Text(
                                    'Pesanan Baru',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: const Text(
                                    'Terima notifikasi ketika ada pesanan baru',
                                  ),
                                  value: _notifOrderNew,
                                  onChanged: (v) async {
                                    setState(() => _notifOrderNew = v);
                                    await _saveNotificationPrefs();
                                  },
                                  activeThumbColor: AppColors.primaryGreen,
                                ),
                                const Divider(height: 1),
                                SwitchListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  title: const Text(
                                    'Stok Menipis',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: const Text(
                                    'Peringatan ketika stok produk rendah',
                                  ),
                                  value: _notifLowStock,
                                  onChanged: (v) async {
                                    setState(() => _notifLowStock = v);
                                    await _saveNotificationPrefs();
                                  },
                                  activeThumbColor: AppColors.primaryGreen,
                                ),
                                const Divider(height: 1),
                                SwitchListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  title: const Text(
                                    'Pesanan Dibatalkan',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: const Text(
                                    'Terima notifikasi jika pesanan dibatalkan',
                                  ),
                                  value: _notifOrderCancelled,
                                  onChanged: (v) async {
                                    setState(() => _notifOrderCancelled = v);
                                    await _saveNotificationPrefs();
                                  },
                                  activeThumbColor: AppColors.primaryGreen,
                                ),
                                const Divider(height: 1),
                                SwitchListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  title: const Text(
                                    'Pembayaran Berhasil',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: const Text(
                                    'Terima notifikasi saat pembayaran berhasil',
                                  ),
                                  value: _notifPaymentSuccess,
                                  onChanged: (v) async {
                                    setState(() => _notifPaymentSuccess = v);
                                    await _saveNotificationPrefs();
                                  },
                                  activeThumbColor: AppColors.primaryGreen,
                                ),
                                const Divider(height: 1),
                                SwitchListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  title: const Text(
                                    'Ulasan / Rating Baru',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: const Text(
                                    'Terima notifikasi saat ada ulasan atau rating baru',
                                  ),
                                  value: _notifNewReview,
                                  onChanged: (v) async {
                                    setState(() => _notifNewReview = v);
                                    await _saveNotificationPrefs();
                                  },
                                  activeThumbColor: AppColors.primaryGreen,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 4. Aturan Produk/Pesanan
                          _sectionHeader('Aturan Produk/Pesanan'),
                          _settingsTile(
                            Icons.rule,
                            'Terms & Conditions',
                            'Lihat kebijakan',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          const TermsAndConditionsScreen(),
                                ),
                              );
                            },
                          ),
                          _settingsTile(
                            Icons.privacy_tip,
                            'Kebijakan Privasi',
                            'Lihat kebijakan',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const PrivacyPolicyScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),

                          // Tema/Tampilan Dasar removed

                          // 6. Keamanan Admin
                          _sectionHeader('Keamanan Admin'),
                          _settingsTile(
                            Icons.lock,
                            'Ubah Password',
                            'Kelola password akun',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const ChangePasswordScreen(),
                                ),
                              );
                            },
                          ),
                          _settingsTile(
                            Icons.person,
                            'Role & Akses',
                            'Kelola role admin',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const RoleAccessScreen(),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
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

  Widget _settingsTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback? onTap,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: AppColors.lightGreen,
          child: Icon(icon, color: AppColors.primaryGreen, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        onTap: onTap,
        trailing:
            onTap != null
                ? const Icon(Icons.chevron_right, color: Colors.black38)
                : null,
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
