import 'dart:convert';

import 'package:projek_akhir_mobile/models/hafalan_model.dart';
import 'package:projek_akhir_mobile/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HafalanSave {
  static const String hafalanKey = 'hafalan';
  final NotificationService _notificationService = NotificationService();

  // Simpan list lengkap (overwrite)
  Future<bool> saveHafalanList(List<Hafalan> hafalanList) async {
    final prefs = await SharedPreferences.getInstance();
    final hafalanJson = hafalanList.map((e) => jsonEncode(e.toJson())).toList();
    return await prefs.setStringList(hafalanKey, hafalanJson);
  }

  // Ambil list hafalan yang hanya hari ini saja
  Future<List<Hafalan>> getHafalanHariIni() async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final List<Hafalan> hafalanList = await getHafalan();
    return hafalanList
        .where(
          (element) =>
              DateTime.parse(element.tanggalMulai).isAtSameMomentAs(today) ||
              (DateTime.parse(element.tanggalMulai).isBefore(today) &&
                  DateTime.parse(element.tanggalSelesai).isAfter(today)),
        )
        .toList();
  }

  Future<List<Hafalan>> getHafalanBesok() async {
    final DateTime now = DateTime.now();
    final DateTime besok = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(Duration(days: 1));
    final List<Hafalan> hafalanList = await getHafalan();
    return hafalanList.where((element) {
      final tanggalMulai = DateTime.parse(element.tanggalMulai);
      final tanggalSelesai = DateTime.parse(element.tanggalSelesai);
      return tanggalMulai.isAtSameMomentAs(besok) ||
          (tanggalMulai.isBefore(besok) && tanggalSelesai.isAfter(besok));
    }).toList();
  }

  Future<List<Hafalan>> getHafalan() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> hafalanJson = prefs.getStringList(hafalanKey) ?? [];
    return hafalanJson.map((e) => Hafalan.fromJson(jsonDecode(e))).toList();
  }

  // Tambah satu data hafalan baru ke SharedPreferences
  Future<bool> addHafalan(Hafalan newHafalan) async {
    // Simpan Hafalan
    final List<Hafalan> currentList = await getHafalan();
    currentList.add(newHafalan);

    // Notif Penyemangat
    await _notificationService.showNotification(
      id: 0,
      title: 'Hafalan Tambah',
      body:
          'Semangat, hafalan baru telah ditambahkan! Kamu sedang menggali pahala. Tetap semangat dan jangan lupa bismillahirrahmanirrahim.',
      payload: 'data tambahan',
    );

    return await saveHafalanList(currentList);
  }

  Future<bool> adaHafalanBelumSelesai() async {
    final List<Hafalan> allHafalan = await getHafalan();
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    for (var hafalan in allHafalan) {
      DateTime mulai = DateTime.parse(hafalan.tanggalMulai);
      DateTime selesai = DateTime.parse(hafalan.tanggalSelesai);

      // Jika hari ini masih di antara tanggalMulai dan tanggalSelesai artinya belum selesai
      if ((mulai.isBefore(today) || mulai.isAtSameMomentAs(today)) &&
          (selesai.isAfter(today) || selesai.isAtSameMomentAs(today))) {
        return true; // Ada hafalan belum selesai
      }
    }
    return false; // Semua hafalan sudah selesai
  }
}
