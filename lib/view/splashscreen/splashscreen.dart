import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rentapp/components/responsive.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:rentapp/theme/theme.dart';
import 'package:rentapp/landing_first_page.dart';
import 'package:rentapp/view/single_main_pages/location_permission.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Get.offAll(() => const FirstPage());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: igBlue,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          /* gradient: LinearGradient(
            colors: [igBlue, Color(0xFF0B1220)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),*/
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo SVG asset in the center
       
              // Loading GIF below the logo
              Image.asset('assets/images/loading.gif', height: 23, width: 23),
            ],
          ),
        ),
      ),
    );
  }
}
