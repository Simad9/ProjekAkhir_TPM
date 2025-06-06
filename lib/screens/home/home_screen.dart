import 'package:flutter/material.dart';
import 'package:projek_akhir_mobile/services/hafalan_save.dart';
import 'package:projek_akhir_mobile/services/notification_service.dart';

// Services
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> _hafalanListFuture;
  bool _isLoading = false;

  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    cekSession();
    _fetchSuratList();
    _scheduleReminderIfNeeded();
  }

  Future<void> cekSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionToken = prefs.getString('session_token');
    String? username = prefs.getString('username');

    if (sessionToken == null || username == null) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  Future<void> _fetchSuratList() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _hafalanListFuture = HafalanSave().getHafalanHariIni();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengambil data: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _scheduleReminderIfNeeded() async {
    bool adaBelumSelesai = await HafalanSave().adaHafalanBelumSelesai();

    final now = DateTime.now();
    final scheduledTime = DateTime(now.year, now.month, now.day, 0, 30, 0);

    if (now.hour == scheduledTime.hour &&
        now.minute == scheduledTime.minute &&
        now.second == scheduledTime.second) {
      if (adaBelumSelesai) {
        await NotificationService().showNotification(
          id: 1,
          title: 'Ingat Hafalanmu!',
          body: 'Masih ada surat yang belum selesai dihafal. Yuk lanjutkan!',
          payload: 'hafalan',
        );
      } else {
        // Kalau semua selesai, bisa cancel notif yg pernah dijadwalkan
        await _notificationService.flutterLocalNotificationsPlugin.cancel(1);
      }
    }
  }

  // Titip Fungsi --> Buat Bukti aja
  Future<void> _fetchSuratListBesok() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _hafalanListFuture = HafalanSave().getHafalanBesok();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengambil data: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_token'); // Hapus session token
    await prefs.remove('username');
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  String _formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate =
        "${dateTime.day} ${_bulan(dateTime.month)} ${dateTime.year}";
    return formattedDate;
  }

  String _bulan(int bulan) {
    switch (bulan) {
      case 1:
        return "Januari";
      case 2:
        return "Februari";
      case 3:
        return "Maret";
      case 4:
        return "April";
      case 5:
        return "Mei";
      case 6:
        return "Juni";
      case 7:
        return "Juli";
      case 8:
        return "Agustus";
      case 9:
        return "September";
      case 10:
        return "Oktober";
      case 11:
        return "November";
      case 12:
        return "Desember";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Homepage"),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () => logout()),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              'Hafalan Saya',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            // ElevatedButton(
            //   child: Text('ambil besok'),
            //   onPressed: _isLoading ? null : _fetchSuratListBesok,
            // ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _hafalanListFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Tidak Ada Data'));
                  }

                  final dataList = snapshot.data!;

                  return ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      final data = dataList[index];
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
                            data.namaHafalan,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            '${_formatDate(data.tanggalMulai)} s/d ${_formatDate(data.tanggalSelesai)}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/detail',
                              arguments: {
                                'id': data.id,
                                'idHafalan': data.idHafalan,
                                'tipeHafalan': data.tipeHafalan,
                              },
                            ).then((value) {
                              if (value != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Gagal mengakses halaman detail',
                                    ),
                                  ),
                                );
                              }
                            });
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
