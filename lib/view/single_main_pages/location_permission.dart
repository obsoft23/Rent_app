import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rentapp/theme/theme.dart';
import 'package:rentapp/landing_first_page.dart';
import 'package:rentapp/view/Home/home_page.dart';
import 'package:rentapp/view/single_main_pages/notification_permissionrequestpage.dart';

class LocationPermissionPage extends StatefulWidget {
  const LocationPermissionPage({super.key});

  @override
  State<LocationPermissionPage> createState() => _LocationPermissionPageState();
}

class _LocationPermissionPageState extends State<LocationPermissionPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer for the image
              Expanded(
                flex: 3,
                child: Center(
                  child: SizedBox(
                    height: 300,
                    width: 500,
                    child: SvgPicture.asset('assets/images/location_image.svg'),
                  ),
                ),
              ),
              // Heading text about Location
              Text(
                "Enable Location Services",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              // Text explaining the reason for location permission
              Text(
                "We need your location to provide you with the best rental options near you. "
                "This helps us ensure you find the most convenient and suitable places effortlessly.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24),
              // Button to give location permission
              ElevatedButton(
                onPressed: () {
                  // Handle location permission logic here
                  Get.offAll(() => NotificationPermissionRequestPage());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: igBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Center(
                  child: Text(
                    "Give Location Permission",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
