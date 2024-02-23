import 'dart:async';

import 'package:bucket/screens/home.dart';
import 'package:bucket/screens/AuthScreen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    // ignore: non_constant_identifier_names
    final User = auth.currentUser;
    if (User != null) {
      Timer(
          const Duration(seconds: 1),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen())));
    } else {
      Timer(
          const Duration(seconds: 1),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => const NewLogin())));
    }
  }
}
