// test/services/shared_preferences_stress_test.dart

import 'dart:convert';
import 'dart:math'; // Untuk Random
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projek_akhir_mobile/models/hafalan_model.dart'; // Sesuaikan path ini jika berbeda
import 'package:projek_akhir_mobile/services/hafalan_save.dart'; // Sesuaikan path ini jika berbeda

void main() {
  // Skenario 1: Penulisan dan Pembacaan Hafalan Individual Skala Besar
  group('Shared Preferences Stress Test - Individual Operations', () {
    final int numberOfItems = 10000; // Jumlah operasi yang akan diuji
    final Duration writeTimeout = const Duration(seconds: 60); // Batas waktu 60 detik
    final Duration readTimeout = const Duration(seconds: 60); // Batas waktu 60 detik

    setUp(() {
      // Menginisialisasi mock SharedPreferences sebelum setiap tes
      // Penting untuk memastikan kondisi bersih di awal setiap tes.
      SharedPreferences.setMockInitialValues({});
    });

    // Skenario 1.1: Stres Penulisan Individual dalam Jumlah Besar
    test('Stress - Should handle individual creation of $numberOfItems hafalan items', () async {
      final stopwatch = Stopwatch()..start();
      List<Future<bool>> writeFutures = [];

      for (int i = 0; i < numberOfItems; i++) {
        final hafalan = Hafalan(
          id: i,
          idHafalan: i + 1,
          namaHafalan: 'Surat Uji-$i',
          tipeHafalan: 'surat',
          tanggalMulai: DateTime.now().toIso8601String(),
          tanggalSelesai: DateTime.now().add(const Duration(days: 30)).toIso8601String(),
        );
        // Memanggil setString langsung pada SharedPreferences mock
        writeFutures.add(SharedPreferences.getInstance().then((prefs) {
          return prefs.setString('hafalan_${hafalan.id}', jsonEncode(hafalan.toJson()));
        }));
      }

      // Menunggu semua operasi penulisan selesai
      await expectLater(Future.wait(writeFutures), completes);

      stopwatch.stop();
      final elapsed = stopwatch.elapsedMilliseconds;
      print('[$numberOfItems Individual Writes] Completed in $elapsed ms');

      // Memverifikasi bahwa waktu tidak melebihi batas yang ditentukan
      expect(elapsed, lessThan(writeTimeout.inMilliseconds), reason: 'Individual Writes took too long!');

      // Opsional: Memverifikasi beberapa item pertama/terakhir untuk memastikan data ada
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey('hafalan_0'), isTrue);
      expect(prefs.containsKey('hafalan_${numberOfItems - 1}'), isTrue);
    }, timeout: Timeout(writeTimeout + const Duration(seconds: 10))); // Menambahkan buffer waktu untuk test runner

    // Skenario 1.2: Stres Pembacaan Individual dalam Jumlah Besar
    test('Stress - Should handle individual retrieval of $numberOfItems hafalan items', () async {
      // Mengisi SharedPreferences dengan data terlebih dahulu sebelum pengujian pembacaan
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      for (int i = 0; i < numberOfItems; i++) {
        final hafalan = Hafalan(
          id: i,
          idHafalan: i + 1,
          namaHafalan: 'Surat Uji-$i',
          tipeHafalan: 'surat',
          tanggalMulai: DateTime.now().toIso8601String(),
          tanggalSelesai: DateTime.now().add(const Duration(days: 30)).toIso8601String(),
        );
        await prefs.setString('hafalan_${hafalan.id}', jsonEncode(hafalan.toJson()));
      }

      final stopwatch = Stopwatch()..start();
      List<Future<Hafalan?>> readFutures = [];

      for (int i = 0; i < numberOfItems; i++) {
        readFutures.add(SharedPreferences.getInstance().then((prefs) {
          final jsonString = prefs.getString('hafalan_$i');
          if (jsonString != null) {
            return Hafalan.fromJson(jsonDecode(jsonString));
          }
          return null;
        }));
      }

      // Menunggu semua operasi pembacaan selesai
      final results = await Future.wait(readFutures);

      stopwatch.stop();
      final elapsed = stopwatch.elapsedMilliseconds;
      print('[$numberOfItems Individual Reads] Completed in $elapsed ms');

      // Memverifikasi bahwa waktu tidak melebihi batas yang ditentukan
      expect(elapsed, lessThan(readTimeout.inMilliseconds), reason: 'Individual Reads took too long!');
      expect(results.length, numberOfItems); // Memastikan semua item terbaca
      expect(results.first, isNotNull); // Memastikan item pertama tidak null
      expect(results.last, isNotNull); // Memastikan item terakhir tidak null

    }, timeout: Timeout(readTimeout + const Duration(seconds: 10))); // Menambahkan buffer waktu
  });

  // Skenario 2: Operasi Campuran Bersamaan pada Shared Preferences
  group('Shared Preferences Stress Test - Mixed Concurrent Operations', () {
    late HafalanSave hafalanSave;
    final int numberOfOperations = 500; // Jumlah total operasi campuran
    final Duration timeout = const Duration(seconds: 30); // Batas waktu 30 detik
    final Random random = Random();

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      hafalanSave = HafalanSave();
    });

    test('Stress - Should handle $numberOfOperations concurrent read/write/key operations', () async {
      final stopwatch = Stopwatch()..start();
      List<Future<void>> operationFutures = [];

      for (int i = 0; i < numberOfOperations; i++) {
        final operationType = random.nextInt(3); // 0=write, 1=read, 2=getKeys
        final hafalanId = random.nextInt(numberOfOperations); // ID acak untuk operasi

        if (operationType == 0) { // Operasi Penulisan (Write)
          final hafalan = Hafalan(
            id: hafalanId,
            idHafalan: hafalanId + 1,
            namaHafalan: 'Surat Mixed-$hafalanId',
            tipeHafalan: 'surat',
            tanggalMulai: DateTime.now().toIso8601String(),
            tanggalSelesai: DateTime.now().add(const Duration(days: 30)).toIso8601String(),
          );
          operationFutures.add(SharedPreferences.getInstance().then((prefs) {
            return prefs.setString('mixed_hafalan_${hafalan.id}', jsonEncode(hafalan.toJson()));
          }));
        } else if (operationType == 1) { // Operasi Pembacaan (Read)
          operationFutures.add(SharedPreferences.getInstance().then((prefs) {
            final jsonString = prefs.getString('mixed_hafalan_$hafalanId');
            if (jsonString != null) {
              return Hafalan.fromJson(jsonDecode(jsonString));
            }
            return null;
          }));
        } else { // Operasi Pengambilan Kunci (GetKeys)
          operationFutures.add(SharedPreferences.getInstance().then((prefs) {
            return prefs.getKeys();
          }));
        }
      }

      // Menunggu semua operasi campuran selesai
      await expectLater(Future.wait(operationFutures), completes);

      stopwatch.stop();
      final elapsed = stopwatch.elapsedMilliseconds;
      print('[$numberOfOperations Mixed Concurrent Operations] Completed in $elapsed ms');

      // Memverifikasi bahwa waktu tidak melebihi batas yang ditentukan
      expect(elapsed, lessThan(timeout.inMilliseconds), reason: 'Mixed operations took too long!');

      // Opsional: Memverifikasi keberadaan beberapa kunci
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getKeys(), isNotEmpty);
    }, timeout: Timeout(timeout + const Duration(seconds: 10))); // Menambahkan buffer waktu
  });

  // Skenario 3: Penyimpanan Koleksi Hafalan Sangat Besar dengan saveHafalanList
  group('Shared Preferences Stress Test - Large Collection Save', () {
    late HafalanSave hafalanSave;
    final int numberOfLargeItems = 15000; // Jumlah objek dalam koleksi besar
    final Duration timeout = const Duration(seconds: 70); // Batas waktu 70 detik

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      hafalanSave = HafalanSave();
    });

    test('Stress - Memory and time for adding $numberOfLargeItems hafalan items with saveHafalanList', () async {
      List<Hafalan> largeHafalanList = [];
      for (int i = 0; i < numberOfLargeItems; i++) {
        largeHafalanList.add(Hafalan(
          id: i,
          idHafalan: i + 1,
          namaHafalan: 'Surat Besar-${i}',
          tipeHafalan: 'surat',
          tanggalMulai: DateTime.now().toIso8601String(),
          tanggalSelesai: DateTime.now().add(const Duration(days: 30)).toIso8601String(),
        ));
      }

      final stopwatch = Stopwatch()..start();
      // Menggunakan metode saveHafalanList dari HafalanSave untuk menguji jalur kode aplikasi Anda
      final success = await hafalanSave.saveHafalanList(largeHafalanList);
      stopwatch.stop();
      final elapsed = stopwatch.elapsedMilliseconds;
      print('[$numberOfLargeItems Large Collection Save] Completed in $elapsed ms');

      // Memverifikasi bahwa operasi penyimpanan berhasil
      expect(success, isTrue, reason: 'Failed to save large hafalan list');
      // Memverifikasi bahwa waktu tidak melebihi batas yang ditentukan
      expect(elapsed, lessThan(timeout.inMilliseconds), reason: 'Saving large collection took too long!');

      // Opsional: Memverifikasi ukuran data yang tersimpan
      final prefs = await SharedPreferences.getInstance();
      final savedList = prefs.getStringList(HafalanSave.hafalanKey);
      expect(savedList, isNotNull);
      expect(savedList!.length, numberOfLargeItems);

    }, timeout: Timeout(timeout + const Duration(seconds: 10))); // Menambahkan buffer waktu
  });
}