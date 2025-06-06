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

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kesan & Pesan : ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Terimakasih kepada Pak Bagus yang telah memberikan kesempatan bagi kita untuk belajar membuat aplikasi mobile menggunakan flutter. Semoga ilmu yang kita dapatkan dapat bermanfaat untuk kehidupan kita di masa depan. Walau banyak strugle nya hehe",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
