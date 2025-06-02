import 'package:projek_akhir_mobile/models/doa_model.dart';
import 'package:projek_akhir_mobile/models/surat_model.dart';
import 'package:projek_akhir_mobile/screens/auth/login_screen.dart';

// Services
import 'package:flutter/material.dart';
import 'package:projek_akhir_mobile/services/doa_network.dart';
import 'package:projek_akhir_mobile/services/surat_network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});
  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final _searchController = TextEditingController();
  late Future<List<dynamic>>
  _dataFuture; // Bisa List<Surat> atau List<DoaModel>
  bool _isLoading = false;
  bool _isSorting = false;
  bool _isSurat = true;

  @override
  void initState() {
    super.initState();
    _fetchData(isSurat: true);
  }

  Future<void> _fetchData({
    required bool isSurat,
    String? searchQuery,
    bool sortDesc = false,
  }) async {
    setState(() => _isLoading = true);

    try {
      if (isSurat) {
        if (searchQuery != null && searchQuery.isNotEmpty) {
          _dataFuture = SuratNetwork().searchSurat(searchQuery);
        } else if (sortDesc) {
          _dataFuture = SuratNetwork().sortDescSurat();
        } else {
          _dataFuture = SuratNetwork().getData();
        }
      } else {
        _dataFuture = DoaNetwork().getData();
      }

      _isSurat = isSurat;
      _isSorting = isSurat ? sortDesc : false;
    } catch (e) {
      debugPrint('Fetch data error: $e');
      // Bisa juga handle error lebih baik dengan setState error variable
      // dan tampilkan UI error khusus
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_token');
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  Widget _buildList<T>(List<T> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        if (_isSurat) {
          final surat = items[index] as Surat;
          return ListTile(
            title: Text(
              surat.namaLatin,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              surat.nama,
              style: TextStyle(color: Colors.grey[700]),
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/tambah',
                arguments: {'nomor': surat.nomor, 'nama': surat.namaLatin, 'tipe': 'surat'},
              );
            },
          );
        } else {
          final doa = items[index] as DoaModel;
          return ListTile(
            title: Text(
              doa.doa,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            subtitle: Text(doa.ayat, style: TextStyle(color: Colors.grey[700])),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/tambah',
                arguments: {'nomor': int.parse(doa.id), 'nama': doa.doa, 'tipe': 'doa'},
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Surat"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: logout),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => _fetchData(isSurat: true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          child: const Text("Surat"),
                        ),
                        ElevatedButton(
                          onPressed: () => _fetchData(isSurat: false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          child: const Text("Doa"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Cari Surat',
                            ),
                            onFieldSubmitted: (value) {
                              if (_isSurat)
                                _fetchData(isSurat: true, searchQuery: value);
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            if (_isSurat)
                              _fetchData(
                                isSurat: true,
                                searchQuery: _searchController.text,
                              );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            _isSorting
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                          ),
                          onPressed: () {
                            if (_isSurat) {
                              _fetchData(isSurat: true, sortDesc: !_isSorting);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: FutureBuilder<List<dynamic>>(
                        future: _dataFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(child: Text('No data found.'));
                          }
                          return _buildList(snapshot.data!);
                        },
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
