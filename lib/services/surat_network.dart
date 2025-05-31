import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projek_akhir_mobile/models/surat_detail_model.dart';
import 'package:projek_akhir_mobile/models/surat_model.dart';

class SuratNetwork {
  static const String baseUrl = "https://equran.id/api/surat";

  Future<List<Surat>> getData() async {
  final response = await http.get(Uri.parse(baseUrl));

  if (response.statusCode == 200) {
    final List<dynamic> decodedList = jsonDecode(response.body);

    return decodedList.map((item) {
      return Surat.fromJson(item as Map<String, dynamic>);
    }).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

  Future<SuratDetail> getDetailData(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = json.decode(response.body);
      final data = decoded['data'];
      return SuratDetail.fromJson(data);
    } else {
      throw Exception("Failed to load detail data");
    }
  }
}
