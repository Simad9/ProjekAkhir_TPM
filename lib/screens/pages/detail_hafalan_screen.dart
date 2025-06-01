import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projek_akhir_mobile/models/hafalan_model.dart';
import 'package:projek_akhir_mobile/models/surat_detail_model.dart';
import 'package:projek_akhir_mobile/services/hafalan_save.dart';
import 'package:projek_akhir_mobile/services/surat_network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';

class DetailHafalanScreen extends StatefulWidget {
  const DetailHafalanScreen({super.key});

  @override
  State<DetailHafalanScreen> createState() => _DetailHafalanScreenState();
}

class _DetailHafalanScreenState extends State<DetailHafalanScreen> {
  Future<SuratDetail>? _suratDetailFuture;
  int? _nomorSurat;
  bool _isLoading = false;
  String? _locationMessage;
  double _x = 0.0;

  late StreamSubscription<GyroscopeEvent> _gyroscopeSubscription;
  bool _alreadySelesai =
      false; // Flag debounce supaya selesaiHafalan gak dipanggil berkali-kali

  @override
  void initState() {
    super.initState();

    // Listen sensor gyroscope dan trigger selesaiHafalan saat sumbu x > 5 atau < -5
    _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _x = event.x;
      });

      if (!_alreadySelesai && (_x >= 5 || _x <= -5)) {
        _alreadySelesai = true;
        selesaiHafalan();
      }
    });

    // Ambil lokasi user sekali saat halaman dibuka
    _requestAndGetLocation();
  }

  @override
  void dispose() {
    _gyroscopeSubscription.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _isLoading = true;
    });

    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments != null && _nomorSurat == null) {
      if (arguments is Map<String, dynamic>) {
        _nomorSurat = arguments['nomorSurat'] as int?;
      } else if (arguments is int) {
        _nomorSurat = arguments;
      } else {
        print('Arguments tipe tidak dikenal: ${arguments.runtimeType}');
      }

      if (_nomorSurat != null) {
        _suratDetailFuture = SuratNetwork().getDetailData(_nomorSurat!);
        print('Nomor surat: $_nomorSurat');
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Fungsi ambil lokasi dengan izin
  Future<void> _requestAndGetLocation() async {
    try {
      Position pos = await _determinePosition();
      setState(() {
        _locationMessage = 'Lat: ${pos.latitude}, Lon: ${pos.longitude}';
      });
      print('Lokasi didapat: ${pos.latitude}, ${pos.longitude}');
    } catch (e) {
      setState(() {
        _locationMessage = 'Error getting location: $e';
      });
      print('Gagal mendapatkan lokasi: $e');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  // Fungsi update tanggal mulai hafalan dan hapus jika sudah lewat tanggal selesai
  void selesaiHafalan() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');

    if (username == null) {
      print('No username found in SharedPreferences');
      return;
    }

    final List<Hafalan> hafalanList = await HafalanSave().getHafalan();

    final index = hafalanList.indexWhere((h) => h.nomorSurat == _nomorSurat);
    if (index == -1) {
      print('Hafalan dengan nomorSurat=$_nomorSurat tidak ditemukan');
      return;
    }

    Hafalan hafalan = hafalanList[index];

    DateTime tanggalMulai = DateTime.parse(hafalan.tanggalMulai);
    DateTime tanggalSelesai = DateTime.parse(hafalan.tanggalSelesai);

    tanggalMulai = tanggalMulai.add(Duration(days: 1));

    if (tanggalMulai.isAfter(tanggalSelesai)) {
      hafalanList.removeAt(index);
      print(
        'Hafalan dengan nomorSurat=$_nomorSurat dihapus karena tanggalMulai > tanggalSelesai',
      );
    } else {
      hafalan.tanggalMulai = tanggalMulai.toIso8601String();
      hafalanList[index] = hafalan;
      print(
        'Tanggal mulai hafalan nomorSurat=$_nomorSurat diperbarui menjadi $tanggalMulai',
      );
    }

    final success = await HafalanSave().saveHafalanList(hafalanList);
    if (success) {
      print('Perubahan berhasil disimpan');
      setState(() {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      });
    } else {
      print('Gagal menyimpan perubahan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Hafalan')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : FutureBuilder<SuratDetail>(
                future: _suratDetailFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('Tidak Ada Data'));
                  }

                  final suratDetail = snapshot.data!;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nomor Surat: ${suratDetail.nomor}'),
                                Text('Nama Surat: ${suratDetail.nama}'),
                                Text('Nama Latin: ${suratDetail.namaLatin}'),
                                Text('Jumlah Ayat: ${suratDetail.jumlahAyat}'),
                                Text('Arti: ${suratDetail.arti}'),
                              ],
                            ),
                            Column(
                              children: [
                                Text(_locationMessage ?? 'Getting location...'),
                                const SizedBox(height: 10),
                                ElevatedButton.icon(
                                  onPressed: selesaiHafalan,
                                  label: const Text("Selesai"),
                                  icon: const Icon(Icons.check),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: suratDetail.ayat.length,
                            itemBuilder: (context, index) {
                              final ayat = suratDetail.ayat[index];
                              return ListTile(
                                title: Text(
                                  "${ayat.nomorAyat}. ${ayat.teksArab}",
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(ayat.teksLatin),
                                    Text(ayat.teksIndonesia),
                                  ],
                                ),
                                minLeadingWidth: 0,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
