import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KesanTpmScreen extends StatefulWidget {
  const KesanTpmScreen({super.key});

  @override
  State<KesanTpmScreen> createState() => _KesanTpmScreenState();
}

class _KesanTpmScreenState extends State<KesanTpmScreen> {
  @override
  void initState() {
    super.initState();
    cekSession();
  }

  Future<void> cekSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionToken = prefs.getString('session_token');
    String? username = prefs.getString('username');

    if (sessionToken == null || username == null) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kesan Pesan Page'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                "Kesan dan Pesan terhadap TPM",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Kesan: ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      "Pengalaman baru untuk belajar Mobile. Walau gak jago jago amat tapi setidaknya pernah merasakan bikin aplikasi mobile pake flutter",
                      style: TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Pesan: ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      "Untuk matkul mobile, projek akhirnya dikasih tau lebih awal + kriteria, biar mahasiswanya gak teteran dengan projek projek yang lain. Itu pesan saya, dan sepertinya salah saya juga gak bisa manage waktu sih",
                      style: TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
