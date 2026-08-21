import 'package:flutter/material.dart';

import '../../models/store.dart';
import '../../services/database_service.dart';
import '../../utils/app_colors.dart';
import 'update_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loading = true;
  Store? _store;

  @override
  void initState() {
    super.initState();
    _ensureStore();
  }

  Future<void> _ensureStore() async {
    setState(() => _loading = true);
    final s = await DatabaseService().getStore();
    if (s == null) {
      // create default pre-filled store as requested
      final defaultStore = Store(
        name: 'DonatLicious',
        description:
            'Toko donat rumahan yang menyajikan donat lembut, manis, dan selalu fresh setiap hari. Dibuat dari bahan pilihan dengan berbagai topping favorit untuk semua kalangan.',
        category: 'Makanan & Minuman',
        location: 'Jl. Cut Mutia No 19, Kota Bekasi',
        openingHours: '08:00 – 21:00',
        phone: '0812-3456-7890',
        email: 'donatlicious@gmail.com',
        logo: null,
        updatedAt: DateTime.now(),
      );
      await DatabaseService().saveStore(defaultStore);
      _store = defaultStore;
    } else {
      _store = s;
    }
    setState(() => _loading = false);
  }

  Future<void> _openUpdate() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => UpdateProfileScreen(store: _store)),
    );
    if (result == true) {
      // refresh
      await _ensureStore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Toko', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  children: [
                    // Header with gradient and avatar
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryGreen,
                            AppColors.primaryGreen.withOpacity(0.85),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(18),
                          bottomRight: Radius.circular(18),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 16),
                            width: 88,
                            height: 88,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.lightGreen,
                            ),
                            child: ClipOval(
                              child:
                                  _store?.logo != null
                                      ? Image.asset(
                                        _store!.logo!,
                                        fit: BoxFit.contain,
                                        width: 88,
                                        height: 88,
                                      )
                                      : Image.asset(
                                        'assets/images/tokologoresize.png',
                                        fit: BoxFit.contain,
                                        width: 88,
                                        height: 88,
                                      ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _store?.name ?? '-',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _store?.category ?? '-',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Description card
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            _store?.description ?? '-',
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ),
                      ),
                    ),
                    // Info list
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          _infoTile(
                            Icons.location_on,
                            'Lokasi',
                            _store?.location,
                          ),
                          _infoTile(
                            Icons.schedule,
                            'Jam Buka',
                            _store?.openingHours,
                          ),
                          _infoTile(Icons.phone, 'Telepon', _store?.phone),
                          _infoTile(Icons.email, 'Email', _store?.email),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: SizedBox(
          height: 56,
          child: ElevatedButton.icon(
            onPressed: _openUpdate,
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text(
              'Update Profile',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String? value) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      leading: CircleAvatar(
        backgroundColor: AppColors.lightGreen,
        child: Icon(icon, color: AppColors.primaryGreen),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        value ?? '-',
        style: const TextStyle(color: Colors.black87),
      ),
    );
  }
}
