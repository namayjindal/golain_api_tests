import 'package:flutter/material.dart';
import 'package:golain_api_tests/screens/home_screen.dart';
import 'package:golain_api_tests/services/authentication_service.dart';
import 'package:golain_api_tests/dependency_injector.dart';


class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  Future<void> _authenticate(context) async {
    try {
      final user = await authenticationService.login();
      if (user == null) {
        //it wasn't possible to login the user.

        return;
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } catch (e) {}
  }

  final AuthenticationService authenticationService =
      AppDependencyInjector.getIt.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _authenticate(context);
          },
          child: const Text("Login"),
        ),
      ),
    );
  }
}