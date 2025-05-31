import 'package:flutter/material.dart';
import 'package:projek_akhir_mobile/screens/auth/login_screen.dart';
import 'package:projek_akhir_mobile/screens/navigasi_screen.dart';
import 'package:projek_akhir_mobile/screens/pages/detail_hafalan_screen.dart';
import 'package:projek_akhir_mobile/screens/pages/tambah_screen.dart';
// import 'screens/auth/login_screen.dart';

// Testing
import 'package:projek_akhir_mobile/screens/auth/register_screen.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => NavigasiScreen(),
        '/tambah': (context) => TambahScreen(),
        '/detail': (context) => DetailHafalanScreen(),
      },
    );
  }
}
