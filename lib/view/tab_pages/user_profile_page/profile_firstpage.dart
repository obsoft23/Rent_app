import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentapp/theme/theme.dart';
import 'package:rentapp/view/first_page.dart';
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
  bool isGuestUser() {
    // Replace with your logic to determine if the user is a guest
    return true; // Example: Always returns true for now
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
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
              if (!isGuestUser())
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
                Column(
                  children: [
                    // Profile Picture
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150',
                      ),
                    ),
                    SizedBox(height: 16),
                    // User Name
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    // User Email
                    Text(
                      'johndoe@example.com',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 24),
                    // Profile Options
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Account Information'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to Account Information
                        Get.to(
                          () => AccountInformationPage(
                            user: AccountInfo(
                              id: '1',
                              fullName: 'John Doe',
                              email: 'johndoe@example.com',
                              phone: '123-456-7890',
                              avatarUrl: 'https://via.placeholder.com/150',
                              joinedAt: DateTime.now(),
                            ),
                          ),
                        );
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.lock),
                      title: Text('Change Password'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to Change Password
                        Get.to(() => ChangePasswordProfilePage());
                      },
                    ),
                    Divider(),
                    /* ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text('Notifications'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to Notifications
                      },
                    ),
                    Divider(),*/
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to Settings
                        Get.to(() => UserPersonalSettingsPage());
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.help),
                      title: Text('Help & Support'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to Help & Support
                        Get.to(() => HelpSupportPage());
                      },
                    ),

                    SizedBox(height: 24),

                    // Logout Button
                    /* ElevatedButton.icon(
                      onPressed: () {
                        // Handle Logout
                      },
                      icon: Icon(Icons.logout),
                      label: Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                    ),*/
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
