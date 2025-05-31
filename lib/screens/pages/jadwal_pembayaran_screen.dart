import 'package:flutter/material.dart';
import 'package:projek_akhir_mobile/services/user_save.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JadwalPembayaranScreen extends StatefulWidget {
  const JadwalPembayaranScreen({super.key});

  @override
  State<JadwalPembayaranScreen> createState() => _JadwalPembayaranScreenState();
}

class _JadwalPembayaranScreenState extends State<JadwalPembayaranScreen> {
  String? _username;
  String? _waktu;
  String? _waktuKonversi;
  String _selectedTimezone = 'WIB';

  @override
  void initState() {
    super.initState();
    _ambilData();
  }

  Future<void> _ambilData() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? '';
    final result = await UserSave().getUserByUsername(username);
    setState(() {
      _username = username;
      _waktu = result?.waktu_bayar ?? '';
      _konveriWaktu();
    });
  }

  void _konveriWaktu() {
    if (_waktu == null || _waktu!.isEmpty) {
      setState(() {
        _waktuKonversi = '';
      });
      return;
    }

    int tambah = 0;
    switch (_selectedTimezone) {
      case 'WITA':
        tambah = 1;
        break;
      case 'WIT':
        tambah = 2;
        break;
      case 'WIB':
      default:
        tambah = 0;
    }

    setState(() {
      _waktuKonversi = formatTanggal(_waktu!, tambah);
    });
  }

  String formatTanggal(String text, int tambah) {
    try {
      DateTime datetime = DateTime.parse(text);
      // Penyesuaian jam dengan mod 24 agar tidak overflow ke 25 dst.
      int jam = (datetime.hour + tambah) % 24;
      return '${datetime.day} ${_bulan(datetime.month)} ${datetime.year} ${_jam(jam)}:${_menit(datetime.minute)}:${_detik(datetime.second)}';
    } catch (e) {
      return 'Invalid date format';
    }
  }

  String _bulan(int bulan) {
    const bulanList = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return (bulan >= 1 && bulan <= 12) ? bulanList[bulan] : '';
  }

  String _jam(int jam) => jam.toString().padLeft(2, '0');
  String _menit(int menit) => menit.toString().padLeft(2, '0');
  String _detik(int detik) => detik.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal Pembayaran')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            (_username == null || _waktu == null)
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kamu sudah melakukan pembayaran:'),
                    const SizedBox(height: 4),
                    Text(
                      'Atas nama: ${_username ?? '-'}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text('Pada tanggal: ${formatTanggal(_waktu ?? '', 0)}'),
                    const SizedBox(height: 16),
                    const Text(
                      'Kamu juga bisa konversi waktu untuk pembayaran selanjutnya. Anda berada di WIB saat ini',
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<String>(
                      value: _selectedTimezone,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedTimezone = newValue;
                          });
                          _konveriWaktu();
                        }
                      },
                      items:
                          ['WIB', 'WITA', 'WIT']
                              .map(
                                (value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ),
                              )
                              .toList(),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Waktu Terkonversi $_selectedTimezone: ${_waktuKonversi ?? '-'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
      ),
    );
  }
}
