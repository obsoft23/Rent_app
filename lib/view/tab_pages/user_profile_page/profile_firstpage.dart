import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentapp/theme/theme.dart';
import 'package:rentapp/landing_first_page.dart';
import 'package:rentapp/controller/auth_controller.dart';
import 'package:rentapp/controller/profile_controller.dart';
import 'package:rentapp/view/tab_pages/user_profile_page/account_information.dart';
import 'package:rentapp/view/tab_pages/user_profile_page/change_password_profilepage.dart';
import 'package:rentapp/view/tab_pages/user_profile_page/policies_folder/help_support_page.dart';
import 'package:rentapp/view/tab_pages/user_profile_page/user_personal_settings.dart';

class ProfileFirstpage extends StatefulWidget {
  const ProfileFirstpage({super.key});

  @override
  State<ProfileFirstpage> createState() => _ProfileFirstpageState();
}

class _ProfileFirstpageState extends State<ProfileFirstpage> {
  final AuthController authController = Get.find<AuthController>();
  final ProfileController profileController = Get.put(ProfileController());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isGuestUser() {
    return FirebaseAuth.instance.currentUser == null;
  }

  Future<Map<String, dynamic>?> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    try {
      final docSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();
      if (docSnapshot.exists) {
        return docSnapshot.data();
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    return null;
  }

  String _formatJoinDate(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 24),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white, size: 24),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 4),
        action: SnackBarAction(
          label: 'RETRY',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Management', style: TextStyle(fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Logout Confirmation'),
                    content: Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                          FirebaseAuth.instance.signOut();
                          Get.offAll(
                            () => FirstPage(),
                          ); // Navigate to FirstPage
                        },
                        child: Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Check if the user is a guest
              if (isGuestUser())
                Column(
                  children: [
                    // Guest UI
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade200,
                            ),
                            padding: EdgeInsets.all(24),
                            child: Icon(
                              Icons.person_outline,
                              size: 100,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Welcome, Guest!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Sign in to access more features.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          SizedBox(height: 24),
                          InkWell(
                            onTap: () async {
                              Get.offAll(() => FirstPage());
                            },
                            child: Ink(
                              width: double.infinity,
                              height: 56.0,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueGrey),
                                borderRadius: BorderRadius.circular(12.0),
                                color: igBlue,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Login",
                                    style: TextStyle(
                                      color: kDefaultIconDarkColor,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              else
                StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, authSnapshot) {
                    if (!authSnapshot.hasData) {
                      return Center(child: Text('Not logged in'));
                    }

                    final user = authSnapshot.data!;

                    return FutureBuilder<Map<String, dynamic>?>(
                      future: _getUserData(),
                      builder: (context, userSnapshot) {
                        final userData = userSnapshot.data;
                        final displayName =
                            userData?['displayName'] ??
                            user.email?.split('@')[0] ??
                            'User';
                        final photoURL = userData?['photoURL'] ?? user.photoURL;

                        return Column(
                          children: [
                            // Profile Picture with edit option
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      photoURL != null && photoURL.isNotEmpty
                                      ? NetworkImage(photoURL)
                                      : null,
                                  backgroundColor: Colors.grey[200],
                                  child: photoURL == null || photoURL.isEmpty
                                      ? Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Colors.grey,
                                        )
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Obx(
                                    () => CircleAvatar(
                                      radius: 18,
                                      backgroundColor: igBlue,
                                      child: profileController.isLoading.value
                                          ? SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.white),
                                              ),
                                            )
                                          : IconButton(
                                              icon: Icon(
                                                Icons.camera_alt,
                                                size: 18,
                                                color: Colors.white,
                                              ),
                                              padding: EdgeInsets.zero,
                                              onPressed: () async {
                                                try {
                                                  final url =
                                                      await profileController
                                                          .uploadProfilePicture();
                                                  if (url != null) {
                                                    _showSuccessMessage(
                                                      context,
                                                      'Profile picture updated successfully!',
                                                    );
                                                    setState(
                                                      () {},
                                                    ); // Refresh UI
                                                  }
                                                } catch (e) {
                                                  _showErrorMessage(
                                                    context,
                                                    'Failed to upload profile picture. Please try again.',
                                                  );
                                                }
                                              },
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            // User Name
                            Text(
                              displayName,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            // User Email
                            Text(
                              user.email ?? 'No email',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8),
                            // Join Date with Icon
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: igBlue.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: igBlue.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: igBlue,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Joined ${_formatJoinDate(user.metadata.creationTime)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: igBlue.withOpacity(0.8),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24),
                            // Profile Options
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 8,
                                    ),
                                    leading: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: igBlue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.lock,
                                        color: igBlue,
                                        size: 24,
                                      ),
                                    ),
                                    title: Text(
                                      'Change Password',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    onTap: () {
                                      // Navigate to Change Password
                                      Get.to(() => ChangePasswordProfilePage());
                                    },
                                  ),
                                  Divider(height: 1, indent: 68),
                                  ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 8,
                                    ),
                                    leading: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: igBlue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.settings,
                                        color: igBlue,
                                        size: 24,
                                      ),
                                    ),
                                    title: Text(
                                      'Settings',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    onTap: () {
                                      // Navigate to Settings
                                      Get.to(() => UserPersonalSettingsPage());
                                    },
                                  ),
                                  Divider(height: 1, indent: 68),
                                  ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 8,
                                    ),
                                    leading: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: igBlue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.help,
                                        color: igBlue,
                                        size: 24,
                                      ),
                                    ),
                                    title: Text(
                                      'Help & Support',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    onTap: () {
                                      // Navigate to Help & Support
                                      Get.to(() => HelpSupportPage());
                                    },
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 24),
                          ],
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
