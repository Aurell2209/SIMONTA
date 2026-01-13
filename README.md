# SIMONTA - Sistem Monitoring Notulensi dan Arsip Organisasi

![SIMONTA Logo](assets/images/logo.png)

## Deskripsi

SIMONTA adalah aplikasi mobile berbasis Flutter untuk mencatat notulensi rapat dan mengelola dokumen (LPJ dan Proposal) organisasi secara lokal, sederhana, dan efisien.

## Fitur Utama

### 1. **Splash Screen**
- Menampilkan logo dan nama aplikasi SIMONTA
- Cek session login menggunakan SharedPreferences
- Animasi fade dan scale yang smooth

### 2. **Login Screen**
- Login lokal dengan username & password
- Validasi form
- Session login disimpan menggunakan SharedPreferences
- UI modern dengan gradient background

### 3. **Home Screen (Dashboard)**
- Bottom Navigation: Statistik, Beranda, Profil
- Menu GridView dengan Card:
  - Notulensi
  - Arsip Dokumen
- Desain modern dengan gradient header

### 4. **Manajemen Notulensi (CRUD)**
**Field:**
- Judul rapat
- Tanggal
- Tempat
- Peserta
- Hasil rapat
- Reminder (opsional)

**Fitur:**
- Tambah notulensi baru
- List notulensi dengan ListView.builder
- Detail notulensi
- Edit notulensi
- Hapus notulensi dengan dialog konfirmasi
- Share via WhatsApp dan Email

### 5. **Manajemen Dokumen (CRUD)**
**Jenis:**
- Proposal
- LPJ

**Field:**
- Judul
- Tanggal
- Jenis (Proposal/LPJ)
- Status (Selesai/Proses/Kendala)
- Keterangan

**Fitur:**
- Tambah dokumen baru
- List dokumen dengan filter jenis dan status
- Detail dokumen
- Edit dokumen
- Hapus dokumen dengan dialog konfirmasi
- Share via WhatsApp dan Email

### 6. **Statistik**
- Total Notulensi
- Total Dokumen
- Breakdown jenis dokumen (Proposal, LPJ)
- Breakdown status dokumen (Selesai, Proses, Kendala)
- Visualisasi dengan card yang informatif

### 7. **Profil**
- Informasi user
- Tentang aplikasi
- Logout

### 8. **Fitur Inovatif**
- **Share**: Bagikan notulensi dan dokumen ke WhatsApp atau Email
- **Reminder**: Set reminder untuk notulensi dengan date picker
- **Filter**: Filter dokumen berdasarkan jenis dan status
- **Pull to Refresh**: Refresh data dengan swipe down

## Teknologi

- **Framework**: Flutter (Dart)
- **State Management**: StatefulWidget
- **Local Storage**: SharedPreferences (JSON encode/decode)
- **Dependencies**:
  - `shared_preferences: ^2.2.2` - Penyimpanan lokal
  - `url_launcher: ^6.2.4` - Share via WhatsApp dan Email
  - `intl: ^0.19.0` - Format tanggal

## UI/UX Design

