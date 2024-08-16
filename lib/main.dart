import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:golain_api_tests/screens/login_page.dart';
import 'package:golain_api_tests/dependency_injector.dart';
import 'package:golain_api_tests/app.dart';
// import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  AppDependencyInjector.setUpAppDependencies();
  runApp(MyApp());
}