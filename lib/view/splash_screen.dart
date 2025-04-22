import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes/utils/const_values.dart';
import 'package:notes/utils/shared_preferences_helper.dart';
import 'package:notes/view/main_screen.dart';
import 'package:notes/view/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Widget nextScreen;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () async {
      bool isLoggedIn = SharedPreferencesHelper().getPrefBool(
        key: ConstValues.isLoggedIn,
        defaultValue: false,
      );
      if (isLoggedIn) {
        nextScreen = MainScreen();
      } else {
        nextScreen = SignInScreen();
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => nextScreen),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: Image.asset(
          "assets/images/logo.png",
          width: 200,
          height: 200,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
