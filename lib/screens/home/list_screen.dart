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
  late Future<List<Surat>> _suratListFuture;

  @override
  void initState() {
    super.initState();
    _suratListFuture = SuratNetwork().getData();
  }

  void _fetchSuratList() async {
    setState(() {
      _suratListFuture = SuratNetwork().getData();
    });
    print("ditekan tombol surat");   
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Surat"),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () => logout()),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
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
            Expanded(
              child: FutureBuilder<List<Surat>>(
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
                        title: Text(surat.namaLatin),
                        subtitle: Text(surat.nama),
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
