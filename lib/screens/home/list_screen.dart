import 'package:projek_akhir_mobile/models/surat_model.dart';
import 'package:projek_akhir_mobile/screens/auth/login_screen.dart';

// Services
import 'package:flutter/material.dart';
import 'package:projek_akhir_mobile/services/surat_network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});
  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final _searchController = TextEditingController();
  late Future<List<Surat>> _suratListFuture;
  bool _isLoading = false;
  bool _isSorting = false;

  @override
  void initState() {
    super.initState();
    _suratListFuture = SuratNetwork().getData();
  }

  void _fetchSuratList() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _suratListFuture = SuratNetwork().getData();
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _fetchDoaList() async {
    print("Nanti ambil data doa");
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

  void _searchSurat(String query) async {
    setState(() {
      _isLoading = true;
    });
    try {
      _suratListFuture = SuratNetwork().searchSurat(query);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _sortDescSurat() async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (_isSorting) {
        _suratListFuture = SuratNetwork().getData();
        _isSorting = false;
      } else {
        _suratListFuture = SuratNetwork().sortDescSurat();
        _isSorting = true;
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Surat"),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () => logout()),
        ],
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => _fetchSuratList(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          child: Text("Surat"),
                        ),
                        ElevatedButton(
                          onPressed: () => _fetchDoaList(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          child: Text("Doa"),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Cari Surat',
                            ),
                            onFieldSubmitted: (value) {
                              _searchSurat(value);
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            _searchSurat(_searchController.text);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            _isSorting
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                          ),
                          onPressed: () => _sortDescSurat(),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Expanded(
                      child: FutureBuilder<List<Surat>>(
                        future: _suratListFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(child: Text('No movies found.'));
                          }

                          final suratList = snapshot.data!;

                          return ListView.builder(
                            itemCount: suratList.length,
                            itemBuilder: (context, index) {
                              final surat = suratList[index];
                              return ListTile(
                                title: Text(
                                  surat.namaLatin,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Colors
                                            .black, // pastikan warna teks hitam
                                  ),
                                ),
                                subtitle: Text(
                                  surat
                                      .nama, // tampilkan nama asli Arab di subtitle
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/tambah',
                                    arguments: {
                                      'nomor': surat.nomor,
                                      'nama': surat.namaLatin,
                                    },
                                  );
                                },
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
