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
    cekSession();
    _fetchData(isSurat: true);
  }

  Future<void> cekSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionToken = prefs.getString('session_token');
    String? username = prefs.getString('username');

    if (sessionToken == null || username == null) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
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
        if (searchQuery != null && searchQuery.isNotEmpty) {
          _dataFuture = DoaNetwork().searchDoa(searchQuery);
        } else if (sortDesc) {
          _dataFuture = DoaNetwork().sortDescDoa();
        } else {
          _dataFuture = DoaNetwork().getData();
        }
      }

      setState(() {
        _isSurat = isSurat;
        _isSorting = sortDesc;
      });
    } catch (e) {
      debugPrint('Fetch data error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_token');
    await prefs.remove('username');
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
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${surat.arti} | ',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(
                        '${surat.jumlahAyat} Ayat',
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
            ),
          );
        } else {
          final doa = items[index] as DoaModel;
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
            ),
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
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _fetchData(isSurat: true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  _isSurat ? Colors.blue : Colors.white,
                              foregroundColor:
                                  _isSurat ? Colors.white : Colors.black,
                            ),
                            child: const Text("Surat"),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _fetchData(isSurat: false),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  !_isSurat ? Colors.blue : Colors.white,
                              foregroundColor:
                                  !_isSurat ? Colors.white : Colors.black,
                            ),
                            child: const Text("Doa"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: TextFormField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                label: Text("Cari Surat atau Doa"),
                              ),
                              onFieldSubmitted: (value) {
                                if (_isSurat) {
                                  _fetchData(isSurat: true, searchQuery: value);
                                } else {
                                  _fetchData(
                                    isSurat: false,
                                    searchQuery: value,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        // Button Search
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: IconButton(
                            color: Colors.black,
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
                        ),
                        SizedBox(width: 5),
                        // Button Sorting
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: IconButton(
                            color: Colors.black,
                            icon: Icon(
                              _isSorting
                                  ? Icons.arrow_upward_rounded
                                  : Icons.arrow_downward_rounded,
                            ),
                            onPressed: () {
                              if (_isSurat) {
                                _fetchData(
                                  isSurat: true,
                                  sortDesc: !_isSorting,
                                );
                              } else {
                                _fetchData(
                                  isSurat: false,
                                  sortDesc: !_isSorting,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // List nya
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
