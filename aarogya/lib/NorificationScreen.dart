import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationTestScreen extends StatefulWidget {
  @override
  _NotificationTestScreenState createState() => _NotificationTestScreenState();
}

class _NotificationTestScreenState extends State<NotificationTestScreen> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Initialize timezone data
    tz.initializeTimeZones();
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDateTime,
  }) async {
    // Convert DateTime to TZDateTime
    final tz.TZDateTime scheduledTime =
        tz.TZDateTime.from(scheduledDateTime, tz.local);

    // Define Android-specific notification details
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_id', // Unique channel ID
      'Scheduled Notifications', // Channel name
      channelDescription: 'Channel for scheduled notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void _testNotification() async {
    // Schedule a notification 10 seconds from now
    final DateTime now = DateTime.now();
    final DateTime scheduledDateTime = now.add(Duration(seconds: 10));

    await scheduleNotification(
      id: 1,
      title: 'Test Notification',
      body: 'This is a test notification scheduled 10 seconds from now.',
      scheduledDateTime: scheduledDateTime,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notification scheduled for 10 seconds later!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Notification'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _testNotification,
          child: Text('Schedule Test Notification'),
        ),
      ),
    );
  }
}
