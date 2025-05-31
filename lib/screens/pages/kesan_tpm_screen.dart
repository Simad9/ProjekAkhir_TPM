import 'package:flutter/material.dart';

class KesanTpmScreen extends StatelessWidget {
  const KesanTpmScreen({super.key});

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
              Text(
                "Kesan: Pengalaman baru untuk belajar Mobile. Walau gak jago jago amat tapi setidaknya pernah merasakan bikin aplikasi mobile pake flutter",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
