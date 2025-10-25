// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentapp/theme/theme.dart';
import 'package:rentapp/view/tab_pages/agent_listing_page/add%20listings/agent_add_listings.dart';
import 'package:rentapp/view/tab_pages/agent_listing_page/agent_profile/edit_agent_profile.dart';
import 'package:rentapp/view/tab_pages/agent_listing_page/agent_profile/view_agent_metrics.dart';

class AgentProfileCard extends StatelessWidget {
  const AgentProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=300&auto=format&fit=crop',
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hilary Ouse',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'hilary@ouse.com',
                      style: TextStyle(color: Color(0xFF6B6B6B), fontSize: 13),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),

                            ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Edit Your Agent Profile'),
                              onTap: () {
                                // Add your edit profile logic here
                                Navigator.pop(context);
                                Get.to(() => EditAgentProfilePage());
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.bar_chart),
                              title: Text('View Profile Metrics'),
                              onTap: () {
                                // Add your view metrics logic here
                                Navigator.pop(context);
                                Get.to(() => ViewAgentMetricsPage());
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.support_agent),
                              title: Text('Contact Support About Your Profile'),
                              onTap: () {
                                // Add your contact support logic here
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.more_horiz),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(
                child: _StatTile(
                  label: 'PROPERTY LIKES',
                  value: '28',
                  icon: Icons.favorite,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  label: 'PROPERTY LISTED',
                  value: '14',
                  icon: Icons.home,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          InkWell(
            onTap: () {
              // Handle add listing action
              Get.offAll(() => AgentAddListingsPage());
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  'Add Listing',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDEDF3)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7FB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF8C8C8C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final Property item;
  const PropertyCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Image.network(item.imageUrl, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                left: 12,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '\$${item.price}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              item.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 18),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${item.city}, ${item.country}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                const Icon(Icons.place, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${item.distanceMiles.toStringAsFixed(1)} miles',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B6B6B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class Property {
  final String title;
  final String city;
  final String country;
  final double price;
  final double distanceMiles;
  final String imageUrl;

  Property({
    required this.title,
    required this.city,
    required this.country,
    required this.price,
    required this.distanceMiles,
    required this.imageUrl,
  });
}

final _demoProperties = <Property>[
  Property(
    title: 'Detached Villa',
    city: 'New York',
    country: 'USA',
    price: 1500,
    distanceMiles: 1.7,
    imageUrl:
        'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?q=80&w=1200&auto=format&fit=crop',
  ),
  Property(
    title: 'Modern Loft',
    city: 'Los Angeles',
    country: 'USA',
    price: 2100,
    distanceMiles: 3.2,
    imageUrl:
        'https://images.unsplash.com/photo-1493809842364-78817add7ffb?q=80&w=1200&auto=format&fit=crop',
  ),
  Property(
    title: 'Scandi Apartment',
    city: 'Stockholm',
    country: 'Sweden',
    price: 1200,
    distanceMiles: 0.9,
    imageUrl:
        'https://images.unsplash.com/photo-1524758631624-e2822e304c36?q=80&w=1200&auto=format&fit=crop',
  ),
];
