import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lyon/v_done/utils/custom_log.dart';
import 'package:firebase_core/firebase_core.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();

    logInfo("Handling a background message: ${message.messageId}");
    displayNotification(message);
  }

  static Future<void> initialize(BuildContext context) async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      badge: true,
      alert: true,
      sound: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      iOS: DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      ),
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logInfo("Foreground message received: ${message.notification?.title}");
      displayNotification(message);
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  static void displayNotification(RemoteMessage message) {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "Lyoun_Channel", 
          "Lyon_Notifications",
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      );

      _notificationsPlugin.show(
        id,
        message.notification?.title ?? "No Title",
        message.notification?.body ?? "No Body",
        notificationDetails,
        payload: message.data['/NotificationScreen'], // Optional payload
      );
    } catch (e) {
      logError("Error displaying notification: $e");
      rethrow;
    }
  }
}
