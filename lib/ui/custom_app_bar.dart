import 'package:flutter/material.dart';

// stateless widget of custom AppBar with logo on it to use as Scaffold-header on all pages
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'lib/assets/logos/logo_long_horizontal.png',
          fit: BoxFit.cover,
          height: kToolbarHeight +
              MediaQuery.of(context)
                  .padding
                  .top, // height of the image should be the same as the app bar
          width: MediaQuery.of(context).size.width,
        ),
        AppBar(
          title: Text(
            title,
            style: const TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          // add a semi-transparent background color to the AppBar
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight +
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).padding.top);
}
