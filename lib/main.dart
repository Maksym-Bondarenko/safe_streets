import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:permission_handler/permission_handler.dart';

import 'app.dart';
import 'authentication/firebase_options.dart';

/// Start of the Program, here will be asked all permissions and run the app
void main() async {
  // load the environment variables
  await dotenv.load(fileName: "api_keys.env");

  // Request all the permissions needed by the app
  // await _requestPermissions();

  // for Firebase Authentication
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

// !!! ATTENTION: cause an error on iOS !!!
// Asking for all permissions
// Future<void> _requestPermissions() async {
//   // Request permission to access the device's location
//   await Permission.location.request();

//   // Request permission to access the device's storage
//   await Permission.storage.request();

//   await Permission.accessNotificationPolicy.request();

//   await Permission.notification.request();
// }
