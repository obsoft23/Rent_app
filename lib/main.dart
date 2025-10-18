// ignore_for_file: unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:rentapp/firebase_options.dart';
import 'package:rentapp/theme/theme.dart';
import 'package:rentapp/view/first_page.dart';
import 'package:rentapp/view/splashscreen/splashscreen.dart';

import 'view/home_page.dart';

Future<void> main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Satoshi',
        colorScheme: ColorScheme.fromSeed(seedColor: igBlue),
        primaryColor: igBlue,
        useMaterial3: true,
      ),

      home: SplashScreen(),
    );
  }
}
