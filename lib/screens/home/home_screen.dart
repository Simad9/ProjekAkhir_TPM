import 'package:flutter/material.dart';
import 'package:projek_akhir_mobile/models/hafalan_model.dart';
import 'package:projek_akhir_mobile/services/hafalan_save.dart';

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

  @override
  void initState() {
    super.initState();
    cekSession();
    _fetchSuratList();
  }

  Future<bool> cekSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionToken = prefs.getString('session_token');
    return sessionToken != null;
  }

  Future<void> _fetchSuratList() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _hafalanListFuture = HafalanSave().getHafalan();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Homepage"),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () => logout()),
        ],
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: EdgeInsets.all(8),
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
                        return ListTile(
                          title: Text(
                            data.namaHafalan,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // pastikan warna teks hitam
                            ),
                          ),
                          subtitle: Text(
                            data.tanggalSelesai, // tampilkan nama asli Arab di subtitle
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          onTap: () {
                            // Arahkan ke halaman detail surat
                            Navigator.pushNamed(
                              context,
                              '/detail',
                              arguments: {'id': data.id, 'idHafalan': data.idHafalan, 'tipeHafalan': data.tipeHafalan},
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
                        );
                      },
                    );
                  },
                ),
              ),
    );
  }
}
