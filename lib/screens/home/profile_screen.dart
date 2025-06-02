import 'package:flutter/material.dart';
import 'package:projek_akhir_mobile/screens/pages/sensor_gyro_screen.dart';
import 'package:projek_akhir_mobile/components/menu_list.dart';
import 'package:projek_akhir_mobile/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projek_akhir_mobile/screens/auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final NotificationService _notificationService = NotificationService();

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

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_token'); // Hapus session token
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  Future<void> _showNotification() async {
    await _notificationService.showNotification(
      id: 0,
      title: 'Aplikasi Hafalan',
      body: 'Notifikasi Aplikasi muncul, tapi ini hanya testing',
      payload: 'data tambahan',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: () => logout()),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            MenuList(
              title: "Profil",
              icon: Icons.person,
              onPress: () {
                Navigator.pushNamed(context, '/dev');
              },
            ),
            const SizedBox(height: 16),
            MenuList(
              title: "Kesan dan Pesan",
              icon: Icons.feedback,
              onPress: () {
                Navigator.pushNamed(context, '/kesan');
              },
            ),
            const SizedBox(height: 16),
            MenuList(
              title: "Sensor Gyro - Baguskah Posisi Menghafal",
              icon: Icons.edgesensor_high,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SensorGyroScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            MenuList(
              title: "Berlanganan",
              icon: Icons.money,
              onPress: () {
                Navigator.pushNamed(context, '/berlanganan');
              },
            ),
            const SizedBox(height: 16),
            MenuList(
              title: "List Akun",
              icon: Icons.group,
              onPress: () {
                Navigator.pushNamed(context, '/user');
              },
            ),
            const SizedBox(height: 16),
            MenuList(
              title: "List Hafalan",
              icon: Icons.book,
              onPress: () {
                Navigator.pushNamed(context, '/hafalan');
              },
            ),
            const SizedBox(height: 16),
            MenuList(
              title: "Test Notifikasi",
              icon: Icons.notifications_active,
              onPress: () async {
                await _showNotification();
              },
            ),
          ],
        ),
      ),
    );
  }
}
