import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:go_router/go_router.dart';
import 'package:safe_streets/router.dart';

import 'package:safe_streets/views/intro/intro_page.dart';

/// Authentication page (via mail or Google SSI)
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    // StreamBuilder to handle authentication state changes
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Check if user is not authenticated
        if (!snapshot.hasData) {
          return SignInScreen(
            providerConfigs: const [
              EmailProviderConfiguration(),
              GoogleProviderConfiguration(
                  clientId:
                      "721653983645-tf0jcvomt95vakv9o6h8fome21d414bp.apps.googleusercontent.com"),
            ],
            // Header builder for the sign-in screen
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset('assets/images/logo_big.png'),
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
                            context.pushNamed(AppRoutes.termsAndConditions);
                          },
                      ),
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
                  child: Image.asset('assets/images/logo_big.png'),
                ),
              );
            },
          );
        }

        // If user is authenticated, show the IntroPage widget
        return const IntroPage();
      },
    );
  }
}
