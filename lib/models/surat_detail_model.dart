class SuratDetail {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final Map<String, String> audioFull; // key audio 01,02,... value url
  final List<Ayat> ayat;
  final SuratSingkat suratSelanjutnya;
  final SuratSingkat suratSebelumnya;

  SuratDetail({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audioFull,
    required this.ayat,
    required this.suratSelanjutnya,
    required this.suratSebelumnya,
  });

  factory SuratDetail.fromJson(Map<String, dynamic> json) => SuratDetail(
        nomor: json['nomor'],
        nama: json['nama'],
        namaLatin: json['namaLatin'],
        jumlahAyat: json['jumlahAyat'],
        tempatTurun: json['tempatTurun'],
        arti: json['arti'],
        deskripsi: json['deskripsi'],
        audioFull: Map<String, String>.from(json['audioFull']),
        ayat: List<Ayat>.from(json['ayat'].map((x) => Ayat.fromJson(x))),
        suratSelanjutnya: SuratSingkat.fromJson(json['suratSelanjutnya']),
        suratSebelumnya: SuratSingkat.fromJson(json['suratSebelumnya']),
      );

  Map<String, dynamic> toJson() => {
        'nomor': nomor,
        'nama': nama,
        'namaLatin': namaLatin,
        'jumlahAyat': jumlahAyat,
        'tempatTurun': tempatTurun,
        'arti': arti,
        'deskripsi': deskripsi,
        'audioFull': audioFull,
        'ayat': ayat.map((x) => x.toJson()).toList(),
        'suratSelanjutnya': suratSelanjutnya.toJson(),
        'suratSebelumnya': suratSebelumnya.toJson(),
      };
}

class Ayat {
  final int nomorAyat;
  final String teksArab;
  final String teksLatin;
  final String teksIndonesia;
  final Map<String, String> audio;

  Ayat({
    required this.nomorAyat,
    required this.teksArab,
    required this.teksLatin,
    required this.teksIndonesia,
    required this.audio,
  });

  factory Ayat.fromJson(Map<String, dynamic> json) => Ayat(
        nomorAyat: json['nomorAyat'],
        teksArab: json['teksArab'],
        teksLatin: json['teksLatin'],
        teksIndonesia: json['teksIndonesia'],
        audio: Map<String, String>.from(json['audio']),
      );

  Map<String, dynamic> toJson() => {
        'nomorAyat': nomorAyat,
        'teksArab': teksArab,
        'teksLatin': teksLatin,
        'teksIndonesia': teksIndonesia,
        'audio': audio,
      };
}

class SuratSingkat {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;

  SuratSingkat({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
  });

  factory SuratSingkat.fromJson(Map<String, dynamic> json) => SuratSingkat(
        nomor: json['nomor'],
        nama: json['nama'],
        namaLatin: json['namaLatin'],
        jumlahAyat: json['jumlahAyat'],
      );

  Map<String, dynamic> toJson() => {
        'nomor': nomor,
        'nama': nama,
        'namaLatin': namaLatin,
        'jumlahAyat': jumlahAyat,
      };
}
