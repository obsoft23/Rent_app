import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
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
  bool _isLoading = false;

  Future<void> _requestLocationPermission() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Request location permission
      PermissionStatus status = await Permission.location.request();

      if (status.isGranted) {
        // Permission granted, navigate to next page
        Get.offAll(() => NotificationPermissionRequestPage());
      } else if (status.isDenied) {
        // Permission denied
        _showPermissionDialog(
          'Location Permission Denied',
          'Please grant location permission to continue. You can enable it in your device settings.',
        );
      } else if (status.isPermanentlyDenied) {
        // Permission permanently denied, open app settings
        _showPermissionDialog(
          'Location Permission Required',
          'Location permission is required for this app. Please enable it in your device settings.',
          showSettings: true,
        );
      }
    } catch (e) {
      _showPermissionDialog(
        'Error',
        'Failed to request location permission. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showPermissionDialog(
    String title,
    String message, {
    bool showSettings = false,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          if (showSettings)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: Text('Open Settings'),
            )
          else
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _requestLocationPermission();
              },
              child: Text('Try Again'),
            ),
        ],
      ),
    );
  }

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
                onPressed: _isLoading ? null : _requestLocationPermission,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isLoading ? Colors.grey : igBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Center(
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
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
              // Skip button
              TextButton(
                onPressed: () {
                  Get.offAll(() => const NotificationPermissionRequestPage());
                },
                child: Text(
                  "Skip for now",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
