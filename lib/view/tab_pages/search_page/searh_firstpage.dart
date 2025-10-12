import 'package:flutter/material.dart';

class SearhFirstpage extends StatefulWidget {
  const SearhFirstpage({super.key});

  @override
  State<SearhFirstpage> createState() => _SearhFirstpageState();
}

class _SearhFirstpageState extends State<SearhFirstpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64),
            SizedBox(height: 16),
            Text('Search', style: TextStyle(fontSize: 32)),
          ],
        ),
      ),
    );
  }
}
