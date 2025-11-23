import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rentapp/components/responsive.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:rentapp/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rentapp/landing_first_page.dart';
import 'package:rentapp/view/Home/home_page.dart';
import 'package:rentapp/view/single_main_pages/location_permission.dart';
import 'package:rentapp/view/single_main_pages/notification_permissionrequestpage.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      // Check Firebase auth state
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // User is logged in, check which permissions are needed
        final locationStatus = await Permission.location.status;
        final notificationStatus = await Permission.notification.status;

        if (locationStatus.isGranted && notificationStatus.isGranted) {
          // Both permissions granted, go to HomePage
          Get.offAll(() => const HomePage());
        } else if (locationStatus.isGranted) {
          // Location granted but not notifications, go to notification page
          Get.offAll(() => const NotificationPermissionRequestPage());
        } else {
          // Location not granted, go to location page first
          Get.offAll(() => const LocationPermissionPage());
        }
      } else {
        // User is not logged in, navigate to FirstPage
        Get.offAll(() => const FirstPage());
      }
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
