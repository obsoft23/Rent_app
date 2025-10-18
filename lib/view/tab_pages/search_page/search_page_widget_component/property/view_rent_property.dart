// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyDetailsPage extends StatelessWidget {
  final Property property;
  final String? heroTag; // pass the same tag from your card for a Hero anim

  const PropertyDetailsPage({super.key, required this.property, this.heroTag});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(28);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4FB),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: radius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: radius,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top image with gradient and back button
                  Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 11,
                        child: heroTag == null
                            ? Image.network(
                                property.imageUrl,
                                fit: BoxFit.cover,
                              )
                            : Hero(
                                tag: heroTag!,
                                child: Image.network(
                                  property.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      // nice white fade at bottom of image
                      Positioned.fill(
                        child: IgnorePointer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.center,
                                colors: [
                                  Colors.white.withOpacity(0.95),
                                  Colors.white.withOpacity(0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        top: 12,
                        child: _CircleIconButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: () => Navigator.of(context).maybePop(),
                        ),
                      ),
                    ],
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    property.title,
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800,
                                      height: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    property.street,
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.55),
                                      fontSize: 14.5,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    '\$${property.price}',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _RatingPill(rating: property.rating),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Feature chips
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: property.features
                              .map((f) => _SoftChip(label: f))
                              .toList(),
                        ),
                        const SizedBox(height: 16),

                        Text(
                          property.description,
                          style: TextStyle(
                            fontSize: 15.5,
                            height: 1.5,
                            color: Colors.black.withOpacity(0.72),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // Bottom action bar
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.call),
                label: const Text('Call'),
                onPressed: () async {
                  final uri = Uri.parse('tel:${property.agentPhone}');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not launch dialer')),
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.forum_outlined),
                label: const Text('Enquire / Agent'),
                onPressed: () {
                  // open your enquiry sheet / chat / form
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (_) => _EnquirySheet(property: property),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple model you can reuse from your list page
class Property {
  final String title;
  final String street;
  final int price;
  final double rating;
  final String imageUrl;
  final List<String> features;
  final String description;
  final String agentPhone;

  Property({
    required this.title,
    required this.street,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.features,
    required this.description,
    required this.agentPhone,
  });
}

// ----------------- little UI helpers -----------------

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.9),
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        ),
      ),
    );
  }
}

class _RatingPill extends StatelessWidget {
  final double rating;
  const _RatingPill({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black.withOpacity(0.08)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 16, color: Colors.amber.shade700),
          const SizedBox(width: 5),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _SoftChip extends StatelessWidget {
  final String label;
  const _SoftChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.07)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

class _EnquirySheet extends StatelessWidget {
  final Property property;
  const _EnquirySheet({required this.property});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(
      text:
          'Hi, I\'m interested in ${property.title} on ${property.street}. Is it still available?',
    );

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Enquire about ${property.title}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 5,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            icon: const Icon(Icons.send_outlined),
            label: const Text('Send Enquiry'),
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Enquiry sent')));
            },
          ),
        ],
      ),
    );
  }
}
