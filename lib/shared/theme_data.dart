import 'package:flutter/material.dart';

import '../ui/page_animation/custom_page_transition.dart';

class Styles {
  static ThemeData themeData(
      bool isDarkTheme,
      BuildContext context, {
        TextTheme? textTheme,
        Color? dividerColor,
      }) {
    final primarySwatch = isDarkTheme ? Colors.indigo
        : Colors.blue;
    final primaryColor = isDarkTheme ? Colors.lightBlue
        : Colors.lightBlueAccent;
    final backgroundColor = isDarkTheme ? Colors.black
        : Colors.grey[50];
    const scaffoldBackgroundColor = Colors.white;
    final cardColor = isDarkTheme ? const Color(0xFF151515)
        : Colors.white;
    final canvasColor = backgroundColor;
    final defaultDividerColor = isDarkTheme ? Colors.grey[700]
        : Colors.grey[300];

    final theme = ThemeData(
      primarySwatch: primarySwatch,
      primaryColorDark: primarySwatch[900]!,
      primaryColor: primaryColor,
      backgroundColor: backgroundColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      indicatorColor: isDarkTheme ? const Color(0xff0E1D36)
          : const Color(0xffCBDCF8),
      hintColor: isDarkTheme ? const Color(0xff280C0B)
          : const Color(0xffEECED3),
      highlightColor: isDarkTheme ? const Color(0xff372901)
          : const Color(0xffFCE192),
      focusColor: isDarkTheme ? const Color(0xff0B2512)
          : const Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      cardColor: cardColor,
      canvasColor: canvasColor,
      // brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
        colorScheme: isDarkTheme ? const ColorScheme.dark()
            : const ColorScheme.light(),
      ),
      appBarTheme: const AppBarTheme(elevation: 0.0),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: isDarkTheme ? Colors.white
            : Colors.black,
      ),
      dividerColor: dividerColor ?? defaultDividerColor,
      textTheme: textTheme ?? _buildTextTheme(isDarkTheme),
      // For custom page-transition
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: const FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CustomPageTransitionsBuilder(),
        },
      ),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: primarySwatch).copyWith(background: backgroundColor),
      // TODO: Add other parameters and customize further as needed
    );

    return theme;
  }

  static TextTheme _buildTextTheme(bool isDarkTheme) {
    final Color textColor = isDarkTheme ? Colors.white : Colors.black;

    return TextTheme(
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: textColor),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: textColor),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: textColor),
      bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: textColor),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: textColor),
      labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: textColor),
    ).apply(
      fontFamily: isDarkTheme ? 'FontFamilyDark' : 'FontFamilyLight',
    );
  }
}
