import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projek_akhir_mobile/models/konversi_model.dart';

class CurrencyService {
  final String baseUrl = "http://localhost:5000/api/konversi";

  Future<ApiResponse> fetchCurrencyRates() async {
    final uri = Uri.parse(baseUrl);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return ApiResponse.fromJson(jsonBody);
    } else {
      throw Exception('Failed to load currency rates');
    }
  }
}
