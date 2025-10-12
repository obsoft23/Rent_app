import 'package:flutter/material.dart';

class ProfileFirstpage extends StatefulWidget {
  const ProfileFirstpage({super.key});

  @override
  State<ProfileFirstpage> createState() => _ProfileFirstpageState();
}

class _ProfileFirstpageState extends State<ProfileFirstpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 64),
            SizedBox(height: 16),
            Text('Profile', style: TextStyle(fontSize: 32)),
          ],
        ),
      ),
    );
  }
}
