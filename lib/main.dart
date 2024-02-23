import 'dart:io';

import 'package:bucket/screens/AuthScreen/login_screen.dart';
import 'package:bucket/screens/AuthScreen/signup_screen.dart';
import 'package:bucket/screens/AuthScreen/splash_screen.dart';
import 'package:bucket/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyB5h9_68zmvBmLy_itr6o52fyGd8QwLLB8',
              appId: '1:281864671890:android:a26f20b62dfcb474b30c4b',
              messagingSenderId: '281864671890',
              projectId: 'crudapp-951c6'))
      : await Firebase.initializeApp();
      

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: ThemeData(primaryColor: Colors.blue),
debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const NewLogin(),
        '/sign': (context) => const SignUp(),
        '/home': (context) =>  HomeScreen(),
        
        
      },
    );
  }
}
// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// import 'dart:async';
// import 'dart:math';

// import 'package:bucket/screens/BLE_Screen/flutter_blue_app.dart';
// import 'package:bucket/widgets/Widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';

// void main() {
//   runApp();
  
// }
