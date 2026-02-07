import 'package:aitie_demo/features/home/home_screen.dart';
import 'package:aitie_demo/features/product_details/presentation/product_details_screen.dart';
import 'package:aitie_demo/features/products/data/models/product_response.dart';
import 'package:aitie_demo/features/products/presentation/pages/product_screen.dart';
import 'package:aitie_demo/features/splash/splash_screen.dart';
import 'package:aitie_demo/routing/route_names.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final route = GoRouter(
    initialLocation: RouteNames.product,
    routes: [
      // Home Screen Navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.product,
                name: RouteNames.product,
                builder: (context, state) => ProductScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.favorites,
                name: RouteNames.favorites,
                builder: (context, state) {
                  return SplashScreen();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.cart,
                name: RouteNames.cart,
                builder: (context, state) => SplashScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.productDetail,
        name: RouteNames.productDetail,
        builder: (context, state) {
          final product = state.extra as ProductResponse;

          return ProductDetailScreen(product: product);
        },
      ),
    ],
  );
}
