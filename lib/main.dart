import 'package:flutter/material.dart';
import 'package:projek_akhir_mobile/screens/navigasi_screen.dart';
// import 'screens/auth/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projek Akhir Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF4CA2FF)),
      ),
      home: const NavigasiScreen(),
    );
  }
}
