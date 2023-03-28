import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app.dart';
import 'authentication/firebase_options.dart';

void main() async {
  // Request all the permissions needed by the app
  await _requestPermissions();

  // for Firebase Authentication
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

// Asking for all permissions
Future<void> _requestPermissions() async {
  // Request permission to access the device's location
  await Permission.location.request();

  // Request permission to access the device's storage
  await Permission.storage.request();

  await Permission.accessNotificationPolicy.request();

  await Permission.notification.request();
}
