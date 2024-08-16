import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:golain_api_tests/screens/home_screen.dart';
import 'package:golain_api_tests/screens/login_page.dart';
import 'package:golain_api_tests/services/api_services.dart';
import 'package:golain_api_tests/services/authentication_service.dart';

import 'dependency_injector.dart';


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  late bool isLoggedIn;

  @override
  void initState() {
    super.initState;
    checkAuth();
  }

  void checkAuth() async {
    try {
      await authenticationService.init();
    } catch (e) {
      log(e.toString());
    }
    setState(() {
      isLoading = false;
    });
    if (authenticationService.userManager.currentUser == null) {
      setState(() {
        isLoggedIn = false;
      });
    } else {
      setState(() {
        apiService.setUserToken(
            authenticationService.userManager.currentUser!.token.accessToken!);
        log(authenticationService.userManager.currentUser!.token.accessToken
            .toString());
        isLoggedIn = true;
      });
    }
  }

  final AuthenticationService authenticationService =
      AppDependencyInjector.getIt.get();

  final ApiService apiService = AppDependencyInjector.getIt.get();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: (isLoading)
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            )
          : (isLoggedIn)
              ? HomeScreen()
              : LoginPage(),
    );
  }
}