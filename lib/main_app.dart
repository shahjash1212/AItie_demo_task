import 'package:aitie_demo/features/connectivity_banner/connectivity_banner_widget.dart';
import 'package:aitie_demo/features/products/data/data_sources/product_remote_data_source.dart';
import 'package:aitie_demo/features/products/data/repositories/product_repository_impl.dart';
import 'package:aitie_demo/features/products/presentation/bloc/product_bloc.dart';
import 'package:aitie_demo/features/settings_debug_menu/cubit/feature_flag_cubit.dart';
import 'package:aitie_demo/routing/app_router.dart';
import 'package:aitie_demo/utils/app_theme.dart';
import 'package:aitie_demo/utils/feature_flag_service.dart';
import 'package:aitie_demo/utils/local_db_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
        final prefs = snapshot.data!;
        final featureFlagService = FeatureFlagService(prefs);

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => FeatureFlagCubit(
                service: featureFlagService,
                localDbService: LocalDbService.instance,
              )..loadFlags(),
            ),
            BlocProvider(
              create: (_) => ProductBloc(
                localDbService: LocalDbService.instance,
                repository: ProductRepositoryImpl(
                  remoteDataSource: ProductRemoteDataSourceImpl(),
                ),
                featureFlagService: featureFlagService,
              ),
            ),
          ],
          child: MaterialApp.router(
            builder: (context, child) {
              return ConnectivityBanner(child: child!);
            },
            routerConfig: AppRouter.route,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
          ),
        );
      },
    );
  }
}
