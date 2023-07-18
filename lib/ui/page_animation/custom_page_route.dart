import 'package:flutter/cupertino.dart';

/// For a custom animation when changing between the pages
/// Usage:
/// Navigator.push(
///   context,
///   CustomPageRoute(
///     child: YourNewPage(),
///   ),
/// );
class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  CustomPageRoute({required this.child})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end)
          .chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}