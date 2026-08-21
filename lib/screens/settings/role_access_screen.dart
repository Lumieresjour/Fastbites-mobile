import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../services/role_service.dart';
import '../../models/role.dart';

class RoleAccessScreen extends StatefulWidget {
  const RoleAccessScreen({super.key});

  @override
  State<RoleAccessScreen> createState() => _RoleAccessScreenState();
}

class _RoleAccessScreenState extends State<RoleAccessScreen> {
  final RoleService _roleService = RoleService();
  List<Map<String, dynamic>> roles = [];
  bool _loading = true;

  // permissions master list used in dialogs
  final List<String> _allPermissions = [
    'Kelola Produk',
    'Kelola Pesanan',
    'Kelola Pembayaran',
    'Kelola Admin',
    'Kelola Pengaturan',
    'Lihat Laporan',
    'Kelola Promosi',
    'Kelola Review',
    'Kelola Mitra',
  ];
  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    setState(() {
      _loading = true;
    });
    final list = await _roleService.getAllRoles();
    if (list.isEmpty) {
      await _seedDefaultRoles();
    }
    final refreshed = await _roleService.getAllRoles();
    setState(() {
      roles = _roleService.rolesToUiMaps(refreshed);
      _loading = false;
    });
  }

  Future<void> _seedDefaultRoles() async {
    final defaults = [
      Role(
        name: 'Super Admin',
        description: 'Akses penuh ke semua fitur sistem',
        colorHex: '#D32F2F',
        permissions: _allPermissions,
        userCount: 1,
      ),
      Role(
        name: 'Admin',
        description: 'Akses ke manajemen konten dan pesanan',
        colorHex: '#1976D2',
        permissions: [
          'Kelola Produk',
          'Kelola Pesanan',
          'Kelola Pembayaran',
          'Lihat Laporan',
          'Kelola Promosi',
          'Kelola Review',
        ],
        userCount: 3,
      ),
      Role(
        name: 'Moderator',
        description: 'Akses untuk moderasi konten',
        colorHex: '#F57C00',
        permissions: [
          'Lihat Produk',
          'Lihat Pesanan',
          'Kelola Review',
          'Lihat Laporan',
        ],
        userCount: 2,
      ),
      Role(
        name: 'Viewer',
        description: 'Hanya dapat melihat laporan dan data',
        colorHex: '#388E3C',
        permissions: ['Lihat Produk', 'Lihat Pesanan', 'Lihat Laporan'],
        userCount: 0,
      ),
    ];
    for (final r in defaults) {
      await _roleService.createRole(r);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kelola Role & Akses',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightGreen.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primaryGreen, width: 1),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primaryGreen,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Kelola role dan izin akses admin',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Daftar Roles
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: roles.length,
              itemBuilder: (context, index) {
                final role = roles[index];
                return _buildRoleCard(role);
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showAddRoleDialog();
        },
        backgroundColor: AppColors.primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildRoleCard(Map<String, dynamic> role) {
    return GestureDetector(
      onTap: () {
        _showRoleDetailsModal(role);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: (role['color'] as Color).withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: (role['color'] as Color).withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: role['color'],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        role['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: (role['color'] as Color).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${role['userCount']} users',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: role['color'],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                role['description'],
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),

              // Permissions preview
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  ...(role['permissions'] as List<String>)
                      .take(3)
                      .map(
                        (permission) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: (role['color'] as Color).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: (role['color'] as Color).withOpacity(0.3),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            permission,
                            style: TextStyle(
                              fontSize: 11,
                              color: role['color'],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  if ((role['permissions'] as List<String>).length > 3)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '+${(role['permissions'] as List<String>).length - 3} lainnya',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Action button
              SizedBox(
                width: double.infinity,
                height: 36,
                child: OutlinedButton(
                  onPressed: () {
                    _showRoleDetailsModal(role);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: role['color'], width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    'Lihat Detail',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: role['color'],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRoleDetailsModal(Map<String, dynamic> role) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.7,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            builder:
                (context, scrollController) => SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: role['color'],
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  role['name'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(Icons.close, size: 24),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          role['description'],
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Permissions
                        Text(
                          'Daftar Izin Akses (${(role['permissions'] as List<String>).length})',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...(role['permissions'] as List<String>).map(
                          (permission) => Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: role['color'],
                                  size: 18,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    permission,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Stats
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: (role['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '${role['userCount']}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: role['color'],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Admin',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: (role['color'] as Color).withOpacity(
                                  0.3,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    '${(role['permissions'] as List<String>).length}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: role['color'],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Izin',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Action Buttons
                        if (role['name'] != 'Super Admin') ...[
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await _showEditRoleDialog(role);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: role['color'],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Edit Izin Akses',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: OutlinedButton(
                              onPressed: () async {
                                await _confirmDelete(role);
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.red, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Hapus Role',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.blue[300]!,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.lock,
                                  color: Colors.blue[700],
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Role Super Admin tidak dapat diubah',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
          ),
    );
  }

  Future<void> _showEditRoleDialog(Map<String, dynamic> role) async {
    final nameCtl = TextEditingController(text: role['name'] ?? '');
    final descCtl = TextEditingController(text: role['description'] ?? '');
    final selected = Set<String>.from(
      (role['permissions'] as List).cast<String>(),
    );
    String colorHex = (role['colorHex'] as String?) ?? '#9E9E9E';

    await showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Role'),
            content: StatefulBuilder(
              builder:
                  (context, setStateLocal) => SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameCtl,
                          decoration: const InputDecoration(
                            labelText: 'Nama Role',
                          ),
                        ),
                        TextField(
                          controller: descCtl,
                          decoration: const InputDecoration(
                            labelText: 'Deskripsi',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children:
                              _allPermissions.map((p) {
                                final v = selected.contains(p);
                                return FilterChip(
                                  label: Text(
                                    p,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  selected: v,
                                  onSelected: (s) {
                                    setStateLocal(() {
                                      if (s) {
                                        selected.add(p);
                                      } else {
                                        selected.remove(p);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                        ),

                        const SizedBox(height: 12),
                        // Color palette selection
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pilih Warna Role',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  [
                                    // list of preset hex colors
                                    '#D32F2F',
                                    '#1976D2',
                                    '#F57C00',
                                    '#388E3C',
                                    '#7B1FA2',
                                    '#FF7043',
                                    '#009688',
                                    '#607D8B',
                                  ].map((hex) {
                                    final col = Color(
                                      int.parse(hex.replaceFirst('#', '0xff')),
                                    );
                                    final isSelected = colorHex == hex;
                                    return GestureDetector(
                                      onTap:
                                          () => setStateLocal(
                                            () => colorHex = hex,
                                          ),
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: col,
                                          shape: BoxShape.circle,
                                          border:
                                              isSelected
                                                  ? Border.all(
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                    width: 2,
                                                  )
                                                  : Border.all(
                                                    color: Colors.transparent,
                                                    width: 2,
                                                  ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final updated = Role(
                    id: role['id'] as int?,
                    name: nameCtl.text.trim(),
                    description: descCtl.text.trim(),
                    colorHex: colorHex,
                    permissions: selected.toList(),
                  );
                  final ok = await _roleService.updateRole(updated);
                  if (ok) {
                    Navigator.pop(context);
                    await _loadRoles();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gagal menyimpan')),
                    );
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
    );
  }

  Future<void> _confirmDelete(Map<String, dynamic> role) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (c) => AlertDialog(
            title: const Text('Konfirmasi Hapus'),
            content: Text('Hapus role "${role['name']}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(c, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(c, true),
                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
    if (confirm == true) {
      final id = role['id'] as int?;
      if (id != null) {
        final ok = await _roleService.deleteRole(id);
        if (ok) await _loadRoles();
      }
      Navigator.pop(context); // close details modal
    }
  }

  Future<void> _showAddRoleDialog() async {
    final nameCtl = TextEditingController();
    final descCtl = TextEditingController();
    final selected = <String>{};
    String colorHex = '#9E9E9E';

    await showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Tambah Role Baru'),
            content: SizedBox(
              width: double.maxFinite,
              child: StatefulBuilder(
                builder:
                    (context, setStateLocal) => SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: nameCtl,
                            decoration: const InputDecoration(
                              labelText: 'Nama Role',
                            ),
                          ),
                          TextField(
                            controller: descCtl,
                            decoration: const InputDecoration(
                              labelText: 'Deskripsi',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            children:
                                _allPermissions
                                    .map(
                                      (p) => FilterChip(
                                        label: Text(
                                          p,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        selected: selected.contains(p),
                                        onSelected: (s) {
                                          setStateLocal(() {
                                            if (s) {
                                              selected.add(p);
                                            } else {
                                              selected.remove(p);
                                            }
                                          });
                                        },
                                      ),
                                    )
                                    .toList(),
                          ),
                          const SizedBox(height: 12),
                          // Color palette selection for Add Role
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pilih Warna Role',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children:
                                    [
                                      '#D32F2F',
                                      '#1976D2',
                                      '#F57C00',
                                      '#388E3C',
                                      '#7B1FA2',
                                      '#FF7043',
                                      '#009688',
                                      '#607D8B',
                                    ].map((hex) {
                                      final col = Color(
                                        int.parse(
                                          hex.replaceFirst('#', '0xff'),
                                        ),
                                      );
                                      final isSelected = colorHex == hex;
                                      return GestureDetector(
                                        onTap:
                                            () => setStateLocal(
                                              () => colorHex = hex,
                                            ),
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: col,
                                            shape: BoxShape.circle,
                                            border:
                                                isSelected
                                                    ? Border.all(
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                      width: 2,
                                                    )
                                                    : Border.all(
                                                      color: Colors.transparent,
                                                      width: 2,
                                                    ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final r = Role(
                    name: nameCtl.text.trim(),
                    description: descCtl.text.trim(),
                    colorHex: colorHex,
                    permissions: selected.toList(),
                  );
                  final ok = await _roleService.createRole(r);
                  if (ok) {
                    Navigator.pop(context);
                    await _loadRoles();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gagal membuat role')),
                    );
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
    );
  }
}
