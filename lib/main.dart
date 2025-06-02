import 'package:flutter/material.dart';
import 'package:projek_akhir_mobile/screens/auth/login_screen.dart';
import 'package:projek_akhir_mobile/screens/auth/register_screen.dart';
import 'package:projek_akhir_mobile/screens/home/profile_screen.dart';
import 'package:projek_akhir_mobile/screens/navigasi_screen.dart';
import 'package:projek_akhir_mobile/screens/pages/berlanganan_screen.dart';
import 'package:projek_akhir_mobile/screens/pages/detail_hafalan_screen.dart';
import 'package:projek_akhir_mobile/screens/pages/developer_screen.dart';
import 'package:projek_akhir_mobile/screens/pages/jadwal_pembayaran_screen.dart';
import 'package:projek_akhir_mobile/screens/pages/kesan_tpm_screen.dart';
import 'package:projek_akhir_mobile/screens/pages/list_hafalan_screen.dart';
import 'package:projek_akhir_mobile/screens/pages/list_user_screen.dart';
import 'package:projek_akhir_mobile/screens/pages/tambah_screen.dart';
import 'package:projek_akhir_mobile/services/notification_service.dart';

// Deklarasi GLOBAL untuk NotificationService dan GlobalKey
late NotificationService notificationService;
final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>(); // PENTING: ini harus ada dan global

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  notificationService =
      NotificationService(); // PENTING: inisialisasi instance global
  await notificationService.init(); // Panggil init() pada instance global
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // PENTING: berikan globalKey ke MaterialApp
      title: 'Projek Akhir Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF4CA2FF)),
      ),
      initialRoute: '/home',
      routes: {
        '/': (context) => LoginScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => NavigasiScreen(),
        '/profile': (context) => ProfileScreen(),
        '/tambah': (context) => TambahScreen(),
        '/detail': (context) => DetailHafalanScreen(),
        '/dev': (context) => DeveloperScreen(),
        '/kesan': (context) => KesanTpmScreen(),
        '/berlanganan': (context) => BerlangananScreen(),
        '/jadwal': (context) => JadwalPembayaranScreen(),
        '/user': (context) => ListUserScreen(),
        '/hafalan': (context) => ListHafalanScreen(),
      },
    );
  }
}
