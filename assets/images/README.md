# FASTBITES Assets Folder

Tempat untuk menyimpan image/banner untuk login dan register.

## Cara Menggunakan

1. **Tambahkan gambar banner:**

   - Simpan file gambar ke folder ini (assets/images/)
   - Gunakan format PNG atau JPG
   - Recommended size: 800x600px atau lebih

2. **Referensi di code:**

   - Login Banner: `assets/images/login_banner.png`
   - Register Banner: `assets/images/register_banner.png`

3. **Update di file:**
   - Edit `lib/screens/auth/login_screen.dart` untuk menambahkan gambar
   - Edit `lib/screens/auth/register_screen.dart` untuk menambahkan gambar

## Contoh Penggunaan dalam Code:

```dart
Image.asset(
  'assets/images/login_banner.png',
  fit: BoxFit.cover,
  width: double.infinity,
  height: 300,
)
```

## Tips Design

- Gunakan warna hijau (#22C55E) sebagai warna primer
- Gunakan warna putih sebagai warna sekunder
- Pastikan image memiliki contrast yang baik
- Rekomendasi: buat desain yang simple dan modern
