import 'package:flutter/material.dart';
import 'package:rentapp/theme/theme.dart';

class BuyFirstPage extends StatelessWidget {
  const BuyFirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search & Buy',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: igBlue,
      ),
      body: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          // Loading Cards List
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Number of loading cards
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Card(
                    elevation: 2,
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey[300],
                      ),
                      title: Container(height: 10, color: Colors.grey[300]),
                      subtitle: Container(
                        height: 10,
                        margin: const EdgeInsets.only(top: 8.0),
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
