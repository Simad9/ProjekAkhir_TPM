import 'package:flutter/material.dart';
import 'package:projek_akhir_mobile/services/doa_network.dart';
import 'package:projek_akhir_mobile/services/surat_network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projek_akhir_mobile/models/surat_model.dart';
import 'package:projek_akhir_mobile/models/doa_model.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final _searchController = TextEditingController();
  late Future<List<dynamic>> _dataFuture;
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
      print(searchQuery);
      if (isSurat) {
        if (searchQuery != null && searchQuery.isNotEmpty) {
          _dataFuture = SuratNetwork().searchSurat(searchQuery);
        } else if (sortDesc) {
          print("serting");
          _dataFuture = SuratNetwork().sortDescSurat();
        } else {
          _dataFuture = SuratNetwork().getData();
        }
      } else {
        if (searchQuery != null && searchQuery.isNotEmpty) {
          print("cari doa");
          _dataFuture = DoaNetwork().searchDoa(searchQuery);
        } else if (sortDesc) {
          print("serting");
          _dataFuture = DoaNetwork().sortDescSurat();
        } else {
          _dataFuture = DoaNetwork().getData();
        }
      }

      _isSurat = isSurat;
      _isSorting = isSurat ? sortDesc : false;
    } catch (e) {
      debugPrint('Fetch data error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_token');
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  Widget _buildList<T>(List<T> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        if (_isSurat) {
          final surat = items[index] as Surat;
          return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  surat.namaLatin,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  surat.nama,
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
              ],
            ),
            subtitle: Column(
              children: [
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Arti: ${surat.arti}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      'Jumlah Ayat: ${surat.jumlahAyat}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/tambah',
                arguments: {
                  'nomor': surat.nomor,
                  'nama': surat.namaLatin,
                  'tipe': 'surat',
                },
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
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //     Text(doa.ayat, style: TextStyle(color: Colors.grey[700])),
                //     SizedBox(height: 6),
                //     Text(
                //       'Latin: ${doa.latin}',
                //       style: TextStyle(color: Colors.grey[600]),
                //     ),
                SizedBox(height: 2),
                Text(
                  'Artinya: ${doa.artinya}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/tambah',
                arguments: {
                  'nomor': int.parse(doa.id),
                  'nama': doa.doa,
                  'tipe': 'doa',
                },
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
        title: const Text("List Surat dan Doa"),
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
                              labelText: 'Cari Surat atau Doa',
                            ),
                            onFieldSubmitted: (value) {
                              if (_isSurat) {
                                _fetchData(isSurat: true, searchQuery: value);
                              } else {
                                _fetchData(isSurat: false, searchQuery: value);
                              }
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            if (_isSurat) {
                              _fetchData(
                                isSurat: true,
                                searchQuery: _searchController.text,
                              );
                            } else {
                              _fetchData(
                                isSurat: false,
                                searchQuery: _searchController.text,
                              );
                            }
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
                            } else {
                              _fetchData(isSurat: false, sortDesc: !_isSorting);
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
