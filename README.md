# Projek Akhir Mobile Teori

Membuat aplikasi untuk tracking hafalan

## Catatan Pribadi

Tracking hafalan Surat / hafalan Juz 30 :
https://doa-doa-api-ahmadramadhan.fly.dev/
https://equran.id/apidev/v2

## Konsep Aplikasi

Syarat Tugas Akhir :

- Login menggunakan enkripsi disimpan di session (nanti mau sesuai DB atau engga) ✅
- Terkoneksi database (nanti pake Hive aja ngikut praktikum)✅
- Menggunakan API ✅
- Fitur LBS✅
- Terdapat menu navigasi :
  - Menu Profile Gambar diri dan data pribadi ✅
  - Menu saran mata kuliah ✅
  - Logout ✅
- Konversi mata uang mengikuti konsep✅
- Konversi waktu (minimal WIB, WIT, WITA) mengikuti konsep✅
- Fitur Searching ✅
- Fitur Notifikasi✅
- Sensor sederhana ✅

#### Konsep Aplikasi + Pertanyaan ChatGPT :

Konsep yang dibawakan adalah tracking untuk Hafalan surat + Hafalan Juz 30

Tujuan Aps = Untuk membantu menghafal Surat dan Juz 30
Fitur Utama = Membuka Surat lalu menghafal dan diingatkan setiap harinya
Siapa User = Diri sendiri dan yang pengin menghafal surat
Halaman =

1. Login + Register
2. Halaman Utama (List Hafalan yang ingin dihafal)
3. Halaman Notifikasi [Untuk menerima notifikasi]
4. Halaman Daftar Surat (Bisa Surat atau Juz 30) → Bisa searching
5. Halaman Detail :
   - Data Pribadi,
   - Kesan matkul Teknologi Pemrograman Mobile (TPM),
   - Sensor Sederhana (posisi untuk hafalan gyro hp) ,
   - Berlangganan (mau bayar bisa convert ke mata uang mana)

#### Alur Flow Aplikasi :

- User di halaman Utama (kosong) → ke halaman daftar surat → klik surat tersebut → isi target hafalan sampe tanggal berapa, dikasih tau pengingatnya kapan → Tersimpan di Database.
- Di Halaman Utama tersedia list itu → di tekan → Mulai menghafal (Terdapat lokasi menghafal juga, dan sensor apakah hp sedang berdiri atau tidur) → Selesai → Tercatat di database sudah selesai untuk hari itu → Halaman utama kosong
- Notifikasi bunyi → Bisa dilhat kembali di halaman notifikasi → mulai menghafal
- User buka halaman detail → bisa melihat data pribadi → bisa melihat kesan TPM.
- User buka halaman detail → User buka halaman berlanganan --> nanti tulisan pilihannya 10 Dolar --> User bakal masukin uang secara IDR nanti di sistem bakal convert menjadi Dolar. Kalo IDR belum mencukupi, tombol pembayaran belum bisa ditekan --> User berhasil menemukan uang yang sesuai --> Nanti jadi berlanganan --> User set waktu untuk pembayaran selanjutnya (konversi waktu)

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
