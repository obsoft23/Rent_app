import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:rentapp/components/demo_lists.dart';
import 'package:rentapp/components/property_card_grid.dart';

class SavedFirstpage extends StatefulWidget {
  const SavedFirstpage({super.key});

  @override
  State<SavedFirstpage> createState() => _SavedFirstpageState();
}

class _SavedFirstpageState extends State<SavedFirstpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved Properties',
          style: TextStyle(fontSize: 18), // Reduced text size
        ),
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
        centerTitle: true,
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
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            /* Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: propery_items_list.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, i) =>
                    PropertyCard(stay: propery_items_list[i]),
              ),
            ), */
                            Expanded(
                              child: GridView.builder(
                                padding: const EdgeInsets.only(bottom: 24),
                                itemCount: propery_items_list.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 18,
                                      crossAxisSpacing: 14,
                                      childAspectRatio: 0.72,
                                    ),
                                itemBuilder: (context, i) =>
                                    PropertyCard(stay: propery_items_list[i]),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
