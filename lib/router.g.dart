// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $mainTabsRoute,
      $authRoute,
      $termsAndConditionsRoute,
      $callRoute,
    ];

RouteBase get $mainTabsRoute => StatefulShellRouteData.$route(
      factory: $MainTabsRouteExtension._fromState,
      branches: [
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/map',
              factory: $MapRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'route',
                  factory: $RouteRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/info',
              factory: $InfoRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'support',
                  factory: $SupportRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'forum',
                  factory: $ForumRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'dds-map',
                  factory: $DDSMapRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/profile',
              factory: $ProfileRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'settings',
                  factory: $SettingsRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'edit-profile',
                  factory: $EditProfileRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'contact-support',
                  factory: $ContactSupportRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'faq',
                  factory: $FAQRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
      ],
    );

extension $MainTabsRouteExtension on MainTabsRoute {
  static MainTabsRoute _fromState(GoRouterState state) => const MainTabsRoute();
}

extension $MapRouteExtension on MapRoute {
  static MapRoute _fromState(GoRouterState state) => const MapRoute();

  String get location => GoRouteData.$location(
        '/map',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $RouteRouteExtension on RouteRoute {
  static RouteRoute _fromState(GoRouterState state) => const RouteRoute();

  String get location => GoRouteData.$location(
        '/map/route',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $InfoRouteExtension on InfoRoute {
  static InfoRoute _fromState(GoRouterState state) => const InfoRoute();

  String get location => GoRouteData.$location(
        '/info',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SupportRouteExtension on SupportRoute {
  static SupportRoute _fromState(GoRouterState state) => const SupportRoute();

  String get location => GoRouteData.$location(
        '/info/support',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ForumRouteExtension on ForumRoute {
  static ForumRoute _fromState(GoRouterState state) => const ForumRoute();

  String get location => GoRouteData.$location(
        '/info/forum',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $DDSMapRouteExtension on DDSMapRoute {
  static DDSMapRoute _fromState(GoRouterState state) => const DDSMapRoute();

  String get location => GoRouteData.$location(
        '/info/dds-map',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ProfileRouteExtension on ProfileRoute {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  String get location => GoRouteData.$location(
        '/profile',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SettingsRouteExtension on SettingsRoute {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  String get location => GoRouteData.$location(
        '/profile/settings',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $EditProfileRouteExtension on EditProfileRoute {
  static EditProfileRoute _fromState(GoRouterState state) =>
      const EditProfileRoute();

  String get location => GoRouteData.$location(
        '/profile/edit-profile',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ContactSupportRouteExtension on ContactSupportRoute {
  static ContactSupportRoute _fromState(GoRouterState state) =>
      const ContactSupportRoute();

  String get location => GoRouteData.$location(
        '/profile/contact-support',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $FAQRouteExtension on FAQRoute {
  static FAQRoute _fromState(GoRouterState state) => const FAQRoute();

  String get location => GoRouteData.$location(
        '/profile/faq',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $authRoute => GoRouteData.$route(
      path: '/auth',
      factory: $AuthRouteExtension._fromState,
    );

extension $AuthRouteExtension on AuthRoute {
  static AuthRoute _fromState(GoRouterState state) => const AuthRoute();

  String get location => GoRouteData.$location(
        '/auth',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $termsAndConditionsRoute => GoRouteData.$route(
      path: '/terms-and-conditions',
      factory: $TermsAndConditionsRouteExtension._fromState,
    );

extension $TermsAndConditionsRouteExtension on TermsAndConditionsRoute {
  static TermsAndConditionsRoute _fromState(GoRouterState state) =>
      const TermsAndConditionsRoute();

  String get location => GoRouteData.$location(
        '/terms-and-conditions',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $callRoute => GoRouteData.$route(
      path: '/call',
      parentNavigatorKey: CallRoute.$parentNavigatorKey,
      factory: $CallRouteExtension._fromState,
    );

extension $CallRouteExtension on CallRoute {
  static CallRoute _fromState(GoRouterState state) => const CallRoute();

  String get location => GoRouteData.$location(
        '/call',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
