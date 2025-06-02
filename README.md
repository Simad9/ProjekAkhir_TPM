# Projek Akhir Mobile Teori

Membuat aplikasi untuk tracking hafal Surat dan Doa

## Data Diri

- Dosen : Pak Bagus
- Nama : Wijdan 
- NIM : 123220010
- Kelas : TPM IF-A

## Dokumen Untuk Kuliah PPT

- PPT Projek Akhir : [Link Disini](https://www.canva.com/design/DAGpHYi__is/qz5eiv4Ld5cnpkE2VS85Hg/edit?utm_content=DAGpHYi__is&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton)
- Laporan Projek Akhir : [Link Disini](https://docs.google.com/document/d/1w9pwiHiDeMlErU1kPaOV0zu-J6lWfUjjFD2LpO-U6sw/edit?tab=t.32qtn1spo45x)
- Aplikasi Projek Akhir : [Link Disini](apk/tpm-projek-akhir.apk)

## Catatan Pribadi

Tracking hafalan Surat / hafalan Juz 30 :
https://doa-doa-api-ahmadramadhan.fly.dev/
https://equran.id/apidev/v2 \

Pengerjaan saya di : [To Do](TODO.md)



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
