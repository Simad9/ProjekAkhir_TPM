class DoaModel {
  final String id;
  final String doa;
  final String ayat;
  final String latin;
  final String artinya;

  DoaModel({
    required this.id,
    required this.doa,
    required this.ayat,
    required this.latin,
    required this.artinya,
  });

  factory DoaModel.fromJson(Map<String, dynamic> json) {
    return DoaModel(
      id: json['id'] ?? 'noData',
      doa: json['doa'] ?? 'noData',
      ayat: json['ayat'] ?? 'noData',
      latin: json['latin'] ?? 'noData',
      artinya: json['artinya'] ?? 'noData',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'doa': doa,
    'ayat': ayat,
    'latin': latin,
    'artinya': artinya,
  };
}
