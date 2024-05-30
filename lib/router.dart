import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:safe_streets/screens/auth/auth.dart';
import 'package:safe_streets/screens/auth/terms_and_conditions.dart';
import 'package:safe_streets/screens/call/call.dart';
import 'package:safe_streets/screens/common/main_tabs.dart';
import 'package:safe_streets/screens/info/forum.dart';
import 'package:safe_streets/screens/info/info.dart';
import 'package:safe_streets/screens/info/support.dart';
import 'package:safe_streets/screens/map/dds_map.dart';
import 'package:safe_streets/screens/map/main_map.dart';
import 'package:safe_streets/screens/map/route.dart';
import 'package:safe_streets/screens/profile/contact_support.dart';
import 'package:safe_streets/screens/profile/edit_profile.dart';
import 'package:safe_streets/screens/profile/faq.dart';
import 'package:safe_streets/screens/profile/profile.dart';
import 'package:safe_streets/screens/profile/settings.dart';

part 'router.g.dart';

final router = GoRouter(
  navigatorKey: _mainNavigatorKey,
  initialLocation: '/auth',
  routes: $appRoutes,
);
final _mainNavigatorKey = GlobalKey<NavigatorState>();

@TypedStatefulShellRoute<MainTabsRoute>(
  branches: [
    TypedStatefulShellBranch<MapBranch>(
      routes: [
        TypedGoRoute<MapRoute>(
          path: '/map',
          routes: [
            TypedGoRoute<RouteRoute>(path: 'route'),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<InfoBranch>(
      routes: [
        TypedGoRoute<InfoRoute>(
          path: '/info',
          routes: [
            TypedGoRoute<SupportRoute>(path: 'support'),
            TypedGoRoute<ForumRoute>(path: 'forum'),
            TypedGoRoute<DDSMapRoute>(path: 'dds-map'),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<ProfileBranch>(
      routes: [
        TypedGoRoute<ProfileRoute>(
          path: '/profile',
          routes: [
            TypedGoRoute<SettingsRoute>(path: 'settings'),
            TypedGoRoute<EditProfileRoute>(path: 'edit-profile'),
            TypedGoRoute<ContactSupportRoute>(path: 'contact-support'),
            TypedGoRoute<FAQRoute>(path: 'faq'),
          ],
        ),
      ],
    ),
  ],
)
class MainTabsRoute extends StatefulShellRouteData {
  const MainTabsRoute();
  @override
  pageBuilder(context, state, navigationShell) => NoTransitionPage(
        child: MainTabsScreen(navigationShell: navigationShell),
      );
}

@TypedGoRoute<AuthRoute>(path: '/auth')
class AuthRoute extends GoRouteData {
  const AuthRoute();
  @override
  buildPage(context, state) => const NoTransitionPage(
        child: AuthScreen(),
      );
}

@TypedGoRoute<TermsAndConditionsRoute>(path: '/terms-and-conditions')
class TermsAndConditionsRoute extends GoRouteData {
  const TermsAndConditionsRoute();
  @override
  buildPage(context, state) => const NoTransitionPage(
        child: TermsAndConditionsScreen(),
      );
}

@TypedGoRoute<CallRoute>(path: '/call')
class CallRoute extends GoRouteData {
  static final $parentNavigatorKey = _mainNavigatorKey;
  const CallRoute();
  @override
  buildPage(context, state) => const NoTransitionPage(
        child: CallScreen(),
      );
}

class MapBranch extends StatefulShellBranchData {
  const MapBranch();
}

class InfoBranch extends StatefulShellBranchData {
  const InfoBranch();
}

class ProfileBranch extends StatefulShellBranchData {
  const ProfileBranch();
}

class ContactSupportRoute extends GoRouteData {
  const ContactSupportRoute();
  @override
  build(context, state) => const ContactSupportScreen();
}

class DDSMapRoute extends GoRouteData {
  const DDSMapRoute();
  @override
  build(context, state) => const DDSMapScreen();
}

class EditProfileRoute extends GoRouteData {
  const EditProfileRoute();
  @override
  build(context, state) => const EditProfileScreen();
}

class FAQRoute extends GoRouteData {
  const FAQRoute();
  @override
  build(context, state) => const FAQScreen();
}

class ForumRoute extends GoRouteData {
  const ForumRoute();
  @override
  build(context, state) => const ForumScreen();
}

class InfoRoute extends GoRouteData {
  const InfoRoute();
  @override
  build(context, state) => const InfoScreen();
}

class MapRoute extends GoRouteData {
  const MapRoute();
  @override
  build(context, state) => const MainMapScreen();
}

class ProfileRoute extends GoRouteData {
  const ProfileRoute();
  @override
  build(context, state) => const ProfileScreen();
}

class SupportRoute extends GoRouteData {
  const SupportRoute();
  @override
  build(context, state) => const SupportScreen();
}

class SettingsRoute extends GoRouteData {
  const SettingsRoute();
  @override
  build(context, state) => const SettingsScreen();
}

class RouteRoute extends GoRouteData {
  const RouteRoute();
  @override
  build(context, state) => const RouteScreen();
}
