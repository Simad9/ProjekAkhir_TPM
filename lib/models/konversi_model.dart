class CurrencyRate {
  final String code;
  final double value;

  CurrencyRate({
    required this.code,
    required this.value,
  });

  factory CurrencyRate.fromJson(Map<String, dynamic> json) {
    return CurrencyRate(
      code: json['code'],
      value: (json['value'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'value': value,
  };
}

class CurrencyData {
  final Map<String, CurrencyRate> rates;

  CurrencyData({
    required this.rates,
  });

  factory CurrencyData.fromJson(Map<String, dynamic> json) {
    final Map<String, CurrencyRate> rates = {};
    json.forEach((key, value) {
      rates[key] = CurrencyRate.fromJson(value);
    });
    return CurrencyData(rates: rates);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    rates.forEach((key, value) {
      data[key] = value.toJson();
    });
    return data;
  }
}

class ApiResponse {
  final CurrencyData data;

  ApiResponse({ required this.data });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      data: CurrencyData.fromJson(json['data']),
    );
  }
}
