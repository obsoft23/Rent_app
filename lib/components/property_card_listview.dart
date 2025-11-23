// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:rentapp/view/tab_pages/search_page/search_page_widget_component/property/view_rent_property.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// Sample data - replace with your actual data model
class Property {
  final int id;
  final List<PropertyMedia> media;
  final String price;
  final String listingType;
  final String title;
  final String location;
  final int beds;
  final int baths;
  final String? description;
  final int? likes;
  final PropertyAgent? agent;

  Property({
    required this.id,
    required this.media,
    required this.price,
    required this.listingType,
    required this.title,
    required this.location,
    required this.beds,
    required this.baths,
    this.description,
    this.likes,
    this.agent,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      media: (json['media'] as List)
          .map((m) => PropertyMedia.fromJson(m))
          .toList(),
      price: json['price'],
      listingType: json['listingType'],
      title: json['title'],
      location: json['location'],
      beds: json['beds'],
      baths: json['baths'],
      description: json['description'],
      likes: json['likes'],
      agent: json['agent'] != null
          ? PropertyAgent.fromJson(json['agent'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'media': media.map((m) => m.toJson()).toList(),
      'price': price,
      'listingType': listingType,
      'title': title,
      'location': location,
      'beds': beds,
      'baths': baths,
      'description': description,
      'likes': likes,
      'agent': agent?.toJson(),
    };
  }

  Map<String, dynamic> toMap() {
    return toJson();
  }
}

class PropertyMedia {
  final String type;
  final String url;

  PropertyMedia({required this.type, required this.url});

  factory PropertyMedia.fromJson(Map<String, dynamic> json) {
    return PropertyMedia(type: json['type'], url: json['url']);
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'url': url};
  }
}

class PropertyAgent {
  final String name;
  final String contact;
  final String phone;

  PropertyAgent({
    required this.name,
    required this.contact,
    required this.phone,
  });

  factory PropertyAgent.fromJson(Map<String, dynamic> json) {
    return PropertyAgent(
      name: json['name'],
      contact: json['contact'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'contact': contact, 'phone': phone};
  }
}

final List<Property> list_view_properties = [
  Property.fromJson({
    'id': 1,
    'media': [
      {
        'type': 'image',
        'url': 'https://images.unsplash.com/photo-1568605114967-8130f3a36994',
      },
      {
        'type': 'image',
        'url': 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9',
      },
      {
        'type': 'image',
        'url': 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c',
      },
      {'type': 'video', 'url': 'https://www.youtube.com/watch?v=zumJJUL_ruM'},
    ],
    'price': '₦480,000/month',
    'listingType': 'rent',
    'title': 'Modern Apartment',
    'location': 'Downtown, City',
    'beds': 2,
    'baths': 2,
    'description':
        'A modern apartment with all the amenities you need for comfortable living.',
    'likes': 120,
    'agent': {
      'name': 'John Doe',
      'contact': 'john.doe@example.com',
      'phone': '+234 812 345 6789',
    },
  }),
  Property.fromJson({
    'id': 2,
    'media': [
      {
        'type': 'image',
        'url': 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6',
      },
      {
        'type': 'image',
        'url': 'https://images.unsplash.com/photo-1613490493576-7fde63acd811',
      },
      {
        'type': 'image',
        'url': 'https://images.unsplash.com/photo-1600566753086-00f18fb6b3ea',
      },
      {'type': 'video', 'url': 'https://www.youtube.com/watch?v=8qtIdaJ779Y'},
    ],
    'price': '₦1,000,000/month',
    'listingType': 'rent',
    'title': 'Luxury Condo',
    'location': 'Uptown, City',
    'beds': 3,
    'baths': 2,
    'description':
        'A luxurious condo with stunning views and premium facilities.',
    'likes': 250,
    'agent': {
      'name': 'Jane Smith',
      'contact': 'jane.smith@example.com',
      'phone': '+234 813 456 7890',
    },
  }),
  Property.fromJson({
    'id': 3,
    'media': [
      {
        'type': 'image',
        'url': 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914',
      },
      {
        'type': 'image',
        'url': 'https://images.unsplash.com/photo-1583608205776-bfd35f0d9f83',
      },
      {
        'type': 'image',
        'url': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750',
      },
      {'type': 'video', 'url': 'https://www.youtube.com/watch?v=1jJIrToLH8o'},
    ],
    'price': '₦45,000,000',
    'listingType': 'buy',
    'title': 'Suburban Villa',
    'location': 'Green Valley, Suburbs',
    'beds': 4,
    'baths': 3,
    'description': 'A spacious villa in a serene suburban neighborhood.',
    'likes': 300,
    'agent': {
      'name': 'Michael Johnson',
      'contact': 'michael.johnson@example.com',
      'phone': '+234 814 567 8901',
    },
  }),
  Property.fromJson({
    'id': 4,
    'media': [
      {
        'type': 'image',
        'url': 'https://images.unsplash.com/photo-1570129477492-45c003edd2be',
      },
      {
        'type': 'image',
        'url': 'https://images.unsplash.com/photo-1605276374104-dee2a0ed3cd6',
      },
      {
        'type': 'image',
        'url': 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
      },
      {'type': 'video', 'url': 'https://www.youtube.com/watch?v=vVvHqMaPHRw'},
    ],
    'price': '₦720,000/month',
    'listingType': 'rent',
    'title': 'Cozy Family Home',
    'location': 'Riverside, District',
    'beds': 3,
    'baths': 2,
  }),
  Property.fromJson({
    'id': 5,
    'media': [
      {
        'type': 'image',
        'url': 'https://images.unsplash.com/photo-1599809275671-b5942cabc7a2',
      },
      {
        'type': 'image',
        'url': 'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde',
      },
      {
        'type': 'image',
        'url': 'https://images.unsplash.com/photo-1572120360610-d971b9d7767c',
      },
      {'type': 'video', 'url': 'https://www.youtube.com/watch?v=dP15zlyra3c'},
    ],
    'price': '₦380,000/month',
    'listingType': 'rent',
    'title': 'Studio Apartment',
    'location': 'Central Park Area',
    'beds': 1,
    'baths': 1,
  }),
  Property.fromJson({
    'id': 6,
    'media': [
      {
        'type': 'image',
        'url': 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2',
      },
      {
        'type': 'image',
        'url': 'https://images.unsplash.com/photo-1600607687644-c7171b42498b',
      },
      {
        'type': 'image',
        'url': 'https://images.unsplash.com/photo-1600585154526-990dced4db0d',
      },
      {'type': 'video', 'url': 'https://www.youtube.com/watch?v=Oe421EPjeBE'},
    ],
    'price': '₦85,000,000',
    'listingType': 'buy',
    'title': 'Penthouse Suite',
    'location': 'Skyline Tower, Downtown',
    'beds': 5,
    'baths': 4,
  }),
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
  final Map<int, VideoPlayerController> _videoControllers = {};
  final Map<int, YoutubePlayerController> _youtubeControllers = {};

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
    _videoControllers.forEach((key, controller) {
      controller.dispose();
    });
    _youtubeControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  VideoPlayerController? _getVideoController(int index, String url) {
    if (!_videoControllers.containsKey(index)) {
      final controller = VideoPlayerController.network(url)
        ..initialize().then((_) {
          if (mounted) setState(() {});
        });
      _videoControllers[index] = controller;
    }
    return _videoControllers[index];
  }

  YoutubePlayerController? _getYoutubeController(int index, String url) {
    final videoId = _extractYoutubeVideoId(url);
    if (videoId == null) return null;

    if (!_youtubeControllers.containsKey(index)) {
      final controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          loop: false,
          disableDragSeek: false,
          enableCaption: false,
          controlsVisibleAtStart: false,
        ),
      );
      _youtubeControllers[index] = controller;
    }
    return _youtubeControllers[index];
  }

