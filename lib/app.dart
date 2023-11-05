import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

import 'package:safe_streets/router.dart';
// import 'package:safe_streets/shared/map_controller_provider.dart';
import 'package:safe_streets/theme.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key}) {
    AppRouter();
  }

  @override
  Widget build(BuildContext context) {
    // return ChangeNotifierProvider(
    //   create: (_) => MapControllerProvider(),
    //   child: MaterialApp.router(
    return MaterialApp.router(
      title: "SafeStreets",
      theme: theme,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      // ),
    );
  }
}
