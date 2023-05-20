import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? leadingOnPressed;

  // Constructor to initialize the title, logo image path, and leading button onPressed callback
  const CustomAppBar({
    Key? key,
    required this.title,
    this.leadingOnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: leadingOnPressed != null
          ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: leadingOnPressed,
      )
          : null,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.5),
        ),
        child: Image.asset(
          'lib/assets/logos/logo_long_horizontal.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // TODO: rewrite, as some elements are deprecated
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight +
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).padding.top);
}
