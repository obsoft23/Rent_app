// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:rentapp/theme/theme.dart';

class Listing {
  final String id;
  final String title;
  final String location;
  final double pricePerMonth;
  final String imageUrl;
  final bool isActive;

  Listing({
    required this.id,
    required this.title,
    required this.location,
    required this.pricePerMonth,
    required this.imageUrl,
    required this.isActive,
  });

  Listing copyWith({
    String? id,
    String? title,
    String? location,
    double? pricePerMonth,
    String? imageUrl,
    bool? isActive,
  }) {
    return Listing(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      pricePerMonth: pricePerMonth ?? this.pricePerMonth,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
    );
  }
}

class AgentAllListingsPage extends StatelessWidget {
  final List<Listing> listings;
  final ValueChanged<Listing>? onTapListing;
  final ValueChanged<Listing>? onEditListing;
  final ValueChanged<Listing>? onToggleActive;
  final ValueChanged<Listing>? onDeleteListing;

  AgentAllListingsPage({
    super.key,
    List<Listing>? listings,
    this.onTapListing,
    this.onEditListing,
    this.onToggleActive,
    this.onDeleteListing,
  }) : listings = listings ?? _demoListings;

  @override
  Widget build(BuildContext context) {
    final activeListings = listings.where((l) => l.isActive).toList();
    final inactiveListings = listings.where((l) => !l.isActive).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Listings'),
          bottom: const TabBar(
            isScrollable: false,
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Inactive'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ListingsTab(
              listings: activeListings,
              emptyMessage: 'No active listings yet.',
              onTapListing: onTapListing,
              onEditListing: onEditListing,
              onToggleActive: onToggleActive,
              onDeleteListing: onDeleteListing,
            ),
            _ListingsTab(
              listings: inactiveListings,
              emptyMessage: 'No inactive listings.',
              onTapListing: onTapListing,
              onEditListing: onEditListing,
              onToggleActive: onToggleActive,
              onDeleteListing: onDeleteListing,
            ),
          ],
        ),
      ),
    );
  }
}

class _ListingsTab extends StatelessWidget {
  final List<Listing> listings;
  final String emptyMessage;
  final ValueChanged<Listing>? onTapListing;
  final ValueChanged<Listing>? onEditListing;
  final ValueChanged<Listing>? onToggleActive;
  final ValueChanged<Listing>? onDeleteListing;

  const _ListingsTab({
    required this.listings,
    required this.emptyMessage,
    this.onTapListing,
    this.onEditListing,
    this.onToggleActive,
    this.onDeleteListing,
  });

  @override
  Widget build(BuildContext context) {
    if (listings.isEmpty) {
      return Center(
        child: Text(emptyMessage, style: Theme.of(context).textTheme.bodyLarge),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: listings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final listing = listings[index];
        return _ListingCard(
          listing: listing,
          onTap: () => onTapListing?.call(listing),
          onEdit: () => onEditListing?.call(listing),
          onToggleActive: () => onToggleActive?.call(listing),
          onDelete: () => onDeleteListing?.call(listing),
        );
      },
    );
  }
}

class _ListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onToggleActive;
  final VoidCallback? onDelete;

  const _ListingCard({
    required this.listing,
    this.onTap,
    this.onEdit,
    this.onToggleActive,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = listing.isActive ? Colors.green : Colors.grey;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: listing.imageUrl.isEmpty
                  ? Container(
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.home_rounded,
                        size: 30,
                        color: Colors.grey,
                      ),
                    )
                  : Image.network(
                      listing.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(
                          //  Icons.broken_image_rounded,
                          Icons.home_rounded,
                          size: 48,
                          color: Colors.grey,
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                listing.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Chip(
                              label: Text(
                                listing.isActive ? 'Active' : 'Inactive',
                              ),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              labelStyle: TextStyle(
                                color: listing.isActive
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              backgroundColor: statusColor.withOpacity(
                                listing.isActive ? 0.9 : 0.2,
                              ),
                              side: BorderSide(color: statusColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.place_rounded,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                listing.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey[700]),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₦${listing.pricePerMonth.toStringAsFixed(0)}/month',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  // Actions
                  ListingActionsButton(
                    listing: listing,
                    onEdit: onEdit,
                    onToggleActive: onToggleActive,
                    onDelete: onDelete,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A replacement for the popup menu that shows a bottom sheet for actions.
class ListingActionsButton extends StatelessWidget {
  final Listing listing;
  final VoidCallback? onEdit;
  final VoidCallback? onToggleActive;
  final VoidCallback? onDelete;

  const ListingActionsButton({
    Key? key,
    required this.listing,
    this.onEdit,
    this.onToggleActive,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.more_vert),
      onPressed: () => showListingActionsBottomSheet(
        context,
        listing: listing,
        onEdit: onEdit,
        onToggleActive: onToggleActive,
        onDelete: onDelete,
      ),
      tooltip: 'More actions',
    );
  }
}

Future<void> showListingActionsBottomSheet(
  BuildContext context, {
  required Listing listing,
  VoidCallback? onEdit,
  VoidCallback? onToggleActive,
  VoidCallback? onDelete,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      final toggleText = listing.isActive ? 'Mark Inactive' : 'Mark Active';
      final toggleIcon = listing.isActive
          ? Icons.pause_circle_filled
          : Icons.play_circle_fill;

      return SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.of(context).pop();
                onEdit?.call();
              },
            ),
            ListTile(
              leading: Icon(toggleIcon),
              title: Text(toggleText),
              onTap: () {
                Navigator.of(context).pop();
                onToggleActive?.call();
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text(
                'View Performance Metrics',
                style: TextStyle(color: Colors.green),
              ),
              onTap: () {
                Navigator.of(context).pop();
                onDelete?.call();
              },
            ),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.of(context).pop();
                onDelete?.call();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}

// Demo data. Replace with real data source.
final List<Listing> _demoListings = [
  Listing(
    id: '1',
    title: '2-Bedroom Apartment',
    location: 'Lekki Phase 1, Lagos',
    pricePerMonth: 350000,
    imageUrl: 'https://images.unsplash.com/photo-1499914485622-a88fac536970',
    isActive: true,
  ),
  Listing(
    id: '2',
    title: 'Studio Apartment',
    location: 'Yaba, Lagos',
    pricePerMonth: 180000,
    imageUrl: 'https://images.unsplash.com/photo-1499914485622-a88fac536970',
    isActive: false,
  ),
  Listing(
    id: '3',
    title: '3-Bedroom Duplex',
    location: 'Gbagada, Lagos',
    pricePerMonth: 550000,
    imageUrl:
        'https://media.istockphoto.com/id/1403215723/photo/cuba-architecture.jpg?s=1024x1024&w=is&k=20&c=AeHZqcDXVv-3Z-xucGZHkn8TfUCOegh244hirZmw2xs=',
    isActive: true,
  ),
];
