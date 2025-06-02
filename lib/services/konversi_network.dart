import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projek_akhir_mobile/models/konversi_model.dart';

class CurrencyService {
  // final String baseUrl = "http://192.168.1.146:5000/api/konversi";
  final String baseUrl =
      "https://api.currencyapi.com/v3/latest?apikey=cur_live_PVgUu3wtiDZlMKtSBSji8smN9seZnPPNXynycrX2&currencies=USD%2CEUR%2CSGD%2CJPY%2CCNY%2CBTC%2CIDR&base_currency=IDR";

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
