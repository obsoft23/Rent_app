import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rentapp/components/responsive.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:rentapp/theme/theme.dart';
import 'package:rentapp/view/first_page.dart';
import 'package:rentapp/view/location_permission.dart';

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
              SizedBox(
                height: 180,
                width: 150,
                child: SvgPicture.asset('assets/images/house2.svg'),
              ),
              const SizedBox(height: 16),
              // Loading GIF below the logo
              Image.asset('assets/images/loading.gif', height: 23, width: 23),
            ],
          ),
        ),
      ),
    );
  }
}
