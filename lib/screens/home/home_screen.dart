import 'package:flutter/material.dart';
import 'package:projek_akhir_mobile/models/hafalan_model.dart';
import 'package:projek_akhir_mobile/services/hafalan_save.dart';

// Services
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projek_akhir_mobile/screens/auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Hafalan>> _suratListFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchSuratList();
  }

  Future<void> _fetchSuratList() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _suratListFuture = HafalanSave().getHafalan();
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_token'); // Hapus session token
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ), // Arahkan ke halaman login
      );
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
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: EdgeInsets.all(8),
                child: Expanded(
                  child: FutureBuilder<List<Hafalan>>(
                    future: _suratListFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No movies found.'));
                      }

                      final suratList = snapshot.data!;

                      return ListView.builder(
                        itemCount: suratList.length,
                        itemBuilder: (context, index) {
                          final surat = suratList[index];
                          return ListTile(
                            title: Text(
                              surat.namaSurat,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    Colors.black, // pastikan warna teks hitam
                              ),
                            ),
                            subtitle: Text(
                              surat
                                  .tanggalSelesai, // tampilkan nama asli Arab di subtitle
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            onTap: () {
                              // Arahkan ke halaman detail surat
                              Navigator.pushNamed(
                                context,
                                '/detail',
                                arguments: surat.nomorSurat,
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
              ),
    );
  }
}
