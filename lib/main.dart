import 'package:aitie_demo/main_app.dart';
import 'package:aitie_demo/utils/simple_bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load the appropriate .env file based on the environment
  const String env = String.fromEnvironment('ENV', defaultValue: 'dev');
  String fileName = '.env'; // default

  switch (env) {
    case 'dev':
      fileName = '.env.dev';
      break;
    case 'stage':
      fileName = '.env.stage';
      break;
    default:
      fileName = '.env.dev';
  }

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top],
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Bloc.observer = const SimpleBlocObserver();
  runApp(const MainApp());
}
