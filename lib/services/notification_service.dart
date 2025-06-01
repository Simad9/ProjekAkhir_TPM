import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Inisialisasi notifikasi, channel, permission, dll
  }

  static Future<void> scheduleHafalanNotification(/* parameter */) async {
    // Jadwalkan notifikasi seperti contoh yang sudah saya berikan
  }

  static Future<void> cancelNotification(int id) async {
    // Batalkan notifikasi berdasarkan id
  }
}
