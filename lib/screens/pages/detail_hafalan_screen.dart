import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projek_akhir_mobile/models/doa_model.dart';
import 'package:projek_akhir_mobile/models/hafalan_model.dart';
import 'package:projek_akhir_mobile/models/surat_detail_model.dart';
import 'package:projek_akhir_mobile/services/doa_network.dart';
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
  Future<dynamic>? _detailFuture;
  int? _id;
  int? _idHafalan;
  String? _tipeHafalan;
  String? _locationMessage;
  late final StreamSubscription<GyroscopeEvent> _gyroscopeSubscription;
  bool _alreadySelesai = false;

  @override
  void initState() {
    super.initState();
    cekSession();

    _gyroscopeSubscription = gyroscopeEvents.listen((event) {
      if (!_alreadySelesai && (event.x >= 5 || event.x <= -5)) {
        _alreadySelesai = true;
        selesaiHafalan();
      }
    });

    _requestAndGetLocation();
  }

  Future<void> cekSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionToken = prefs.getString('session_token');
    String? username = prefs.getString('username');

    if (sessionToken == null || username == null) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _idHafalan = args['idHafalan'] as int?;
      _id = args['id'] as int?;
      _tipeHafalan = args['tipeHafalan'] as String?;
    }

    debugPrint('idHafalan: $_idHafalan, tipeHafalan: $_tipeHafalan, id: $_id');

    if (_idHafalan != null && _tipeHafalan != null) {
      _detailFuture = _fetchDetail(_idHafalan!, _tipeHafalan!);
    }
  }

  Future<dynamic> _fetchDetail(int id, String tipe) {
    if (tipe == 'surat') {
      return SuratNetwork().getDetailData(id);
    } else {
      return DoaNetwork().getDetailData(id);
    }
  }

  Future<void> _requestAndGetLocation() async {
    try {
      final pos = await _determinePosition();
      if (mounted) {
        setState(() {
          _locationMessage = 'Lat: ${pos.latitude}, Lon: ${pos.longitude}';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _locationMessage = 'Error getting location: $e';
        });
      }
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Location services are disabled.');

    LocationPermission permission = await Geolocator.checkPermission();
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

  void selesaiHafalan() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    if (username == null) {
      debugPrint('No username found in SharedPreferences');
      return;
    }

    final List<Hafalan> hafalanList = await HafalanSave().getHafalan();
    final index = hafalanList.indexWhere((h) => h.id == _id);
    if (index == -1) {
      debugPrint('Hafalan dengan id=$_idHafalan tidak ditemukan');
      return;
    }

    Hafalan hafalan = hafalanList[index];
    DateTime tanggalMulai = DateTime.parse(hafalan.tanggalMulai);
    DateTime tanggalSelesai = DateTime.parse(hafalan.tanggalSelesai);

    tanggalMulai = tanggalMulai.add(const Duration(days: 1));
    if (tanggalMulai.isAfter(tanggalSelesai)) {
      hafalanList.removeAt(index);
      debugPrint(
        'Hafalan dengan id=$_idHafalan dihapus (tanggalMulai > tanggalSelesai)',
      );
    } else {
      hafalan.tanggalMulai = tanggalMulai.toIso8601String();
      hafalanList[index] = hafalan;
      debugPrint(
        'Tanggal mulai hafalan id=$_idHafalan diperbarui ke $tanggalMulai',
      );
    }

    final success = await HafalanSave().saveHafalanList(hafalanList);
    if (success && mounted) {
      debugPrint('Perubahan berhasil disimpan');
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      debugPrint('Gagal menyimpan perubahan');
    }
  }

  @override
  void dispose() {
    _gyroscopeSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Hafalan'), centerTitle: true),
      body:
          _detailFuture == null
              ? const Center(child: Text('Data tidak tersedia'))
              : FutureBuilder<dynamic>(
                future: _detailFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('Tidak Ada Data'));
                  }

                  if (_tipeHafalan == 'surat') {
                    final surat = snapshot.data as SuratDetail;
                    return _buildSuratDetail(surat);
                  } else {
                    final doa = snapshot.data as DoaModel;
                    return _buildDoaDetail(doa);
                  }
                },
              ),
    );
  }

  Widget _buildSuratDetail(SuratDetail suratDetail) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    children: [
                      // Baris Nama Latin - Nama
                      Text(
                        '${suratDetail.namaLatin} - ${suratDetail.nama}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      // Baris Surat ke - 1       Total Ayat = 7
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Surat ke - ${suratDetail.nomor}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            '${suratDetail.jumlahAyat} Ayat ',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Arti : ${suratDetail.arti}',
                              style: const TextStyle(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Turun di ${suratDetail.tempatTurun}',
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: suratDetail.ayat.length,
              itemBuilder: (context, index) {
                final ayat = suratDetail.ayat[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    tileColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    title: Text(
                      "${ayat.nomorAyat}. ${ayat.teksArab}",
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      textAlign: TextAlign.right,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ayat.teksLatin,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueAccent,
                          ),
                        ),
                        Text(
                          ayat.teksIndonesia,
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                    minLeadingWidth: 0,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Text(
              _locationMessage ?? 'Getting location...',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: selesaiHafalan,
              label: const Text("Selesai Hafalan Surat"),
              icon: const Icon(Icons.check),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDoaDetail(DoaModel doa) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text(
            doa.doa,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text('Ayat:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            doa.ayat,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 8),
          const Text('Latin:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(doa.latin, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          const Text('Artinya:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(doa.artinya, style: const TextStyle(fontSize: 16)),

          const SizedBox(height: 40),
          Text(
            _locationMessage ?? 'Getting location...',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: selesaiHafalan,
            label: const Text(
              "Selesai Hafalan Doa",
              style: TextStyle(color: Colors.white),
            ),
            icon: const Icon(Icons.check, color: Colors.white),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
          ),
        ],
      ),
    );
  }
}
