import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/surat_model.dart';

void main() {
  group('Surat', () {
    // Test Case 1: Inisialisasi model Surat dengan data lengkap dan valid.
    test('should create a Surat object with complete data', () {
      final surat = Surat(
        nomor: 1,
        nama: "الفاتحة",
        namaLatin: "Al-Fatihah",
        jumlahAyat: 7,
        arti: "Pembukaan",
      );

      expect(surat.nomor, 1);
      expect(surat.nama, "الفاتحة");
      expect(surat.namaLatin, "Al-Fatihah");
      expect(surat.jumlahAyat, 7);
      expect(surat.arti, "Pembukaan");
    });

    // Test Case 2: fromJson() - Mem-parsing JSON yang lengkap dan valid.
    test('fromJson should correctly parse complete JSON', () {
      final Map<String, dynamic> json = {
        'nomor': 1,
        'nama': "الفاتحة",
        'namaLatin': "Al-Fatihah",
        'jumlahAyat': 7,
        'arti': "Pembukaan",
      };

      final surat = Surat.fromJson(json);

      expect(surat.nomor, 1);
      expect(surat.nama, "الفاتحة");
      expect(surat.namaLatin, "Al-Fatihah");
      expect(surat.jumlahAyat, 7);
      expect(surat.arti, "Pembukaan");
    });

    // Test Case 3: fromJson() - Mem-parsing JSON dengan data yang hilang atau null.
    test('fromJson should handle missing or null data with default values', () {
      final Map<String, dynamic> json = {
        'nomor': null, // Simulasi data null
        'namaLatin': "Al-Fatihah",
        'jumlahAyat': null, // Simulasi data null
        // 'nama' dan 'arti' hilang
      };

      final surat = Surat.fromJson(json);

      expect(surat.nomor, 0); // Default value for int
      expect(surat.nama, 'noData'); // Default value for String
      expect(surat.namaLatin, "Al-Fatihah");
      expect(surat.jumlahAyat, 0); // Default value for int
      expect(surat.arti, 'noData'); // Default value for String
    });

    // Test Case 4: toJson() - Mengkonversi objek Surat ke format JSON yang benar.
    test('toJson should correctly convert Surat object to JSON', () {
      final surat = Surat(
        nomor: 1,
        nama: "الفاتحة",
        namaLatin: "Al-Fatihah",
        jumlahAyat: 7,
        arti: "Pembukaan",
      );

      final Map<String, dynamic> json = surat.toJson();

      expect(json['nomor'], 1);
      expect(json['nama'], "الفاتحة");
      expect(json['namaLatin'], "Al-Fatihah");
      expect(json['jumlahAyat'], 7);
      expect(json['arti'], "Pembukaan");
    });

    // Test Case 5: Kestabilan toJson() setelah fromJson()
    test('toJson should produce the same data after fromJson', () {
      final Map<String, dynamic> originalJson = {
        'nomor': 1,
        'nama': "الفاتحة",
        'namaLatin': "Al-Fatihah",
        'jumlahAyat': 7,
        'arti': "Pembukaan",
      };

      final surat = Surat.fromJson(originalJson);
      final Map<String, dynamic> convertedJson = surat.toJson();

      expect(convertedJson, originalJson);
    });
  });
}
