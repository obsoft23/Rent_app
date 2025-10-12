import 'package:flutter/material.dart';

class FavFirstpage extends StatefulWidget {
  const FavFirstpage({super.key});

  @override
  State<FavFirstpage> createState() => _FavFirstpageState();
}

class _FavFirstpageState extends State<FavFirstpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, size: 64),
            SizedBox(height: 16),
            Text('Favorites', style: TextStyle(fontSize: 32)),
          ],
        ),
      ),
    );
  }
}