  String? _extractYoutubeVideoId(String url) {
    // Handle various YouTube URL formats
    final RegExp youtubeRegex = RegExp(
      r'(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})',
    );
    final match = youtubeRegex.firstMatch(url);
    return match?.group(1);
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

    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 16,
                      child: Text(widget.property['title'][0]),
                    ),
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

            // Media carousel with double-tap handler
            GestureDetector(
              onDoubleTap: _handleDoubleTap,
              child: SizedBox(
                height: 400,
                child: Stack(
                  children: [
                    PageView.builder(
                      itemCount: media.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentMediaIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final mediaItem = media[index];
                        if (mediaItem['type'] == 'video') {
                          final url = mediaItem['url'] as String;

                          // Check if it's a YouTube URL
                          if (_extractYoutubeVideoId(url) != null) {
                            final youtubeController = _getYoutubeController(
                              index,
                              url,
                            );
                            if (youtubeController != null) {
                              return YoutubePlayerBuilder(
                                player: YoutubePlayer(
                                  controller: youtubeController,
                                  showVideoProgressIndicator: true,
                                  progressIndicatorColor: Colors.red,
                                  progressColors: const ProgressBarColors(
                                    playedColor: Colors.red,
                                    handleColor: Colors.redAccent,
                                  ),
                                ),
                                builder: (context, player) {
                                  return Container(
                                    color: Colors.black,
                                    child: player,
                                  );
                                },
                              );
                            }
                          } else {
                            // Handle direct video URLs
                            final controller = _getVideoController(index, url);
                            if (controller != null &&
                                controller.value.isInitialized) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    controller.value.isPlaying
                                        ? controller.pause()
                                        : controller.play();
                                  });
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    AspectRatio(
                                      aspectRatio: controller.value.aspectRatio,
                                      child: VideoPlayer(controller),
                                    ),
                                    if (!controller.value.isPlaying)
                                      const Icon(
                                        Icons.play_circle_outline,
                                        size: 100,
                                        color: Colors.white,
                                      ),
                                  ],
                                ),
                              );
                            }
                          }

                          // Loading state for both YouTube and direct videos
                          return Container(
                            color: Colors.black,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          );
                        }
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
                    // Media indicator dots
                    Positioned(
                      top: 12,
                      left: 0,
                      right: 0,
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
                      Positioned.fill(
                        child: Center(
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 100,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          widget.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.isFavorite ? Colors.red : Colors.black,
                          size: 30,
                        ),
                        onPressed: widget.onFavoriteToggle,
                      ),
                      IconButton(
                        icon: const Icon(Icons.send_outlined, size: 28),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Send an Inquiry',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                        hintText: 'Write your review here...',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        // Handle review submission logic here
                                      },
                                      child: const Text('Submit'),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      //  IconButton(icon: const Icon(Icons.share), onPressed: () {}),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: widget.property['listingType'] == 'rent'
                                  ? Colors.blue.shade100
                                  : Colors.green.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              widget.property['listingType'] == 'rent'
                                  ? 'FOR RENT'
                                  : 'FOR SALE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: widget.property['listingType'] == 'rent'
                                    ? Colors.blue.shade700
                                    : Colors.green.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.property['price'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Property details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Divider(thickness: 1, height: 16),
                  Row(
                    children: [
                      Icon(Icons.king_bed, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.property['beds']} beds',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.bathtub, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.property['baths']} baths',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(thickness: 1, height: 16),
          ],
        ),
      ),
    );
  }
}
