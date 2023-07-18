import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/other_pages/dds_map.dart';
import 'package:safe_streets/other_pages/settings_page.dart';
import 'package:safe_streets/main_pages/filter_map.dart';
import 'package:safe_streets/main_pages/support_page.dart';
import 'package:safe_streets/shared/app_state.dart';
import 'package:safe_streets/ui/fake_call/fake_call.dart';
import 'package:safe_streets/ui/page_animation/custom_page_transition.dart';

import 'authentication/auth_gate.dart';
import 'i18n/app_locale.dart';
import 'main_pages/forum/forum_page.dart';
import 'main_pages/home_page.dart';
import 'main_pages/profile_page.dart';
import 'other_pages/ai_camera.dart';
import 'other_pages/edit_user_details_page.dart';

/// Here the app is built and navigated to the @{AuthGate}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization _localization = FlutterLocalization.instance;

  @override
  void initState() {
    _localization.init(
      mapLocales: [
        const MapLocale(
          'en',
          AppLocale.EN,
          countryCode: 'US',
          fontFamily: 'Font EN',
        ),
        const MapLocale(
          'de',
          AppLocale.DE,
          countryCode: 'DE',
          fontFamily: 'Font DE',
        ),
      ],
      initLanguageCode: 'en',
    );
    _localization.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
  }

  // the setState function here is a must to add
  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Notifier for providing global access to the Google Maps Controller
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      // MaterialApp widget represents the root of application
      child: Consumer<AppState>(
          builder: (context, appStateProvider, _) {
        final mapController = appStateProvider.controller;
        return MaterialApp(
          supportedLocales: _localization.supportedLocales,
          localizationsDelegates: _localization.localizationsDelegates,
          title: "SafeStreets",
          // Define the theme for application
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColorDark: Colors.indigo,
            primaryColor: Colors.lightBlue,
            scaffoldBackgroundColor: Colors.white,
            useMaterial3: false,
            // for custom page-transition
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionsBuilder(),
                TargetPlatform.iOS: CustomPageTransitionsBuilder(),
              },
            ),
          ),
          initialRoute: '/',
          routes: {
            '/intro': (context) => const IntroSlider(),
            '/auth': (context) => AuthGate(),
            '/home': (context) => const HomePage(),
            '/profile': (context) => const ProfilePage(),
            '/filterMap': (context) =>
                FilterMap(googleMapController: mapController),
            '/forum': (context) => const ForumPage(),
            '/support': (context) => const SupportPage(),
            '/settings': (context) => const SettingsPage(),
            '/ddsMap': (context) => const DDSMap(),
            '/edit_user': (context) => const EditUserDetailsPage(),
            '/fakeCall': (context) => const FakeCallWidget(callerName: 'Honey'),
            '/ai_camera': (context) => const AiCameraPage(),
          },
          // handle the case where FilterMap is accessed from other places.
          onGenerateRoute: (settings) {
            if (settings.name == '/filterMap') {
              return MaterialPageRoute(
                builder: (context) => FilterMap(googleMapController: mapController), // Pass the controller to FilterMap
              );
            }
            return null;
          },
          // Set AuthGate as the initial screen of application
          home: AuthGate(),
          // Disable the debug mode banner
          debugShowCheckedModeBanner: false,
        );
      }),
    );
  }
}
