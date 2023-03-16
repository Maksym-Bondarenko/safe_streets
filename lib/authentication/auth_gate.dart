import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

import '../intro_slider/intro_slider.dart';


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providerConfigs: const [
              EmailProviderConfiguration(),
              GoogleProviderConfiguration(
                clientId: "721653983645-tf0jcvomt95vakv9o6h8fome21d414bp.apps.googleusercontent.com"
              ),
            ],
            headerBuilder: (context, constraints, shrinkOffset
                ) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset('lib/assets/images/logo_big.png'),
                ),
              );
            },
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: action == AuthAction.signIn
                    ? const Text('Welcome to SafeStreets, please sign in!')
                    : const Text('Welcome to SafeStreets, please sign up!'),
              );
            },
            footerBuilder: (context, action) {
              return const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'By signing in, you agree to our terms and conditions.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            },
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

        return const IntroSliderRules();
      },
    );
  }
}