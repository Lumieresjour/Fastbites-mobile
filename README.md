# 🍔 FastBites - Mobile Food Ordering App


<p align="center">
  <b>Aplikasi Pemesanan Makanan Mobile Berbasis Flutter & Dart</b><br>
  Dilengkapi dengan Multi-Role System (Admin & Pelanggan) serta Integrasi REST API (MockAPI) untuk Registrasi & Manajemen Pengguna.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"/>
  <img src="https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite"/>
  <img src="https://img.shields.io/badge/MockAPI-REST_API-orange?style=for-the-badge" alt="MockAPI"/>
</p>

---

## 📌 Tentang Aplikasi

**FastBites** adalah aplikasi mobile pemesanan makanan cepat saji yang dirancang untuk memberikan pengalaman intuitif bagi pelanggan serta pengelolaan operasional yang lengkap bagi pihak admin/restoran. Aplikasi ini menerapkan pemisahan hak akses dinamis (Dual-Role Auth) dari satu pintu login yang sama.

---

## ✨ Fitur Utama

### 👨‍💼 Sisi Admin
- **Dashboard Admin:** Ringkasan statistik penjualan, pesanan, jumlah produk, dan komisi pendapatan.
- **Manajemen Produk:** Tambah, ubah, hapus, dan atur katalog menu (kategori makanan/minuman, harga, deskripsi, stok).
- **Manajemen Pesanan:** Pantau status order dan pengiriman pelanggan secara *real-time*.
- **Kelola Promo & Diskon:** Manajemen kupon promosi aplikasi.
- **Ulasan & Penilaian:** Pantau kepuasan dan rating pelanggan terhadap menu.

### 👤 Sisi Pelanggan (User)
- **Beranda & Eksplorasi Menu:** Tampilan daftar menu makanan dan minuman terintegrasi dengan filter kategori & pencarian (*search*).
- **Pemesanan (*Order*):** Pengelolaan keranjang belanja, proses *checkout*, dan ringkasan riwayat pesanan.
- **Manajemen Profil:** Edit identitas profil, kelola alamat pengiriman, metode pembayaran, serta daftar menu favorit.
- **Multi-Tab Navigation:** Navigasi cepat melalui bottom bar (Beranda, Order, Profil).

---

## 🔐 Sistem Otentikasi & Integrasi API

### 1. Dual-Role Routing (Smart Login)
Sistem secara otomatis mendeteksi peran pengguna saat melakukan login:
* **Admin:** Mengarahkan akun admin (contoh: `admin@gmail.com`) langsung ke halaman **Admin Dashboard** (`/home`).
* **Pelanggan:** Akun pelanggan biasa diarahkan ke halaman utama pelanggan **MainPage** (`/user_main`).
* **Unified Logout:** Logout dari sisi admin maupun user akan mengembalikan pengguna secara aman ke layar utama `LoginScreen`.

### 2. Integrasi MockAPI & SQLite Database
* **Registrasi User (MockAPI):** Proses registrasi pengguna baru terintegrasi secara modular dengan RESTful API (MockAPI) untuk pencatatan dan sinkronisasi data *cloud*.
* **Local Database (SQLite/sqflite):** Penyimpanan lokal relasional untuk performa cepat dan *offline capability* pada mobile, dengan dukungan *web fallback*.

---

## 📱 Struktur Direktori Proyek

```text
lib/
├── helpers/              # Database helper & konfigurasi SQLite
├── models/               # Model data (User, Admin, Product, Order, dsb.)
│   ├── user.dart
│   └── product.dart
├── screens/              # Screen umum & autentikasi
│   ├── auth/             # LoginScreen, RegisterScreen, dsb.
│   └── admin/            # Halaman & fitur Dashboard Admin
├── services/             # API services (MockAPI) & DatabaseService
│   ├── api_service.dart
│   └── database_service.dart
├── user/                 # Sisi Pelanggan (User Interface)
│   ├── beranda/          # BerandaPage, makanan_list.dart, search_field.dart
│   ├── order/            # Halaman order, keranjang & riwayat
│   ├── profil/           # ProfilPage & pengaturan akun
│   └── main_page.dart    # Root navigasi pelanggan (BottomNavigationBar)
└── main.dart             # Entry point aplikasi & Route Definition
```

---

## 🚀 Cara Menjalankan Aplikasi

Pastikan Anda telah menginstal [Flutter SDK](https://flutter.dev/docs/get-started/install) pada perangkat Anda.

### 1. Clone Repositori
```bash
git clone https://github.com/username/fastbites.git
cd fastbites
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Konfigurasi API (Opsional)
Jika menggunakan MockAPI kustom Anda sendiri, sesuaikan `BASE_URL` pada file:
`lib/services/api_service.dart` atau file konfigurasi terkait.

### 4. Jalankan Aplikasi
Jalankan di emulator, perangkat fisik, atau web browser:
```bash
# Di Chrome / Web
flutter run -d chrome

# Di Emulator Android / iOS
flutter run
```

---

## 🧪 Akun Demo untuk Pengujian

| Role | Email | Password | Akses Tujuan |
| :--- | :--- | :--- | :--- |
| **Admin** | `admin@gmail.com` | `admin123` | Dashboard Admin (`/home`) |
| **User** | Buat via form register / MockAPI | (Sesuai register) | Halaman Pelanggan (`/user_main`) |

---

## 🛠️ Tech Stack & Dependencies

- **Framework:** [Flutter](https://flutter.dev) (Dart SDK)
- **Local Storage:** `sqflite` / `sqlite3` & `shared_preferences`
- **Networking:** `http` / `dio` (MockAPI Endpoint Integration)
- **State Management & UI:** Cupertino Icons, Material Design 3

---

Dikembangkan oleh **Kelompok 3** untuk pengembangan aplikasi mobile berbasis Flutter.

---
