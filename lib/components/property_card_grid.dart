import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rentapp/view/tab_pages/search_page/search_page_widget_component/property/view_rent_property.dart';

class PropertyCard extends StatelessWidget {
  final Stay stay;
  const PropertyCard({required this.stay, super.key});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18);

    return InkWell(
      onTap: () {
        //  Get.to(() => PropertyDetailsPage(stay: stay, property: null,));
        /* Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PropertyDetailsPage(
              heroTag: 'stay_${stay.title}', // match the Hero tag you used
              property: Property(
                title: 'Retro Flat',
                street: 'Leministro street',
                price: 1200,
                rating: 5.0,
                imageUrl: 'https://…/bedroom.jpg',
                features: const ['2 bedrooms', 'Good location', 'Privacy'],
                description:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry…',
                agentPhone: '+441234567890',
              ),
            ),
          ),
        );*/
      },
      borderRadius: radius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with overlay badge
          ClipRRect(
            borderRadius: radius,
            child: AspectRatio(
              aspectRatio: 16 / 11,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(stay.imageUrl, fit: BoxFit.cover),
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: _PillBadge(text: stay.badge),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Title
          Text(
            stay.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16.5),
          ),
          const SizedBox(height: 6),
          // Price
          Text(
            '₦${stay.price}',
            style: TextStyle(
              color: Colors.black.withOpacity(0.7),
              fontSize: 15.5,
            ),
          ),
          const SizedBox(height: 6),
          // Rating chip + guests (light)
          Row(
            children: [
              _RatingChip(rating: stay.rating),
              const SizedBox(width: 8),
              Icon(
                Icons.person,
                size: 16,
                color: Colors.black.withOpacity(0.35),
              ),
              const SizedBox(width: 2),
              Text(
                '${stay.guests}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black.withOpacity(0.35),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PillBadge extends StatelessWidget {
  final String text;
  const _PillBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _RatingChip extends StatelessWidget {
  final double rating;
  const _RatingChip({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black.withOpacity(0.08)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite, size: 14, color: Colors.redAccent),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}

class Stay {
  final String title;
  final int price;
  final double rating;
  final String badge;
  final int guests;
  final String imageUrl;

  Stay({
    required this.title,
    required this.price,
    required this.rating,
    required this.badge,
    required this.guests,
    required this.imageUrl,
  });
}
