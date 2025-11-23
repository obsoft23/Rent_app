// /lib/view/notification_permissionrequestpage.dart
//
// Add to pubspec.yaml:
//   permission_handler: ^10.4.0

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rentapp/theme/theme.dart';
import 'package:rentapp/view/Home/home_page.dart';

class NotificationPermissionRequestPage extends StatefulWidget {
  const NotificationPermissionRequestPage({super.key});

  @override
  State<NotificationPermissionRequestPage> createState() =>
      _NotificationPermissionRequestPageState();
}

class _NotificationPermissionRequestPageState
    extends State<NotificationPermissionRequestPage>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  late final AnimationController _swingController;
  late final Animation<double> _swingAnim;

  @override
  void initState() {
    super.initState();
    _swingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _swingAnim = Tween<double>(begin: -0.08, end: 0.08).animate(
      CurvedAnimation(parent: _swingController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _swingController.dispose();
    super.dispose();
  }

  Future<void> _requestNotificationPermission() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Request notification permission
      PermissionStatus status = await Permission.notification.request();

      if (status.isGranted) {
        // Permission granted, navigate to home page
        Get.offAll(() => HomePage());
      } else if (status.isDenied) {
        // Permission denied
        _showPermissionDialog(
          'Notification Permission Denied',
          'Please grant notification permission to stay updated. You can enable it in your device settings.',
        );
      } else if (status.isPermanentlyDenied) {
        // Permission permanently denied, open app settings
        _showPermissionDialog(
          'Notification Permission Required',
          'Notification permission is required to keep you informed. Please enable it in your device settings.',
          showSettings: true,
        );
      }
    } catch (e) {
      _showPermissionDialog(
        'Error',
        'Failed to request notification permission. Please try again.',
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
                _requestNotificationPermission();
              },
              child: Text('Try Again'),
            ),
        ],
      ),
    );
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
                    width: 300,
                    child: RotationTransition(
                      turns: _swingAnim,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const RadialGradient(
                            colors: [
                              Color.fromARGB(255, 110, 156, 197),
                              Color.fromARGB(255, 63, 165, 223),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Icon(
                          Icons.notifications,
                          size: 140,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Heading text about Notifications
              Text(
                "Enable Notifications",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              // Text explaining the reason for notification permission
              Text(
                "Stay updated with important rental notifications, new listings, and messages from property owners. "
                "We'll keep you informed every step of the way.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24),
              // Button to give notification permission
              ElevatedButton(
                onPressed: _isLoading ? null : _requestNotificationPermission,
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
                          "Enable Notifications",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 12),
              // Skip button
              TextButton(
                onPressed: () {
                  Get.offAll(() => const HomePage());
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
