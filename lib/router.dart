import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:safe_streets/views/auth/auth_page.dart';
import 'package:safe_streets/views/auth/terms_and_conditions_page.dart';
import 'package:safe_streets/views/forum/forum_page.dart';
import 'package:safe_streets/views/info/info_page.dart';
// import 'package:safe_streets/main/dds_map.dart';
import 'package:safe_streets/views/map/map_page.dart';
import 'package:safe_streets/views/map/route_page.dart';
import 'package:safe_streets/views/main/main_tabs.dart';
import 'package:safe_streets/views/profile/contact_support_page.dart';
import 'package:safe_streets/views/profile/edit_profile_page.dart';
import 'package:safe_streets/views/profile/faq_page.dart';
import 'package:safe_streets/views/profile/profile_page.dart';
import 'package:safe_streets/views/profile/settings_page.dart';

class AppRouter {
  static final AppRouter _instance = AppRouter._internal();
  static late final GoRouter router;

  final _appNavigatorKey = GlobalKey<NavigatorState>();
  final _mapTabNavigatorKey = GlobalKey<NavigatorState>();
  final _infoTabNavigatorKey = GlobalKey<NavigatorState>();
  final _forumTabNavigatorKey = GlobalKey<NavigatorState>();
  final _profileTabNavigatorKey = GlobalKey<NavigatorState>();

  factory AppRouter() {
    return _instance;
  }

  AppRouter._internal() {
    final routes = [
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _appNavigatorKey,
        branches: [
          StatefulShellBranch(
            navigatorKey: _mapTabNavigatorKey,
            routes: [
              GoRoute(
                path: '/map',
                name: AppRoutes.map,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: MapPage(),
                ),
                routes: [
                  GoRoute(
                    path: 'route',
                    name: AppRoutes.route,
                    builder: (context, state) => const RoutePage(),
                  )
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _infoTabNavigatorKey,
            routes: [
              GoRoute(
                path: '/info',
                name: AppRoutes.info,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: InfoPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _forumTabNavigatorKey,
            routes: [
              GoRoute(
                path: '/forum',
                name: AppRoutes.forum,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ForumPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _profileTabNavigatorKey,
            routes: [
              GoRoute(
                path: '/profile',
                name: AppRoutes.profile,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProfilePage(),
                ),
                routes: [
                  GoRoute(
                    path: 'settings',
                    name: AppRoutes.settings,
                    builder: (context, state) => const SettingsPage(),
                  ),
                  GoRoute(
                    path: 'edit-profile',
                    name: AppRoutes.editProfile,
                    builder: (context, state) => const EditProfilePage(),
                  ),
                  GoRoute(
                    path: 'contact-support',
                    name: AppRoutes.contactSupport,
                    builder: (context, state) => const ContactSupportPage(),
                  ),
                  GoRoute(
                    path: 'faq',
                    name: AppRoutes.faq,
                    builder: (context, state) => const FaqPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
        builder: (context, state, navigationShell) {
          return MainTabs(
            navigationShell: navigationShell,
          );
        },
      ),
      GoRoute(
        path: '/auth',
        name: AppRoutes.auth,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: AuthPage(),
        ),
        parentNavigatorKey: _appNavigatorKey,
      ),
      GoRoute(
        path: '/terms-and-conditions',
        name: AppRoutes.termsAndConditions,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: TermsAndConditionsPage(),
        ),
        parentNavigatorKey: _appNavigatorKey,
      ),
    ];

    router = GoRouter(
      navigatorKey: _appNavigatorKey,
      initialLocation: '/auth',
      routes: routes,
    );
  }

  // BuildContext get context =>
  //     router.routerDelegate.navigatorKey.currentContext!;
}

class AppRoutes {
  AppRoutes();

  static const auth = 'auth';
  static const contactSupport = 'contactSupport';
  // static const detail = 'detail';
  static const editProfile = 'editProfile';
  static const faq = 'faq';
  static const forum = 'forum';
  static const info = 'info';
  static const map = 'map';
  static const profile = 'profile';
  static const settings = 'settings';
  static const route = 'route';
  // static const signUp = 'signUp';
  // static const signIn = 'signIn';
  static const termsAndConditions = 'termsAndConditions';
  // static const rootDetail = 'rootDetail';
}

// initialRoute: '/',
// routes: {
//   '/home': (context) => const HomeScreen(),
//   '/auth': (context) => const AuthGate(),
//   '/intro': (context) => const IntroSlider(),
//   '/ddsMap': (context) => const DDSMap(),
//   '/mainMap': (context) =>
//       MapSceen(googleMapController: mapController),
//   '/filterMap': (context) =>
//       FilterMap(googleMapController: mapController),
//   '/forum': (context) => const ForumPage(),
// },
// // handle the case where FilterMap is accessed from other places.
// onGenerateRoute: (settings) {
//   if (settings.name == '/filterMap') {
//     return MaterialPageRoute(
//       builder: (context) => FilterMap(
//           googleMapController:
//               mapController), // Pass the controller to FilterMap
//     );
//   }
//   return null;
// },
// // Set AuthGate as the initial screen of application
// home: const AuthGate(),
// // Disable the debug mode banner

