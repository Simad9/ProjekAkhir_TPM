import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

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
    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _x = event.x;
        _y = event.y;
        _z = event.z;
      });
    });
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
                  'Sensor Gyro Screen',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'This screen is designed to display information related to the gyroscope sensor.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 32),
                Text(
                  'Gyroscope Data:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Gyro X: ${_x.toStringAsFixed(3)}'),
                Text('Gyro Y: ${_y.toStringAsFixed(3)}'),
                Text('Gyro Z: ${_z.toStringAsFixed(3)}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
