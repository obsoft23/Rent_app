// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

// Sample data - replace with your actual data model
final List<Map<String, dynamic>> list_view_properties = [
  {
    'id': 1,
    'media': [
      {'type': 'image', 'url': 'https://via.placeholder.com/600x400/FF6B6B'},
      {'type': 'image', 'url': 'https://via.placeholder.com/600x400/4ECDC4'},
      {'type': 'image', 'url': 'https://via.placeholder.com/600x400/45B7D1'},
    ],
    'price': '\$1,200/month',
    'title': 'Modern Apartment',
    'location': 'Downtown, City',
    'beds': 2,
    'baths': 2,
  },
  {
    'id': 2,
    'media': [
      {'type': 'image', 'url': 'https://via.placeholder.com/600x400/F7B731'},
      {'type': 'image', 'url': 'https://via.placeholder.com/600x400/5F27CD'},
      {'type': 'image', 'url': 'https://via.placeholder.com/600x400/00D2D3'},
      {'type': 'image', 'url': 'https://via.placeholder.com/600x400/FF6348'},
    ],
    'price': '\$2,500/month',
    'title': 'Luxury Condo',
    'location': 'Uptown, City',
    'beds': 3,
    'baths': 2,
  },
];

class PropertyListViewCard extends StatefulWidget {
  final Map<String, dynamic> property;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const PropertyListViewCard({
    super.key,
    required this.property,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  State<PropertyListViewCard> createState() => _PropertyListViewCardState();
}

class _PropertyListViewCardState extends State<PropertyListViewCard>
    with SingleTickerProviderStateMixin {
  bool _showHeart = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  int _currentMediaIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    widget.onFavoriteToggle();
    setState(() {
      _showHeart = true;
    });
    _animationController.forward().then((_) {
      _animationController.reverse().then((_) {
        setState(() {
          _showHeart = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = widget.property['media'] as List<dynamic>;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  child: Text(widget.property['title'][0]),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.property['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.property['location'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Horizontal scrolling media with double-tap
          GestureDetector(
            onDoubleTap: _handleDoubleTap,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 400,
                  child: PageView.builder(
                    itemCount: media.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentMediaIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final mediaItem = media[index];
                      return Container(
                        color: Colors.grey[300],
                        child: Image.network(
                          mediaItem['url'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.home,
                                size: 100,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                // Media indicator dots
                Positioned(
                  top: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      media.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentMediaIndex == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
                if (_showHeart)
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
              ],
            ),
          ),

          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: widget.isFavorite ? Colors.red : Colors.black,
                  ),
                  onPressed: widget.onFavoriteToggle,
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {},
                ),
                IconButton(icon: const Icon(Icons.share), onPressed: () {}),
              ],
            ),
          ),

          // Property details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.property['price'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.property['beds']} beds • ${widget.property['baths']} baths',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          const Divider(thickness: 1),
        ],
      ),
    );
  }
}
