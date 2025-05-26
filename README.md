# Projek Akhir Mobile

Membuat aplikasi untuk tracking hafalan

## Catatan Pribadi

API yang dipakai : https://equran.id/apidev/v1

## Arsitektur Folder dari ChatGPT

```bash
lib/
├── assets/
│   ├── images/              # Menyimpan gambar-gambar seperti logo, ikon, atau gambar lainnya
│   ├── audio/               # Menyimpan file audio bacaan surah
│   └── fonts/               # Menyimpan file font custom
│
├── config/
│   ├── api.dart             # Menyimpan konfigurasi terkait API dan endpoint
│   ├── constants.dart       # Menyimpan konstanta yang digunakan di seluruh aplikasi
│   └── theme.dart           # Menyimpan pengaturan tema, seperti warna dan font
│
├── models/
│   ├── user.dart            # Model untuk data pengguna
│   ├── surah.dart           # Model untuk data surah
│   ├── progress.dart        # Model untuk tracking progres hafalan
│   └── reminder.dart        # Model untuk pengingat
│
├── services/
│   ├── auth_service.dart    # Layanan untuk autentikasi pengguna (register, login, etc.)
│   ├── progress_service.dart# Layanan untuk mengelola progres hafalan
│   └── reminder_service.dart# Layanan untuk mengelola pengingat
│
├── screens/
│   ├── home_page.dart       # Halaman utama aplikasi
│   ├── surah_detail_page.dart# Halaman detail untuk setiap surah
│   ├── progress_page.dart   # Halaman untuk melihat progres hafalan
│   └── reminders_page.dart  # Halaman pengaturan pengingat
│
├── widgets/
│   ├── custom_button.dart   # Tombol dengan desain custom
│   ├── custom_card.dart     # Card dengan desain custom
│   ├── surah_item.dart      # Widget untuk menampilkan item surah di daftar
│   └── progress_indicator.dart# Widget untuk menampilkan progress penghafalan
│
├── utils/
│   ├── date_utils.dart      # Utilitas untuk menangani tanggal dan waktu
│   └── notification_utils.dart# Utilitas untuk mengatur notifikasi
│
└── main.dart                # File utama untuk menjalankan aplikasi Flutter
```
