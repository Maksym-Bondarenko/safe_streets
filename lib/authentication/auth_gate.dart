import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

import '../info_pages/terms_and_conditions.dart';
import '../intro_slider/intro_slider.dart';

/// Authentication page (via mail or Google SSI)
class AuthGate extends StatelessWidget {
  AuthGate({super.key});

  // TODO: custom login page with wait for email validation (https://medium.flutterdevs.com/email-verification-with-flutter-firebase-e127aad393c3)
  // https://firebase.flutter.dev/docs/auth/usage/
  // TODO: add iOS auth (https://firebase.google.com/docs/auth/ios/email-link-auth?hl=en&authuser=0)
  final ActionCodeSettings acs = ActionCodeSettings(
    // URL you want to redirect back to. The domain (www.example.com) for this
    // URL must be whitelisted in the Firebase Console.
      url: 'https://mysafestreets.org/',
      dynamicLinkDomain: 'https://mysafestreets.page.link/RtQw',
      androidPackageName: 'com.example.safe_streets',
      iOSBundleId: 'com.example.safeStreets',
      handleCodeInApp: true,
      androidInstallApp: true,
      androidMinimumVersion: '12');

  @override
  Widget build(BuildContext context) {
    // StreamBuilder to handle authentication state changes
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Check if user is not authenticated
        if (!snapshot.hasData) {
          return SignInScreen(
            providerConfigs: [
              // const EmailProviderConfiguration(),
              // EmailLinkProviderConfiguration(actionCodeSettings: acs),
              const GoogleProviderConfiguration(
                  clientId:
                      "721653983645-tf0jcvomt95vakv9o6h8fome21d414bp.apps.googleusercontent.com"),
            ],
            // Header builder for the sign-in screen
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset('lib/assets/images/logo_big.png'),
                ),
              );
            },
            // Subtitle builder for the sign-in screen
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: action == AuthAction.signIn
                    ? const Text('Welcome to SafeStreets, please sign in!')
                    : const Text('Welcome to SafeStreets, please sign up!'),
              );
            },
            // Footer builder for the sign-in screen
            footerBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.grey),
                    children: <TextSpan>[
                      const TextSpan(text: 'By signing in, you agree to our '),
                      TextSpan(
                          text: 'Terms and Conditions',
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigate to the Terms and Conditions page
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const TermsAndConditions()));
                            }),
                    ],
                  ),
                ),
              );
            },
            // Side builder for the sign-in screen (for big screens/monitors)
            sideBuilder: (context, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset('lib/assets/images/logo_big.png'),
                ),
              );
            },
          );
        }
        // If user is authenticated, show the IntroSliderRules widget
        return const IntroSliderRules();
      },
    );
  }
}
