import 'dart:convert';

import 'package:projek_akhir_mobile/models/hafalan_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HafalanSave {
  static const String hafalanKey = 'hafalan';

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
              DateTime.parse(element.tanggalMulai).isAfter(today) &&
              DateTime.parse(
                element.tanggalSelesai,
              ).isBefore(today.add(Duration(days: 1))),
        )
        .toList();
  }

  Future<List<Hafalan>> getHafalan() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> hafalanJson = prefs.getStringList(hafalanKey) ?? [];
    return hafalanJson.map((e) => Hafalan.fromJson(jsonDecode(e))).toList();
  }

  // Tambah satu data hafalan baru ke SharedPreferences
  Future<bool> addHafalan(Hafalan newHafalan) async {
    final List<Hafalan> currentList = await getHafalan();
    currentList.add(newHafalan);
    return await saveHafalanList(currentList);
  }
}
