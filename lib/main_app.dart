import 'package:aitie_demo/features/connectivity_banner/connectivity_banner_widget.dart';
import 'package:aitie_demo/features/products/data/data_sources/product_remote_data_source.dart';
import 'package:aitie_demo/features/products/data/repositories/product_repository_impl.dart';
import 'package:aitie_demo/features/products/presentation/bloc/product_bloc.dart';
import 'package:aitie_demo/routing/app_router.dart';
import 'package:aitie_demo/utils/app_theme.dart';
import 'package:aitie_demo/utils/local_db_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProductBloc(
            localDbService: LocalDbService.instance,
            repository: ProductRepositoryImpl(
              remoteDataSource: ProductRemoteDataSourceImpl(),
            ),
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
  }
}
