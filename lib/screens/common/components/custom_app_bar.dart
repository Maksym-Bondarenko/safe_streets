import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Custom AppBar (heading of pages) with back-button and wide logo
/// usage in other components:
/// CustomAppBar(
///   title: 'My AppBar',
///   navigator: Navigator.of(context),
///   leadingOnPressed: () {
///     // Custom logic for leading button onPressed
///   },
///   content: YourContentWidget(),
/// ),
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final NavigatorState navigator;
  final VoidCallback? leadingOnPressed;
  final Widget content;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.navigator,
    required this.content,
    this.leadingOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: leadingOnPressed != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (leadingOnPressed != null) {
                    leadingOnPressed!();
                  } else {
                    GoRouter.of(context).pop();
                  }
                },
              )
            : null,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.5),
          ),
          child: Image.asset(
            'assets/logos/logo_long_horizontal.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: content,
    );
  }

  @override
  Size get preferredSize {
    final double statusBarHeight = MediaQuery.of(navigator.context).padding.top;
    return Size.fromHeight(kToolbarHeight + statusBarHeight);
  }
}
