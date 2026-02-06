import 'package:aitie_demo/features/splash/splash_screen.dart';
import 'package:aitie_demo/routing/route_names.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final route = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            child: const SplashScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return child;
                },
          );
        },
      ),

      //Home Screen Navigation
      // StatefulShellRoute.indexedStack(
      //   builder: (context, state, navigationShell) {
      //     return SplashScreen(navigationShell: navigationShell);
      //   },
      //   branches: [
      //     StatefulShellBranch(
      //       routes: [
      //         GoRoute(
      //           path: RouteNames.product,
      //           name: RouteNames.product,
      //           builder: (context, state) => SplashScreen(),
      //         ),
      //       ],
      //     ),
      //     StatefulShellBranch(
      //       routes: [
      //         GoRoute(
      //           path: RouteNames.favorites,
      //           name: RouteNames.favorites,
      //           builder: (context, state) {
      //             return SplashScreen();
      //           },
      //         ),
      //       ],
      //     ),
      //     StatefulShellBranch(
      //       routes: [
      //         GoRoute(
      //           path: RouteNames.cart,
      //           name: RouteNames.cart,
      //           builder: (context, state) => SplashScreen(),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
   
   
    ],
  );
}
