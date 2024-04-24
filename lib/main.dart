import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:safe_streets/app.dart';
import 'package:safe_streets/services/firebase_options.dart';

/// Start of the program, here will be asked all permissions and run the app
void main() async {
  // load the environment variables
  await dotenv.load(fileName: "api_keys.env");

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
  await Permission.storage.request();
  await Permission.accessNotificationPolicy.request();
  await Permission.notification.request();

  final status = await Permission.locationWhenInUse.request();

  if (status.isPermanentlyDenied) {
    await openAppSettings();
  }
}
