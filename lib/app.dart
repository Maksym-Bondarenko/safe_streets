import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/other_pages/dds_map.dart';
import 'package:safe_streets/other_pages/legal/privacy_policy.dart';
import 'package:safe_streets/other_pages/settings/settings_page.dart';
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
import 'other_pages/faq_page.dart';
import 'other_pages/legal/terms_and_conditions.dart';
import 'other_pages/newsletter_page.dart';
import 'other_pages/not_found_page.dart';
import 'other_pages/settings/screens/account_activity_screen.dart';
import 'other_pages/settings/screens/account_settings.dart';
import 'other_pages/settings/screens/email_sender.dart';
import 'other_pages/settings/screens/help_support_screen.dart';

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
      create: (context) => AppState(),
      child: Consumer<AppState>(
          builder: (context, appStateProvider, _) {
        final mapController = appStateProvider.controller;
        // MaterialApp widget represents the root of application
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
          // define routes via names to enable navigation by 'Navigator.pushNamed'
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
            '/account_settings': (context) => const AccountSettingsScreen(),
            '/ddsMap': (context) => const DDSMap(),
            '/fakeCall': (context) => const FakeCallWidget(callerName: 'Honey'),
            '/ai_camera': (context) => const AiCameraPage(),
            '/terms_and_conditions': (context) => const TermsAndConditions(),
            '/privacy_policy': (context) => const PrivacyPolicy(),
            '/faq': (context) => const FaqPage(),
            '/account_activity': (context) => const AccountActivityScreen(),
            '/help_support': (context) => const HelpSupportScreen(),
            '/email': (context) => const EmailSender(),
            '/newsletter': (context) => NewsletterPage(),
            '/not_found': (context) => const NotFoundPage(),
          },
          // for right updates of active-page in BottomNavigationBar
          // and handle the case where FilterMap is accessed from other places
          onGenerateRoute: (settings) {
            final appState = Provider.of<AppState>(context, listen: false);

            switch (settings.name) {
              case '/':
              case '/home':
                // setIndex of the BottomNavigationBar from AppState
                appState.setIndex(0);
                return MaterialPageRoute(builder: (_) => const HomePage());
              case '/support':
                appState.setIndex(1);
                return MaterialPageRoute(builder: (_) => const SupportPage());
              case '/forum':
                appState.setIndex(2);
                return MaterialPageRoute(builder: (_) => const ForumPage());
              case '/filterMap':
                appState.setIndex(3);
                return MaterialPageRoute(builder: (_) => FilterMap(googleMapController: mapController));
              case '/profile':
                appState.setIndex(4);
                return MaterialPageRoute(builder: (_) => const ProfilePage());
              case '/settings':
                appState.setIndex(5);
                return MaterialPageRoute(builder: (_) => const SettingsPage());
              default:
                // Handle 404 - Page Not Found
                return MaterialPageRoute(builder: (_) => const NotFoundPage());
            }
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
