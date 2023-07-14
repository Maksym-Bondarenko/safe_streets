import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
import 'authentication/firebase_options.dart';

/// Start of the Program, here will be asked all permissions and run the app
void main() async {
  // load the environment variables
  await dotenv.load(fileName: "api_keys.env");

  // for Firebase Authentication
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // TODO: ensure and initialize local notifications
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientation to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}
