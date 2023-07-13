import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safe_streets/services/base_service.dart';

/// Service for showing user push-up notifications
/// contains permission-check, parameters setup and showing notification with given data
/// read more about flutter_local_notification here: https://pub.dev/packages/flutter_local_notifications
class NotificationsService extends BaseService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // checks the user's permissions for location and notifications and returns if they were granted
  Future<bool> checkPermissions() async {
    bool locationPermission = false;
    bool? androidNotificationPermission = false;

    // Request location permissions if not granted
    Geolocator.requestPermission();

    Geolocator.checkPermission().then((permission) {
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        Geolocator.requestPermission().then((newPermission) {
          if (newPermission == LocationPermission.whileInUse ||
              newPermission == LocationPermission.always) {
            locationPermission = true;
          }
        });
      } else if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        locationPermission = true;
      }
    });

    // Requesting permissions on Android 13 or higher
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    androidNotificationPermission = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.areNotificationsEnabled();

    // request permissions for iOS
    bool? iOSPermissions = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    // request permissions for macOS
    bool? macOSPermissions = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    // TODO: check on iOS/macOS + add 'iOSPermissions' / 'macOSPermissions'
    if (iOSPermissions == null || iOSPermissions == true) {
      iOSPermissions = true;
    }
    if (macOSPermissions == null || macOSPermissions == true) {
      macOSPermissions = true;
    }

    return locationPermission && androidNotificationPermission! && iOSPermissions && macOSPermissions;
  }

  // sets parameters and initializes notifications
  Future<void> initializeNotifications() async {
    // set icon on the android-notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            'ic_notification'); // ic_icon should be added as drawable resource to the Android head project
    // configure notification actions before the app is started using the initialize method on iOS/macOS
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    // On iOS/macOS, the notification category will define which actions are availble. On Android and Linux, you can put the actions directly in the AndroidNotificationDetails and LinuxNotificationDetails classes.
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    // apply settings
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        macOS: initializationSettingsDarwin,
        linux: initializationSettingsLinux);
    // initialize notification with provided parameters
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // for iOS
  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    print(id);
    print(title);
    print(body);
    print(payload);
  }

  // for iOS
  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  // shows on the user's device push-notification with provided title and description
  Future<void> showLocalNotification(String title, String description) async {
    // set meta-parameters for Android
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'safe_streets_notification_channel',
      'Safe Streets Push Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // // for Android v.8+
    // const AndroidNotificationChannel channel = AndroidNotificationChannel(
    //   'safe_streets_notification_channel',
    //   'Safe Streets Push Notifications',
    //   description: 'Channel description',
    //   importance: Importance.max,
    //   enableLights: true,
    //   enableVibration: true,
    //   playSound: true,
    //   showBadge: true,
    //   ledColor: Colors.blue
    // );
    //
    // await flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //     AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(channel);

    // show notification
    await FlutterLocalNotificationsPlugin().show(
      // Notification ID (you can use different IDs for different notifications)
      1,
      title,
      description,
      platformChannelSpecifics,
      payload:
          'notification_payload', // Optional, you can use it to handle tap events on the notification
    );
  }
}
