import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projek_akhir_mobile/models/surat_detail_model.dart';
import 'package:projek_akhir_mobile/models/surat_model.dart';

class SuratNetwork {
  // static const String baseUrl = "http://192.168.1.146:5000/api/surat";
  static const String baseUrl = "https://equran.id/api/v2/surat";

  Future<List<Surat>> getData() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);

      // Ambil list dari key 'data'
      final List<dynamic> jsonList = jsonMap['data'];

      // Map tiap elemen json ke model Surat
      final List<Surat> decodedList =
          jsonList.map((item) {
            return Surat.fromJson(item as Map<String, dynamic>);
          }).toList();

      return decodedList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<SuratDetail> getDetailData(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);

      // Ambil objek di dalam key "data"
      final Map<String, dynamic> dataMap = jsonMap['data'];

      // Parsing ke model SuratDetail dari objek "data"
      return SuratDetail.fromJson(dataMap);
    } else {
      throw Exception("Failed to load detail data");
    }
  }

  Future<List<Surat>> searchSurat(String query) async {
    final data = await getData(); // Fetch all data
    return data.where((surat) {
      final lowerCaseQuery = query.toLowerCase();
      return surat.nama.toLowerCase().contains(lowerCaseQuery) ||
          surat.namaLatin.toLowerCase().contains(lowerCaseQuery);
    }).toList();
  }

  Future<List<Surat>> sortDescSurat() async {
    final data = await getData(); // Fetch all data
    return data.reversed.toList();
  }
}