### Color Palette
- **Primary**: Teal (#4DB6AC)
- **Secondary**: Blue (#42A5F5)
- **Accent**: Purple (#7E57C2)
- **Success**: Green (#66BB6A)
- **Warning**: Orange (#FFA726)
- **Error**: Red (#EF5350)
- **Background**: Light Gray (#F5F7FA)

### Design Principles
- ✅ Warna soft dan modern
- ✅ Typography jelas (Material Design)
- ✅ Card-based layout
- ✅ Gradient backgrounds
- ✅ Consistent icons
- ✅ Smooth animations
- ✅ Responsive layout (mobile portrait)
- ✅ Minimalis namun aesthetic

## Struktur Folder

```
lib/
├── models/
│   ├── notulensi.dart          # Model data notulensi
│   └── dokumen.dart             # Model data dokumen
├── screens/
│   ├── splash_screen.dart       # Splash screen dengan animasi
│   ├── login_screen.dart        # Login screen
│   ├── home_screen.dart         # Home dengan bottom navigation
│   ├── notulensi_list_screen.dart    # List notulensi
│   ├── notulensi_form_screen.dart    # Form tambah/edit notulensi
│   ├── notulensi_detail_screen.dart  # Detail notulensi
│   ├── dokumen_list_screen.dart      # List dokumen
│   ├── dokumen_form_screen.dart      # Form tambah/edit dokumen
│   ├── dokumen_detail_screen.dart    # Detail dokumen
│   ├── statistics_screen.dart        # Statistik
│   └── profile_screen.dart           # Profil & logout
├── services/
│   └── storage_service.dart     # Service untuk SharedPreferences
├── utils/
│   └── theme.dart               # Theme configuration
└── main.dart                    # Entry point aplikasi
```

## Cara Menjalankan Aplikasi

### Prasyarat
- Flutter SDK (stable channel)
- Android Studio / VS Code dengan Flutter extension
- Emulator Android atau device fisik

### Langkah-langkah

1. **Clone atau extract project**
   ```bash
   cd Simonta_aplikasi
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi (Debug)**
   ```bash
   flutter run
   ```

4. **Build APK (Release)**
   ```bash
   flutter build apk --release
   ```
   APK akan tersimpan di: `build/app/outputs/flutter-apk/app-release.apk`

5. **Build APK (Split per ABI - ukuran lebih kecil)**
   ```bash
   flutter build apk --split-per-abi
   ```

## Cara Menggunakan Aplikasi

### Login
1. Buka aplikasi
2. Masukkan username dan password (bebas, tidak ada validasi khusus)
3. Tap tombol "Login"

### Menambah Notulensi
1. Dari Home, tap menu "Notulensi"
2. Tap tombol FAB (+) di kanan bawah
3. Isi form:
   - Judul rapat
   - Pilih tanggal
   - Tempat
   - Peserta (pisahkan dengan koma)
   - Hasil rapat
   - (Opsional) Tambah reminder
4. Tap "Simpan"

### Menambah Dokumen
1. Dari Home, tap menu "Arsip Dokumen"
2. Tap tombol FAB (+) di kanan bawah
3. Isi form:
   - Judul dokumen
   - Pilih tanggal
   - Pilih jenis (Proposal/LPJ)
   - Pilih status (Selesai/Proses/Kendala)
   - Keterangan
4. Tap "Simpan"

### Share Notulensi/Dokumen
1. Buka detail notulensi atau dokumen
2. Tap icon share di app bar
3. Pilih WhatsApp atau Email
4. Aplikasi akan membuka WhatsApp/Email dengan teks yang sudah terformat

### Melihat Statistik
1. Tap menu "Statistik" di bottom navigation
2. Lihat ringkasan data notulensi dan dokumen

### Logout
1. Tap menu "Profil" di bottom navigation
2. Scroll ke bawah
3. Tap "Logout"
4. Konfirmasi logout

## Catatan Penting

- ✅ Aplikasi menggunakan SharedPreferences untuk penyimpanan lokal
- ✅ Tidak menggunakan database eksternal (SQLite/Firebase)
- ✅ Data tersimpan di device dan tidak akan hilang saat aplikasi ditutup
- ✅ Login bersifat lokal dan sederhana (tidak ada enkripsi password)
- ✅ Untuk production, disarankan menggunakan proper authentication

## Troubleshooting

### Error: "Target of URI doesn't exist"
Jalankan: `flutter pub get`

### APK tidak bisa di-install
Pastikan "Install from Unknown Sources" diaktifkan di Android

### WhatsApp/Email tidak terbuka
Pastikan aplikasi WhatsApp/Email terinstall di device

## Lisensi

Project ini dibuat untuk keperluan UAS Mobile Programming.

---

**SIMONTA** - Sistem Monitoring Notulensi dan Arsip Organisasi
Version 1.0.0
