class HafalanModel {
  final int id;
  final int nomorSurat;
  final String tanggalMulai;
  final String tanggalSelesai;

  HafalanModel({
    required this.id,
    required this.nomorSurat,
    required this.tanggalMulai,
    required this.tanggalSelesai,
  });

  factory HafalanModel.fromJson(Map<String, dynamic> json) {
    return HafalanModel(
      id: json['id'],
      nomorSurat: json['nomor_surat'],
      tanggalMulai: json['tanggal_mulai'],
      tanggalSelesai: json['tanggal_selesai'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nomor_surat': nomorSurat,
    'tanggal_mulai': tanggalMulai,
    'tanggal_selesai': tanggalSelesai,
  };
}
