import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SensorGyroScreen extends StatefulWidget {
  @override
  State<SensorGyroScreen> createState() => _SensorGyroScreenState();
}

class _SensorGyroScreenState extends State<SensorGyroScreen> {
  double _x = 0.0;
  double _y = 0.0;
  double _z = 0.0;

  @override
  void initState() {
    super.initState();
    cekSession();

    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _x = event.x;
        _y = event.y;
        _z = event.z;
      });
    });
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
      appBar: AppBar(title: const Text('Sensor Gyro'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            color: _x >= 5 || _x <= -5 ? Colors.red : Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tujuan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Halaman ini berguna untuk kamu yang mau test gyro pada Hp kamu. Pada projek ini berguna untuk selesai hafalan dengan sensor gyro',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 24),
                Text(
                  'Gyroscope Data:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Gyro X: ${_x.toStringAsFixed(3)}'),
                Text('Gyro Y: ${_y.toStringAsFixed(3)}'),
                Text('Gyro Z: ${_z.toStringAsFixed(3)}'),
                SizedBox(height: 24),
                Text(
                  'Implementasi pada Aplikasi:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: _x >= 5 || _x <= -5 ? Colors.red : Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.all(18),
                  alignment: Alignment.center,
                  child: Text(
                    _x >= 5 || _x <= -5 ? "Belum Selesai" : "Selesai",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
