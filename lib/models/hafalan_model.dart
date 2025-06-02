class Hafalan {
  final int id;
  final int idHafalan;
  final String namaHafalan;
  final String tipeHafalan;
  String tanggalMulai;
  final String tanggalSelesai;

  Hafalan({
    required this.id,
    required this.idHafalan,
    required this.namaHafalan,
    required this.tipeHafalan,
    required this.tanggalMulai,
    required this.tanggalSelesai,
  });

  factory Hafalan.fromJson(Map<String, dynamic> json) {
    return Hafalan(
      id: json['id'] ?? 0,
      idHafalan: json['nomor_surat'] ?? 0,
      namaHafalan: json['nama_surat'] ?? 'noData',
      tipeHafalan: json['tipe_hafalan'] ?? 'noData',
      tanggalMulai: json['tanggal_mulai'] ?? 'noData',
      tanggalSelesai: json['tanggal_selesai'] ?? 'noData',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nomor_surat': idHafalan,
    'nama_surat': namaHafalan,
    'tipe_hafalan': tipeHafalan,
    'tanggal_mulai': tanggalMulai,
    'tanggal_selesai': tanggalSelesai,
  };
}
