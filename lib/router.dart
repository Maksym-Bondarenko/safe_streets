import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:safe_streets/views/auth/auth_page.dart';
import 'package:safe_streets/views/auth/terms_and_conditions_page.dart';
import 'package:safe_streets/views/info/forum_page.dart';
import 'package:safe_streets/views/info/info_page.dart';
import 'package:safe_streets/views/info/support_page.dart';
import 'package:safe_streets/views/map/active_call_page.dart';
import 'package:safe_streets/views/map/incoming_call_page.dart';
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
  final _profileTabNavigatorKey = GlobalKey<NavigatorState>();

  factory AppRouter() {
    return _instance;
  }

  static void popUntil(BuildContext context, String pathName) {
    while (GoRouterState.of(context).name != pathName && router.canPop()) {
      debugPrint('Popping ${GoRouterState.of(context).name}');
      router.pop();
    }
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
                  ),
                  GoRoute(
                    path: 'incoming-call',
                    name: AppRoutes.incomingCall,
                    builder: (context, state) => const IncomingCallPage(),
                    routes: [
                      GoRoute(
                        path: 'active-call',
                        name: AppRoutes.activeCall,
                        builder: (context, state) {
                          final callInfo = state.extra as IActiveCallPageProps;
                          return ActiveCallPage(
                            name: callInfo.name,
                            duration: callInfo.duration,
                          );
                        },
                      )
                    ],
                  ),
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
                routes: [
                  GoRoute(
                    path: 'support',
                    name: AppRoutes.support,
                    builder: (context, state) => const SupportPage(),
                  ),
                  GoRoute(
                    path: 'forum',
                    name: AppRoutes.forum,
                    builder: (context, state) => const ForumPage(),
                  ),
                ],
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
  static const activeCall = 'activeCall';
  static const contactSupport = 'contactSupport';
  // static const detail = 'detail';
  static const editProfile = 'editProfile';
  static const faq = 'faq';
  static const forum = 'forum';
  static const info = 'info';
  static const incomingCall = 'incomingCall';
  static const map = 'map';
  static const profile = 'profile';
  static const support = 'support';
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
