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
        break;
      case 'London':
        tambah = 7;
        break;
      case 'Jepun':
        tambah = 6;
        break;
      case 'Arab':
        tambah = 5;
        break;
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
      int jam = (datetime.hour + tambah) % 24;
      return '${datetime.day} ${_bulan(datetime.month)} ${datetime.year} ${_jam(jam)}:${_menit(datetime.minute)}:${_detik(datetime.second)}';
    } catch (e) {
      return 'Invalid date format';
    }
  }

  String formatTanggalNextBayat(String text, int bulan) {
    try {
      DateTime datetime = DateTime.parse(text);
      int bulanNext = datetime.month + bulan;
      return '${datetime.day} ${_bulan(bulanNext)} ${datetime.year} ${_jam(datetime.hour)}:${_menit(datetime.minute)}:${_detik(datetime.second)}';
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
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal Pembayaran'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child:
            (_username == null || _waktu == null)
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pembayaran Terakhir',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              RichText(
                                text: TextSpan(
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.black87,
                                  ),
                                  children: [
                                    const TextSpan(text: 'Atas nama: '),
                                    TextSpan(
                                      text: _username ?? '-',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              RichText(
                                text: TextSpan(
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.black87,
                                  ),
                                  children: [
                                    const TextSpan(text: 'Tanggal: '),
                                    TextSpan(
                                      text: formatTanggal(_waktu ?? '', 0),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Konversi Waktu Pembayaran',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Saat ini kamu berada di zona waktu WIB.',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: primaryColor, width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedTimezone,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: primaryColor,
                            ),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedTimezone = newValue;
                                });
                                _konveriWaktu();
                              }
                            },
                            items:
                                [
                                      'WIB',
                                      'WITA',
                                      'WIT',
                                      'London',
                                      'Jepun',
                                      'Arab',
                                    ]
                                    .map(
                                      (value) => DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 24,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Waktu Terkonversi ($_selectedTimezone):',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _waktuKonversi ?? '-',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pembayaran Selanjutnya',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              RichText(
                                text: TextSpan(
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.black87,
                                  ),
                                  children: [
                                    const TextSpan(text: 'Atas nama: '),
                                    TextSpan(
                                      text: _username ?? '-',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              RichText(
                                text: TextSpan(
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.black87,
                                  ),
                                  children: [
                                    const TextSpan(text: 'Tanggal: '),
                                    TextSpan(
                                      text: formatTanggalNextBayat(
                                        _waktu ?? '',
                                        1,
                                      ),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
