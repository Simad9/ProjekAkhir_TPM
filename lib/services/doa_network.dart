import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projek_akhir_mobile/models/doa_model.dart';

class DoaNetwork {
  static const String baseUrl = "http://192.168.1.146:5000/api";

  Future<List<DoaModel>> getData() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> decodedList = jsonDecode(response.body);

      return decodedList.map((item) {
        return DoaModel.fromJson(item as Map<String, dynamic>);
      }).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<DoaModel> getDetailData(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      final List<dynamic> decodedList = json.decode(response.body);
      if (decodedList.isNotEmpty) {
        // Ambil objek pertama dari list
        return DoaModel.fromJson(decodedList[0] as Map<String, dynamic>);
      } else {
        throw Exception("Data detail kosong");
      }
    } else {
      throw Exception("Failed to load detail data");
    }
  }

  Future<List<DoaModel>> searchDoa(String query) async {
    final data = await getData(); // Fetch all data
    return data.where((doa) {
      final lowerCaseQuery = query.toLowerCase();
      return doa.doa.toLowerCase().contains(lowerCaseQuery);
    }).toList();
  }

  Future<List<DoaModel>> sortDescSurat() async {
    final data = await getData(); // Fetch all data
    return data.reversed.toList();
  }
}
