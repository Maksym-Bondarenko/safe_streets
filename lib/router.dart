import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:safe_streets/views/auth/auth_page.dart';
import 'package:safe_streets/views/auth/terms_and_conditions_page.dart';
import 'package:safe_streets/views/info/forum_page.dart';
import 'package:safe_streets/views/info/info_page.dart';
import 'package:safe_streets/views/info/support_page.dart';
import 'package:safe_streets/views/map/dds_map_page.dart';
import 'package:safe_streets/views/map/call_page.dart';
import 'package:safe_streets/views/map/map_page.dart';
import 'package:safe_streets/views/map/route_page.dart';
import 'package:safe_streets/views/main/main_tabs.dart';
import 'package:safe_streets/views/profile/contact_support_page.dart';
import 'package:safe_streets/views/profile/edit_profile_page.dart';
import 'package:safe_streets/views/profile/faq_page.dart';
import 'package:safe_streets/views/profile/profile_page.dart';
import 'package:safe_streets/views/profile/settings_page.dart';

part 'router.g.dart';

final router = GoRouter(
  initialLocation: '/auth',
  routes: $appRoutes,
);

@TypedStatefulShellRoute<MainTabsRoute>(
  branches: [
    TypedStatefulShellBranch<MapBranch>(
      routes: [
        TypedGoRoute<MapRoute>(
          path: '/map',
          routes: [
            TypedGoRoute<RouteRoute>(path: 'route'),
            TypedGoRoute<CallRoute>(path: 'call'),
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
  Widget builder(context, state, navigationShell) {
    return MainTabs(navigationShell: navigationShell);
  }
}

@TypedGoRoute<AuthRoute>(path: '/auth')
class AuthRoute extends GoRouteData {
  @override
  build(context, state) => const AuthPage();
}

@TypedGoRoute<TermsAndConditionsRoute>(path: '/terms-and-conditions')
class TermsAndConditionsRoute extends GoRouteData {
  @override
  build(context, state) => const TermsAndConditionsPage();
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

class CallRoute extends GoRouteData {
  const CallRoute();
  @override
  build(context, state) => const CallPage();
}

class ContactSupportRoute extends GoRouteData {
  const ContactSupportRoute();
  @override
  build(context, state) => const ContactSupportPage();
}

class DDSMapRoute extends GoRouteData {
  const DDSMapRoute();
  @override
  build(context, state) => const DDSMapPage();
}

class EditProfileRoute extends GoRouteData {
  const EditProfileRoute();
  @override
  build(context, state) => const EditProfilePage();
}

class FAQRoute extends GoRouteData {
  const FAQRoute();
  @override
  build(context, state) => const FAQPage();
}

class ForumRoute extends GoRouteData {
  const ForumRoute();
  @override
  build(context, state) => const ForumPage();
}

class InfoRoute extends GoRouteData {
  const InfoRoute();
  @override
  build(context, state) => const InfoPage();
}

class MapRoute extends GoRouteData {
  const MapRoute();
  @override
  build(context, state) => const MapPage();
}

class ProfileRoute extends GoRouteData {
  const ProfileRoute();
  @override
  build(context, state) => const ProfilePage();
}

class SupportRoute extends GoRouteData {
  const SupportRoute();
  @override
  build(context, state) => const SupportPage();
}

class SettingsRoute extends GoRouteData {
  const SettingsRoute();
  @override
  build(context, state) => const SettingsPage();
}

class RouteRoute extends GoRouteData {
  const RouteRoute();
  @override
  build(context, state) => const RoutePage();
}
