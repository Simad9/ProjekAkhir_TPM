import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeveloperScreen extends StatefulWidget {
  const DeveloperScreen({super.key});

  @override
  State<DeveloperScreen> createState() => _DeveloperScreenState();
}

class _DeveloperScreenState extends State<DeveloperScreen> {
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
      appBar: AppBar(title: const Text('Developer Page'), centerTitle: true),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _anggotaList(
              "lib/assets/images/wijdan.JPG",
              "Wijdan Akhmad S",
              "123220010",
            ),
          ],
        ),
      ),
    );
  }

  Widget _anggotaList(String path, String nama, String nim) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  path,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nama,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text("NIM : $nim"),
            ],
          ),
        ],
      ),
    );
  }
}
