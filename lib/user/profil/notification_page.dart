import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _orderNotifications = true;
  bool _promotionNotifications = false;
  bool _pushNotifications = true;
  bool _emailNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header section with red background
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFFF5962),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // App bar
                    Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            'Pengaturan Notifikasi',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48), // Balance the back button
                      ],
                    ),
                    const SizedBox(height: 32),
                    // App icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications,
                        color: Color(0xFFFF5962),
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // App name
                    const Text(
                      'Notifikasi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Version
                    const Text(
                      'Atur Notifikasi',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          // Content section
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Notification section
                _buildSectionHeader(
                  icon: Icons.info_outline,
                  title: 'Notifikasi Pesanan',
                  color: const Color(0xFFFF5962),
                ),
                const SizedBox(height: 16),
                _buildNotificationItem(
                  title: 'Notifikasi Pesanan',
                  subtitle: 'Terima notifikasi tentang status pesanan Anda',
                  value: _orderNotifications,
                  onChanged: (value) {
                    setState(() {
                      _orderNotifications = value;
                    });
                  },
                ),
                _buildNotificationItem(
                  title: 'Notifikasi Promosi',
                  subtitle:
                      'Terima notifikasi tentang promo dan penawaran khusus',
                  value: _promotionNotifications,
                  onChanged: (value) {
                    setState(() {
                      _promotionNotifications = value;
                    });
                  },
                ),
                const SizedBox(height: 24),
                // General settings section
                _buildSectionHeader(
                  icon: Icons.star_outline,
                  title: 'Notifikasi Umum',
                  color: const Color(0xFFFF5962),
                ),
                const SizedBox(height: 16),
                _buildNotificationItem(
                  title: 'Notifikasi Push',
                  subtitle: 'Terima notifikasi push di perangkat Anda',
                  value: _pushNotifications,
                  onChanged: (value) {
                    setState(() {
                      _pushNotifications = value;
                    });
                  },
                ),
                _buildNotificationItem(
                  title: 'Notifikasi Email',
                  subtitle: 'Terima notifikasi melalui email',
                  value: _emailNotifications,
                  onChanged: (value) {
                    setState(() {
                      _emailNotifications = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: const Color(0xFFFF5962),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
