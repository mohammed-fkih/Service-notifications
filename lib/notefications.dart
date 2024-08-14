import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) async {
        // إضافة الاكشن المطلوب عند النقر على التنبيه هنا
      },
    );
  }

  Future<void> scheduleNotification(
      String itemId, DateTime notificationDate) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'تنبيه',
      'أنت بحاجة إلى القيام بشيء',
      tz.TZDateTime.from(notificationDate, tz.local),
      platformChannelSpecifics,
      // ignore: deprecated_member_use
      androidAllowWhileIdle: true,
      payload: itemId,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}

class ItemDetailsScreen extends StatelessWidget {
  final String itemId;
  final DateTime itemDate;

  const ItemDetailsScreen({super.key, required this.itemId, required this.itemDate});

  Future<void> scheduleNotification() async {
    final notificationManager = NotificationManager();
    await notificationManager.init();
    await notificationManager.scheduleNotification(itemId, itemDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل العنصر'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            scheduleNotification();
          },
          child: const Text('تجدول تنبيه'),
        ),
      ),
    );
  }
}
