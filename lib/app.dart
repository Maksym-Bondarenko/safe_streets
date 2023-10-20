import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/other_pages/dds_map.dart';
import 'package:safe_streets/other_pages/legal/privacy_policy.dart';
import 'package:safe_streets/other_pages/settings/settings_page.dart';
import 'package:safe_streets/main_pages/map/filter_map.dart';
import 'package:safe_streets/main_pages/support_page.dart';
import 'package:safe_streets/shared/app_state.dart';
import 'package:safe_streets/shared/theme_data.dart';
import 'package:safe_streets/ui/fake_call/fake_call.dart';

import 'authentication/auth_gate.dart';
import 'i18n/app_locale.dart';
import 'main_pages/channels/news_channel_page.dart';
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
  AppState themeChangeProvider = AppState();

  @override
  void initState() {
    // get theme (dark/light)
    getCurrentAppTheme();
    // get localization
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

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
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
          builder: (BuildContext context, AppState appStateProvider, _) {
        final mapController = appStateProvider.controller;
        final isDarkTheme = appStateProvider.darkTheme;

        // MaterialApp widget represents the root of application
        return MaterialApp(
          supportedLocales: _localization.supportedLocales,
          localizationsDelegates: _localization.localizationsDelegates,
          title: "SafeStreets",
          theme: Styles.themeData(isDarkTheme, context),
          // define routes via names to enable navigation by 'Navigator.pushNamed'
          initialRoute: '/',
          routes: <String, WidgetBuilder> {
            '/intro': (context) => const IntroSlider(),
            '/auth': (context) => AuthGate(),
            // '/home': (context) => const HomePage(),
            '/profile': (context) => const ProfilePage(),
            '/filterMap': (context) =>
                FilterMap(googleMapController: mapController),
            '/channels': (context) => const NewsChannelPage(),
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
              case '/filterMap':
                appState.setIndex(0);
                return MaterialPageRoute(builder: (_) => FilterMap(googleMapController: mapController));
              // case '/home':
              //   // setIndex of the BottomNavigationBar from AppState
              //   appState.setIndex(0);
              //   return MaterialPageRoute(builder: (_) => const HomePage());
              case '/support':
                appState.setIndex(1);
                return MaterialPageRoute(builder: (_) => const SupportPage());
              case '/channels':
                appState.setIndex(2);
                return MaterialPageRoute(builder: (_) => const NewsChannelPage());
              case '/profile':
                appState.setIndex(3);
                return MaterialPageRoute(builder: (_) => const ProfilePage());
              default:
                // Handle 404 - Page Not Found
                return MaterialPageRoute(builder: (_) => const NotFoundPage());
            }
          },
          home: AuthGate(),
          // Disable the debug mode banner
          debugShowCheckedModeBanner: false,
        );
      }),
    );
  }
}
