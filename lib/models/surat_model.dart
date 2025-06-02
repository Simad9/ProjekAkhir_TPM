class Surat {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String arti;

  Surat({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.arti,
  });

  factory Surat.fromJson(Map<String, dynamic> json) {
    return Surat(
      nomor: json['nomor'] ?? 0,
      nama: json['nama'] ?? 'noData',
      namaLatin: json['namaLatin'] ?? 'noData',
      jumlahAyat: json['jumlahAyat'] ?? 0,
      arti: json['arti'] ?? 'noData',
    );
  }

  Map<String, dynamic> toJson() => {
    'nomor': nomor,
    'nama': nama,
    'namaLatin': namaLatin,
    'jumlahAyat': jumlahAyat,
    'arti': arti,
  };
}
