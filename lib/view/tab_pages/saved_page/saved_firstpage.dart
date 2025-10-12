import 'package:flutter/material.dart';

class SavedFirstpage extends StatefulWidget {
  const SavedFirstpage({super.key});

  @override
  State<SavedFirstpage> createState() => _SavedFirstpageState();
}

class _SavedFirstpageState extends State<SavedFirstpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_outline, size: 64),
            SizedBox(height: 16),
            Text('Saved', style: TextStyle(fontSize: 32)),
          ],
        ),
      ),
    );
  }
}
