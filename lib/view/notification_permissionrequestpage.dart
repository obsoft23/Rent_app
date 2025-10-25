// /lib/view/notification_permissionrequestpage.dart
//
// Add to pubspec.yaml:
//   permission_handler: ^10.4.0

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rentapp/theme/theme.dart';
import 'package:rentapp/view/home_page.dart';

class NotificationPermissionRequestPage extends StatefulWidget {
  const NotificationPermissionRequestPage({super.key});

  @override
  State<NotificationPermissionRequestPage> createState() =>
      _LocationPermissionRequestPageState();
}

class _LocationPermissionRequestPageState
    extends State<NotificationPermissionRequestPage>
    with TickerProviderStateMixin {
  late final AnimationController _swingController;
  late final Animation<double> _swingAnim;
  late final AnimationController _pulseController;

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

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _swingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // ignore: unused_element
  Future<void> _requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();

    if (status.isGranted) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission granted')),
      );
      Navigator.of(context).maybePop(true);
      return;
    }

    if (status.isPermanentlyDenied) {
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Permission required'),
          content: const Text(
            'Location permission is permanently denied. Please open settings to enable it.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(c).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
                Navigator.of(c).pop();
              },
              child: const Text('Open Settings'),
            ),
          ],
        ),
      );
      return;
    }

    // denied, restricted, or limited
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Location permission denied')));
  }

  Widget _buildPulse(double radius, double offset) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final t = _pulseController.value;
        final scale = 0.7 + (t + offset) % 1.0 * 1.2;
        final opacity = (1.0 - ((t + offset) % 1.0)).clamp(0.0, 1.0);
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity * 0.25,
            child: Container(
              width: radius,
              height: radius,
              decoration: BoxDecoration(shape: BoxShape.circle, color: igBlue),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [igBlue, Color(0xFF0B1220)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated bell with pulse
                SizedBox(
                  width: 240,
                  height: 240,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _buildPulse(220, 0.0),
                      _buildPulse(180, 0.33),
                      _buildPulse(140, 0.66),
                      RotationTransition(
                        turns: _swingAnim,
                        child: Semantics(
                          label: 'Notification Bell',
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
                    ],
                  ),
                ),

                const SizedBox(height: 28),
                Text(
                  'Enable Notifications',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'We need your location to show nearby results and provide better suggestions.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        Get.offAll(() => HomePage());
                        /* final status = await Permission.notification.request();

                        if (status.isGranted) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Notifications enabled'),
                            ),
                          );
                          Navigator.of(context).maybePop(true);
                          return;
                        }

                        if (status.isPermanentlyDenied) {
                          if (!mounted) return;
                          await showDialog(
                            context: context,
                            builder: (c) => AlertDialog(
                              title: const Text('Permission required'),
                              content: const Text(
                                'Notification permission is permanently denied. Please open settings to enable it.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(c).pop(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    openAppSettings();
                                    Navigator.of(c).pop();
                                  },
                                  child: const Text('Open Settings'),
                                ),
                              ],
                            ),
                          );
                          return;
                        }

                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Notification permission denied'),
                          ),
                        ); */
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          color: igBlue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.notifications_active,
                                size: 22,
                                color: Colors.white,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Allow notifications',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                /* SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                  onPressed: _requestLocationPermission,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 28,
                    ),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: igBlue,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: const [
                    Icon(Icons.gps_fixed, size: 24),
                    SizedBox(width: 12),
                    Text('Allow Location'),
                    ],
                  ),
                  ),
                ),
                
                const SizedBox(height: 12),
                 TextButton(
            onPressed: () => Navigator.of(context).maybePop(false),
            child: const Text(
            'Maybe later',
            style: TextStyle(color: Colors.white70),
            ),
          ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
