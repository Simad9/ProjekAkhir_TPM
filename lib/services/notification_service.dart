import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:flutter/material.dart'; // Penting untuk showDialog dan debugPrint

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin =>
      _flutterLocalNotificationsPlugin;

  Future<void> init() async {
    tzdata.initializeTimeZones();

    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      // iOS: DarwinInitializationSettings(), // Uncomment and configure if supporting iOS
      // macOS: DarwinInitializationSettings(), // Uncomment and configure if supporting macOS
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (
        NotificationResponse notificationResponse,
      ) async {
        final String? payload = notificationResponse.payload;
        if (payload != null) {
          debugPrint('notification payload: $payload');
          // Contoh navigasi berdasarkan payload:
          // if (navigatorKey.currentState != null) {
          //   navigatorKey.currentState?.pushNamed('/detail', arguments: payload);
          // }
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidImplementation != null) {
      bool granted =
          await androidImplementation.requestNotificationsPermission() ?? false;
      debugPrint('Notification permission granted: $granted');

      // Exact alarm permission check is not available in the current plugin version.
      // If you need to handle exact alarm permissions, use platform-specific code or another package.
    }
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(
    NotificationResponse notificationResponse,
  ) {
    debugPrint(
      'background notification payload: ${notificationResponse.payload}',
    );
    // Anda tidak bisa langsung memperbarui UI dari sini. Ini untuk tugas latar belakang.
  }

  Future<void> scheduleHafalanNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    debugPrint(
      'Scheduling notification: ID=$id, Title=$title, Body=$body, Date=$scheduledDate',
    );
    final tz.TZDateTime tzScheduledDate = tz.TZDateTime.from(
      scheduledDate,
      tz.local,
    );
    debugPrint('TZ Scheduled Date: $tzScheduledDate (using local timezone)');

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'hafalan_channel',
          'Pengingat Hafalan',
          channelDescription: 'Notifikasi pengingat waktu hafalan hampir habis',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduledDate,
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
        payload: payload,
      );
      debugPrint('Notification scheduled successfully for ID: $id');
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
      // Tangani error, misalnya beritahu user bahwa notifikasi tidak dapat dijadwalkan
    }
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
    debugPrint('Notification cancelled for ID: $id');
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    debugPrint('All notifications cancelled.');
  }
}
