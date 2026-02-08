import 'package:aitie_demo/data/product/models/product_response.dart';
import 'package:aitie_demo/presentation/cart/cart_screen.dart';
import 'package:aitie_demo/presentation/errors/error_screen.dart';
import 'package:aitie_demo/presentation/favorite/favorite_screen.dart';
import 'package:aitie_demo/presentation/home/home_screen.dart';
import 'package:aitie_demo/presentation/product_details/product_detaills_deep_link.dart';
import 'package:aitie_demo/presentation/product_details/product_details_screen.dart';
import 'package:aitie_demo/presentation/products/bloc/product_bloc.dart';
import 'package:aitie_demo/presentation/products/pages/product_screen.dart';
import 'package:aitie_demo/routing/route_names.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final route = GoRouter(
    initialLocation: RouteNames.product,
    redirect: (context, state) {
      final uri = state.uri;
      final path = uri.path;

      if (path.startsWith('/products/')) {
        final productId = path.split('/').last;

        if (int.tryParse(productId) != null) {
          return '${RouteNames.productDetail}/$productId';
        }
      }

      return null;
    },
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
                  return FavoriteScreen();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.cart,
                name: RouteNames.cart,
                builder: (context, state) => CartScreen(),
              ),
            ],
          ),
        ],
      ),
      // EXISTING ROUTE - Keep as is for normal navigation
      GoRoute(
        path: RouteNames.productDetail,
        name: RouteNames.productDetail,
        builder: (context, state) {
          final Map<String, dynamic> extra =
              state.extra as Map<String, dynamic>;
          final product = extra['product'] as ProductResponse;
          final bool isFromFavorites = extra['isFromFavorites'] as bool;
          return ProductDetailScreen(
            product: product,
            isFromFavorites: isFromFavorites,
          );
        },
      ),
      // NEW ROUTE - Deep link route with product ID
      GoRoute(
        path: '${RouteNames.productDetail}/:productId',
        name: RouteNames.productDetailDeepLink,
        builder: (context, state) {
          final productId = int.tryParse(
            state.pathParameters['productId'] ?? '',
          );
          final isFromFavorites =
              state.uri.queryParameters['fromFavorites'] == 'true';

          if (productId == null) {
            return ErrorScreen(message: 'Invalid product ID');
          }

          // Trigger loading the product
          context.read<ProductBloc>().add(
            LoadSingleProductEvent(productId: productId),
          );

          return ProductDetailDeepLinkScreen(
            productId: productId,
            isFromFavorites: isFromFavorites,
          );
        },
      ),
      GoRoute(
        path: RouteNames.error,
        name: RouteNames.error,
        builder: (context, state) {
          return ErrorScreen(
            message:
                state.uri.queryParameters['message'] ?? 'Something went wrong',
          );
        },
      ),
    ],
  );
}
