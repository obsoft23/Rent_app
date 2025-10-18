// ignore_for_file: library_private_types_in_public_api

import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:rentapp/components/demo_lists.dart';
import 'package:rentapp/theme/theme.dart';
import 'package:rentapp/view/tab_pages/favourites_page/enquiry_card.dart';

class AgentListingsPage extends StatefulWidget {
  const AgentListingsPage({super.key});

  @override
  _AgentListingsPageState createState() => _AgentListingsPageState();
}

class ListingCard extends StatelessWidget {
  final dynamic listing; // Replace 'dynamic' with the actual type of 'listing'

  const ListingCard({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              listing['title'] ?? 'Listing Title', // Replace with actual data
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              listing['description'] ??
                  'Listing Description', // Replace with actual data
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _AgentListingsPageState extends State<AgentListingsPage> {
  // ignore: prefer_typing_uninitialized_variables, non_constant_identifier_names
  List<dynamic> property_items_list = []; // Initialize as an empty list

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: const Text('Agent Listings'),
        centerTitle: true,

        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Filter Options',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        ListTile(
                          leading: Icon(Icons.arrow_downward),
                          title: Text('Price: High to Low'),
                          onTap: () {
                            // Add your filter logic here
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.arrow_upward),
                          title: Text('Price: Low to High'),
                          onTap: () {
                            // Add your filter logic here
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.near_me),
                          title: Text('Farthest from Me'),
                          onTap: () {
                            // Add your filter logic here
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.near_me_outlined),
                          title: Text('Nearest to Me'),
                          onTap: () {
                            // Add your filter logic here
                            Navigator.pop(context);
                          },
                        ),

                        ListTile(
                          leading: Icon(Icons.star_border),
                          title: Text('Ratings: High to Low'),
                          onTap: () {
                            // Add your filter logic here
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.star_half),
                          title: Text('Ratings: Low to High'),
                          onTap: () {
                            // Add your filter logic here
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder(
                future: Future.delayed(
                  Duration(seconds: 2),
                ), // Simulate loading
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      itemCount: 5, // Example count
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: CardLoading(
                            height: 80,
                            borderRadius: BorderRadius.circular(16),
                            margin: EdgeInsets.symmetric(vertical: 8),
                          ),
                        );
                      },
                    );
                  } else {
                    if (propery_items_list.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bookmark_border,
                              size: 80,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No saved properties yet',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            sliver: SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Your Profile',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  AgentProfileCard(),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          'Your Active Listings',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Text(
                                          'See All',
                                          style: TextStyle(
                                            color: igBlue,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }
                  // Default return to handle all cases
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
