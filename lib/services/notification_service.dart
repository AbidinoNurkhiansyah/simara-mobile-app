import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    await requestPermissions();
    await requestBatteryOptimizationPermission();
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestPermission();
    } else if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  Future<void> requestBatteryOptimizationPermission() async {
    if (Platform.isAndroid) {
      final androidImplementation =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      // Request untuk mengabaikan battery optimization
      await androidImplementation?.requestPermission();
    }
  }

  Future<void> scheduleReminders(String tanggal, int sesi) async {
    try {
      final date = DateTime.parse(tanggal);
      String waktuSesi = sesi == 1 ? '09:00' : '13:00';

      // Schedule notification for H-1 at 6:00 AM
      final dayBefore = date.subtract(const Duration(days: 1));
      final dayBeforeNotification = tz.TZDateTime.from(
        DateTime(dayBefore.year, dayBefore.month, dayBefore.day, 7, 0),
        tz.local,
      );

      // Schedule notification for H at 6:00 AM
      final dayOfNotification = tz.TZDateTime.from(
        DateTime(date.year, date.month, date.day, 7, 0),
        tz.local,
      );

      // Format date for notification message
      final dateFormat = DateFormat('dd MMMM yyyy');
      final formattedDate = dateFormat.format(date);

      const notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminder Notifications',
          channelDescription: 'Notifications for appointment reminders',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      final now = tz.TZDateTime.now(tz.local);
      // Tambahkan logging untuk debugging

      print('Scheduling notification for: ${dayBeforeNotification.toString()}');
      print('Current time: ${now.toString()}');
      print('Is notification valid: ${!dayBeforeNotification.isBefore(now)}');

      // Hanya jadwalkan notifikasi yang masih valid
      if (!dayBeforeNotification.isBefore(now)) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          0,
          'Pengingat Suscatin',
          'Besok pada tanggal $formattedDate pukul $waktuSesi Anda memiliki jadwal Suscatin',
          dayBeforeNotification,
          notificationDetails,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }

      if (!dayOfNotification.isBefore(now)) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          1,
          'Pengingat Suscatin',
          'Hari ini pada pukul $waktuSesi Anda memiliki jadwal Suscatin',
          dayOfNotification,
          notificationDetails,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    } catch (e) {
      print('Error scheduling notifications: $e');
      // Tidak melempar exception agar proses pemesanan tetap berjalan
    }
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> showBookingSuccessNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'booking_success_channel',
          'Booking Success Notifications',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0, // ID unik untuk notifikasi
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
