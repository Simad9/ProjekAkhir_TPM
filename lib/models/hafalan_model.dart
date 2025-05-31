class Hafalan {
  final int nomorSurat;
  final String namaSurat;
  final String tanggalMulai;
  final String tanggalSelesai;

  Hafalan({
    required this.nomorSurat,
    required this.namaSurat,
    required this.tanggalMulai,
    required this.tanggalSelesai,
  });

  factory Hafalan.fromJson(Map<String, dynamic> json) {
    return Hafalan(
      nomorSurat: json['nomor_surat'] ?? 0,
      namaSurat: json['nama_surat'] ?? 'noData',
      tanggalMulai: json['tanggal_mulai'] ?? 'noData',
      tanggalSelesai: json['tanggal_selesai'] ?? 'noData',
    );
  }

  Map<String, dynamic> toJson() => {
    'nomor_surat': nomorSurat,
    'nama_surat': namaSurat,
    'tanggal_mulai': tanggalMulai,
    'tanggal_selesai': tanggalSelesai,
  };
}
