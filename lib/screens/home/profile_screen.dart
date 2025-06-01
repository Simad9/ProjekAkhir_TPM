// profile_screen.dart
import 'package:flutter/material.dart';
import 'package:projek_akhir_mobile/screens/pages/sensor_gyro_screen.dart';
import 'package:projek_akhir_mobile/components/menu_list.dart';
// Import main.dart untuk mengakses instance global notificationService
import 'package:projek_akhir_mobile/main.dart';

// Services
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projek_akhir_mobile/screens/auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        title: Text("Profile"),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () => logout()),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 8),
            MenuList(
              title: "Profil",
              icon: Icons.person,
              onPress: () {
                Navigator.pushNamed(context, '/dev');
              },
            ),
            SizedBox(height: 16),
            MenuList(
              title: "Kesan dan Pesan",
              icon: Icons.feedback,
              onPress: () {
                Navigator.pushNamed(context, '/kesan');
              },
            ),
            SizedBox(height: 16),
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
            SizedBox(height: 16),
            MenuList(
              title: "Berlanganan",
              icon: Icons.money,
              onPress: () {
                Navigator.pushNamed(context, '/berlanganan');
              },
            ),
            SizedBox(height: 16),
            MenuList(
              title: "Test Notifikasi",
              icon: Icons.notifications_active,
              onPress: () async {
                DateTime now = DateTime.now();
                DateTime testTime = now.add(
                  Duration(seconds: 1),
                ); // Coba 2 detik
                await notificationService.scheduleHafalanNotification(
                  id: 123,
                  title: 'Test Notifikasi Instan',
                  body: 'Ini notifikasi testing segera!',
                  scheduledDate: testTime,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
