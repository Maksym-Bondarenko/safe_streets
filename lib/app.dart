import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

import 'package:safe_streets/router.dart';
// import 'package:safe_streets/shared/map_controller_provider.dart';
import 'package:safe_streets/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "SafeStreets",
      theme: theme,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
