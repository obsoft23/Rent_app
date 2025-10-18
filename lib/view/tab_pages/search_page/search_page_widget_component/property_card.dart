// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rentapp/components/property_card_grid.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <Stay>[
      Stay(
        title: 'Bratislava',
        price: 1200,
        rating: 5.0,
        badge: 'Hot this Month',
        guests: 3,
        imageUrl:
            'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?q=80&w=1200',
      ),
      Stay(
        title: 'RetroFlat',
        price: 1400,
        rating: 4.8,
        badge: 'Great Ratio',
        guests: 2,
        imageUrl:
            'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?q=80&w=1200',
      ), // Add more items if you want
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7FB),
        elevation: 0,
        title: const Text(
          'Discover',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 26),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 18,
            crossAxisSpacing: 14,
            // taller cell to match screenshot proportions
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, i) => PropertyCard(stay: items[i]),
        ),
      ),
    );
  }
}
