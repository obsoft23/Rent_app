import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentapp/view/tab_pages/user_profile_page/policies_folder/privacy_policy_page.dart';
import 'package:rentapp/view/tab_pages/user_profile_page/policies_folder/terms_of_servicepage.dart';

class UserPersonalSettingsPage extends StatefulWidget {
  const UserPersonalSettingsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserPersonalSettingsPageState createState() =>
      _UserPersonalSettingsPageState();
}

class _UserPersonalSettingsPageState extends State<UserPersonalSettingsPage> {
  bool notificationsEnabled = true;
  bool locationAccess = false;
  bool darkMode = false;
  bool autoSync = true;

  @override
  Widget build(BuildContext context) {
    bool personalizedAds = false;
    return Scaffold(
      appBar: AppBar(title: Text('Personal Settings'), centerTitle: true),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildSwitchTile(
            title: 'Enable Notifications',
            subtitle: 'Receive updates and alerts',
            value: notificationsEnabled,
            onChanged: (value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
          ),
          _buildSwitchTile(
            title: 'Location Access',
            subtitle: 'Allow app to access your location',
            value: locationAccess,
            onChanged: (value) {
              setState(() {
                locationAccess = value;
              });
            },
          ),
          /* _buildSwitchTile(
            title: 'Dark Mode',
            subtitle: 'Enable dark theme for the app',
            value: darkMode,
            onChanged: (value) {
              setState(() {
                darkMode = value;
              });
            },
          ),*/
          _buildSwitchTile(
            title: 'Personalized Ads',
            subtitle: 'Receive ads based on your interactions and preferences',
            value: personalizedAds,
            onChanged: (value) {
              setState(() {
                personalizedAds = value;
              });
            },
          ),

          Divider(),
          ListTile(
            title: Text('Privacy Policy'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Privacy Policy page
              Get.to(() => PrivacyPolicyPage());
            },
          ),
          ListTile(
            title: Text('Terms of Service'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Terms of Service page
              Get.to(() => TermsOfServicePage());
            },
          ),

          SizedBox(height: 50),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.red,
                          size: 60,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Delete Account',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Are you sure you want to delete your account? This action cannot be undone and all your data will be lost.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                // Handle account deletion logic here
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text(
                                'Delete',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: Text(
              'Delete Account',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }
}
