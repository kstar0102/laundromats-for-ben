import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laundromats/src/splash.dart';

enum AppRoute {
  splashscreen,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.splashscreen.name,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: const SplashScreen(),
        ),
      ),
    ],
  );
});
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:laundromats/src/screen/mainScreen.dart';
// import 'package:laundromats/src/splash.dart';

// enum AppRoute {
//   splashscreen,
//   home, // Add this for main screen
// }

// final goRouterProvider = Provider<GoRouter>((ref) {
//   return GoRouter(
//     initialLocation: '/',
//     debugLogDiagnostics: false,
//     routes: [
//       GoRoute(
//         path: '/',
//         name: AppRoute.splashscreen.name,
//         pageBuilder: (context, state) => MaterialPage(
//           key: state.pageKey,
//           fullscreenDialog: true,
//           child: const SplashScreen(),
//         ),
//       ),
//       GoRoute(
//         path: '/home',
//         name: AppRoute.home.name,
//         pageBuilder: (context, state) => MaterialPage(
//           key: state.pageKey,
//           child: const MainScreen(), // Load MainScreen here
//         ),
//       ),
//     ],
//   );
// });
