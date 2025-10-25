// File: lib/view/tab_pages/agent_listing_page/add listings/agent_add_listings.dart
//
// High-end Add Property UI for agents with media, location search, and details.
// Dependencies to add in pubspec.yaml (recommended):
//   image_picker: ^1.0.7
// Optional (if you want actual place suggestions):
//   flutter_typeahead: ^5.2.0
//
// Integration notes:
// - This page can prefill from a Filter payload passed via route arguments or constructor.
//   Pass a Map<String, dynamic> or a strongly-typed object with common keys like:
//   { listingType, propertyTypes, minPrice, maxPrice, bedrooms, bathrooms, amenities, city, locationQuery, furnishing }
// - Provide a PlaceSearchProvider to connect your project’s place API (e.g., Google Places).
// - Provide onPickOnMap callback to integrate your project’s map picker page.
//
// Author: GitHub Copilot

import 'dart:async';
import 'dart:io' show File;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentapp/theme/theme.dart';

class AgentAddListingsPage extends StatefulWidget {
  const AgentAddListingsPage({
    super.key,
    this.initialFilterPayload,
    this.placeSearchProvider,
    this.onSubmit,
    this.onSaveDraft,
    this.onPickOnMap,
  });

  // Can be a Map<String, dynamic> or a custom object from filterpage.dart.
  final Object? initialFilterPayload;

  // Provide your own implementation to power the location search UX.
  final PlaceSearchProvider? placeSearchProvider;

  // Called with the consolidated form data when publishing.
  final FutureOr<void> Function(AgentListingFormData data)? onSubmit;

  // Called when saving a draft.
  final FutureOr<void> Function(AgentListingFormData data)? onSaveDraft;

  // Optional integration to open a map picker and return lat/lng + address.
  final Future<GeoAddress?> Function()? onPickOnMap;

  @override
  State<AgentAddListingsPage> createState() => _AgentAddListingsPageState();
}

class _AgentAddListingsPageState extends State<AgentAddListingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Stepper
  int _currentStep = 0;

  // Media
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _photos = [];
  final List<XFile> _videos = [];
  final List<TextEditingController> _videoUrlCtrls = [];

  // Details
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final sizeCtrl = TextEditingController();
  final yearBuiltCtrl = TextEditingController();
  final leaseTermsCtrl = TextEditingController();
  final currencyList = const ['NGN'];
  String currency = 'NGN';

  final sizeUnits = const ['sqft', 'sqm', 'acre', 'hectare'];
  String sizeUnit = 'sqm';

  final furnishingOptions = const [
    'Unfurnished',
    'Semi-furnished',
    'Furnished',
  ];

  String? furnishing;

  final listingTypes = const ['Rent', 'Sale', 'Lease'];
  String listingType = 'Rent';

  final propertyTypes = const [
    'Apartment',
    'House',
    'Condo',
    'Townhouse',
    'Land',
    'Commercial',
    'Office',
    'Retail',
    'Industrial',
    'Warehouse',
    'Co-working',
  ];
  String? propertyType;

  int bedrooms = 0;
  int bathrooms = 0;
  int parking = 0;

  bool petsAllowed = false;
  DateTime? availableFrom;

  // Amenities
  final List<String> amenityOptions = const [
    'Air Conditioning',
    'Parking',
    'Swimming Pool',
    'Gym',
    'Security',
    'Balcony',
    'Garden',
    'Elevator',
    'Power Backup',
    'Water Supply',
    'CCTV',
    'Wi-Fi',
    'Playground',
    'Serviced',
    'Gated Estate',
  ];
  final Set<String> selectedAmenities = {};

  // Location
  final addressCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final countryCtrl = TextEditingController();
  final postalCodeCtrl = TextEditingController();
  double? latitude;
  double? longitude;

  // UX
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _prefillFromFilterPayload(widget.initialFilterPayload);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    titleCtrl.dispose();
    descCtrl.dispose();
    priceCtrl.dispose();
    sizeCtrl.dispose();
    yearBuiltCtrl.dispose();
    leaseTermsCtrl.dispose();
    addressCtrl.dispose();
    cityCtrl.dispose();
    stateCtrl.dispose();
    countryCtrl.dispose();
    postalCodeCtrl.dispose();
    for (final c in _videoUrlCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  void _prefillFromFilterPayload(Object? payload) {
    if (payload == null) return;

    // Flexible mapping to common filter keys without importing filterpage.dart.
    // Customize this mapping to your app’s actual filter data model.
    try {
      final map = _asMap(payload);
      if (map == null) return;

      // listingType
      final lt = _string(map['listingType']) ?? _string(map['status']);
      if (lt != null && listingTypes.contains(_title(lt))) {
        listingType = _title(lt);
      } else if (lt != null) {
        if (lt.toLowerCase().contains('rent')) listingType = 'Rent';
        if (lt.toLowerCase().contains('sale') ||
            lt.toLowerCase().contains('buy')) {
          listingType = 'Sale';
        }
        if (lt.toLowerCase().contains('lease')) listingType = 'Lease';
      }

      // propertyType
      final pt =
          _string(map['propertyType']) ?? _firstString(map['propertyTypes']);
      if (pt != null) {
        final match = propertyTypes.firstWhere(
          (e) => e.toLowerCase() == pt.toLowerCase(),
          orElse: () => _closest(propertyTypes, pt),
        );
        propertyType = match;
      }

      // price
      final minPrice = _double(map['minPrice']);
      final maxPrice = _double(map['maxPrice']);
      if (minPrice != null && maxPrice != null) {
        priceCtrl.text = ((minPrice + maxPrice) / 2).round().toString();
      } else if (minPrice != null) {
        priceCtrl.text = minPrice.round().toString();
      } else if (maxPrice != null) {
        priceCtrl.text = maxPrice.round().toString();
      }
      final cur = _string(map['currency']);
      if (cur != null && currencyList.contains(cur.toUpperCase())) {
        currency = cur.toUpperCase();
      }

      // rooms
      bedrooms = _int(map['bedrooms']) ?? bedrooms;
      bathrooms = _int(map['bathrooms']) ?? bathrooms;
      parking = _int(map['parking']) ?? parking;

      // amenities
      final am = _stringList(map['amenities']);
      if (am != null) {
        for (final a in am) {
          final match = amenityOptions.firstWhere(
            (e) => e.toLowerCase() == a.toLowerCase(),
            orElse: () => '',
          );
          if (match.isNotEmpty) selectedAmenities.add(match);
        }
      }

      // furnishing
      final f = _string(map['furnishing']) ?? _string(map['furnished']);
      if (f != null) {
        final match = furnishingOptions.firstWhere(
          (e) => e.toLowerCase().contains(f.toLowerCase()),
          orElse: () => '',
        );
        if (match.isNotEmpty) furnishing = match;
      }

      // location
      addressCtrl.text = _string(map['address']) ?? addressCtrl.text;
      cityCtrl.text = _string(map['city']) ?? cityCtrl.text;
      stateCtrl.text = _string(map['state']) ?? stateCtrl.text;
      countryCtrl.text = _string(map['country']) ?? countryCtrl.text;
      postalCodeCtrl.text = _string(map['postalCode']) ?? postalCodeCtrl.text;

      latitude = _double(map['lat']) ?? _double(map['latitude']) ?? latitude;
      longitude = _double(map['lng']) ?? _double(map['longitude']) ?? longitude;
    } catch (_) {
      // Ignore graceful prefill errors.
    }
    setState(() {});
  }

  // Helpers for flexible payload parsing
  Map<String, dynamic>? _asMap(Object? o) {
    if (o is Map<String, dynamic>) return o;
    if (o is Map) return o.map((k, v) => MapEntry('$k', v));
    return null;
  }

  String? _string(Object? o) => o?.toString();

  String _title(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();

  int? _int(Object? o) {
    if (o is int) return o;
    if (o is num) return o.toInt();
    if (o is String) return int.tryParse(o);
    return null;
  }

  double? _double(Object? o) {
    if (o is double) return o;
    if (o is num) return o.toDouble();
    if (o is String) return double.tryParse(o);
    return null;
  }

  List<String>? _stringList(Object? o) {
    if (o is List) return o.map((e) => e.toString()).toList();
    return null;
  }

  String _closest(List<String> options, String input) {
    final l = input.toLowerCase();
    final contains = options.firstWhere(
      (e) => e.toLowerCase().contains(l) || l.contains(e.toLowerCase()),
      orElse: () => options.first,
    );
    return contains;
  }

  // Media pickers
  Future<void> _pickPhotos() async {
    try {
      final picked = await _picker.pickMultiImage();
      if (picked.isNotEmpty) {
        setState(() => _photos.addAll(picked));
      }
    } catch (_) {}
  }

  // ignore: unused_element
  Future<void> _pickVideo() async {
    try {
      final picked = await _picker.pickVideo(source: ImageSource.gallery);
      if (picked != null) {
        setState(() => _videos.add(picked));
      }
    } catch (_) {}
  }

  void _addVideoUrlField() {
    setState(() => _videoUrlCtrls.add(TextEditingController()));
  }

  void _removeVideoUrlField(int index) {
    setState(() {
      _videoUrlCtrls.removeAt(index).dispose();
    });
  }

  // Location search
  Future<void> _openLocationSearch() async {
    if (widget.placeSearchProvider == null) {
      // Fallback: no provider, focus address field.
      FocusScope.of(context).requestFocus(FocusNode());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location search not configured. Enter address manually.',
          ),
        ),
      );
      return;
    }
    final result = await showSearch<GeoAddress?>(
      context: context,
      delegate: PlaceSearchDelegate(provider: widget.placeSearchProvider!),
    );
    if (result != null) {
      setState(() {
        addressCtrl.text = result.fullAddress ?? addressCtrl.text;
        cityCtrl.text = result.city ?? cityCtrl.text;
        stateCtrl.text = result.state ?? stateCtrl.text;
        countryCtrl.text = result.country ?? countryCtrl.text;
        postalCodeCtrl.text = result.postalCode ?? postalCodeCtrl.text;
        latitude = result.lat ?? latitude;
        longitude = result.lng ?? longitude;
      });
    }
  }

  Future<void> _pickOnMap() async {
    if (widget.onPickOnMap == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Map picker not configured.')),
      );
      return;
    }
    final result = await widget.onPickOnMap!.call();
    if (result != null) {
      setState(() {
        addressCtrl.text = result.fullAddress ?? addressCtrl.text;
        cityCtrl.text = result.city ?? cityCtrl.text;
        stateCtrl.text = result.state ?? stateCtrl.text;
        countryCtrl.text = result.country ?? countryCtrl.text;
        postalCodeCtrl.text = result.postalCode ?? postalCodeCtrl.text;
        latitude = result.lat ?? latitude;
        longitude = result.lng ?? longitude;
      });
    }
  }

  // Submit
  Future<void> _handleSubmit({required bool publish}) async {
    if (!_formKey.currentState!.validate()) {
      _scrollToFirstError();
      return;
    }
    if (_photos.isEmpty) {
      _showInlineError('At least 1 photo is required.');
      setState(() => _currentStep = 0);
      return;
    }
    final data = _collectFormData();
    setState(() => _submitting = true);
    try {
      if (publish) {
        if (widget.onSubmit != null) await widget.onSubmit!(data);
        _showInlineSuccess('Listing published.');
      } else {
        if (widget.onSaveDraft != null) await widget.onSaveDraft!(data);
        _showInlineSuccess('Draft saved.');
      }
      if (mounted) Navigator.of(context).maybePop();
    } catch (e) {
      _showInlineError('Failed: $e');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _scrollToFirstError() {
    // Minimal UX: bring to first step with validation likely failing.
    if (_currentStep != 1 &&
        (titleCtrl.text.isEmpty ||
            propertyType == null ||
            priceCtrl.text.isEmpty)) {
      setState(() => _currentStep = 1);
    } else if (_currentStep != 2 &&
        (addressCtrl.text.isEmpty || (latitude == null || longitude == null))) {
      setState(() => _currentStep = 2);
    }
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _showInlineError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showInlineSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  AgentListingFormData _collectFormData() {
    final videoUrls = _videoUrlCtrls
        .map((c) => c.text.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    return AgentListingFormData(
      title: titleCtrl.text.trim(),
      description: descCtrl.text.trim(),
      listingType: listingType,
      propertyType: propertyType!,
      price: double.tryParse(priceCtrl.text.replaceAll(',', '')) ?? 0.0,
      currency: currency,
      size: double.tryParse(sizeCtrl.text.replaceAll(',', '')) ?? 0.0,
      sizeUnit: sizeUnit,
      furnishing: furnishing,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      parking: parking,
      petsAllowed: petsAllowed,
      availableFrom: availableFrom,
      leaseTerms: leaseTermsCtrl.text.trim().isEmpty
          ? null
          : leaseTermsCtrl.text.trim(),
      amenities: selectedAmenities.toList(),
      address: addressCtrl.text.trim(),
      city: cityCtrl.text.trim(),
      state: stateCtrl.text.trim(),
      country: countryCtrl.text.trim(),
      postalCode: postalCodeCtrl.text.trim(),
      latitude: latitude,
      longitude: longitude,
      photos: List.of(_photos),
      videos: List.of(_videos),
      videoUrls: videoUrls,
      createdAt: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // ignore: unused_local_variable
    final color = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Property'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            final shouldCancel = await showDialog<bool>(
              context: context,
              builder: (context) => Dialog(
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Decorative header icon
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 10,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Title
                      Text(
                        'Discard changes?',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Body
                      Text(
                        'You have unsaved changes. If you leave now, your changes will be lost.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 18),
                      // Actions
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Keep Editing'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              //icon: const Icon(Icons.exit_to_app_outlined),
                              label: const Text(
                                'Discard & Exit',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.error,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => Navigator.of(context).pop(true),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
            if (shouldCancel == true) {
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            }
          },
        ),
        /*actions: [
          TextButton(
            onPressed: _submitting ? null : () => _handleSubmit(publish: false),
            child: const Text('Save draft'),
          ),
        ],*/
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _submitting
                    ? null
                    : () => _handleSubmit(publish: false),
                child: const Text('Save Draft'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: igBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Publish Listing',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: Stepper(
                  currentStep: _currentStep,
                  onStepCancel: _currentStep == 0
                      ? null
                      : () => setState(() => _currentStep -= 1),
                  onStepContinue: () {
                    if (_currentStep < 4) {
                      setState(() => _currentStep += 1);
                    }
                  },
                  onStepTapped: (i) => setState(() => _currentStep = i),
                  controlsBuilder: (context, details) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 4,
                            ),
                            onPressed: details.onStepContinue,
                            child: Text(
                              _currentStep == 4 ? 'Preview' : 'Next',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: const Text('Back'),
                          ),
                        ],
                      ),
                    );
                  },
                  steps: [
                    Step(
                      title: const Text('Media'),
                      isActive: _currentStep >= 0,
                      state: _photos.isNotEmpty
                          ? StepState.complete
                          : StepState.indexed,
                      content: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _SectionHeader(
                              title: 'Photos',
                              action: OutlinedButton.icon(
                                icon: const Icon(Icons.photo_library_outlined),
                                label: const Text('Add Photos'),
                                onPressed: _pickPhotos,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _MediaPhotoGrid(
                              files: _photos,
                              onRemove: (i) =>
                                  setState(() => _photos.removeAt(i)),
                              onReorder: (oldIndex, newIndex) {
                                setState(() {
                                  if (newIndex > oldIndex) newIndex -= 1;
                                  final item = _photos.removeAt(oldIndex);
                                  _photos.insert(newIndex, item);
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            _SectionHeader(
                              title: 'Videos',
                              action: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  /* OutlinedButton.icon(
                                    icon: const Icon(
                                      Icons.video_library_outlined,
                                    ),
                                    label: const Text('Add Video File'),
                                    onPressed: _pickVideo,
                                  ),*/
                                  OutlinedButton.icon(
                                    icon: const Icon(Icons.link),
                                    label: const Text('Add Video URL'),
                                    onPressed: _addVideoUrlField,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            _MediaVideoList(
                              videos: _videos,
                              onRemove: (i) =>
                                  setState(() => _videos.removeAt(i)),
                            ),
                            const SizedBox(height: 8),
                            Column(
                              children: List.generate(_videoUrlCtrls.length, (
                                i,
                              ) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _videoUrlCtrls[i],
                                          decoration: const InputDecoration(
                                            labelText:
                                                'Video URL (YouTube/Vimeo/etc.)',
                                            prefixIcon: Icon(Icons.link),
                                          ),
                                          keyboardType: TextInputType.url,
                                          validator: (v) {
                                            if (v == null || v.isEmpty) {
                                              return null;
                                            }
                                            final ok =
                                                Uri.tryParse(
                                                  v,
                                                )?.hasAbsolutePath ??
                                                false;
                                            return ok ? null : 'Invalid URL';
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () =>
                                            _removeVideoUrlField(i),
                                        icon: const Icon(Icons.close),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Step(
                      title: const Text('Details'),
                      isActive: _currentStep >= 1,
                      state:
                          (titleCtrl.text.isNotEmpty &&
                              propertyType != null &&
                              priceCtrl.text.isNotEmpty)
                          ? StepState.complete
                          : StepState.indexed,
                      content: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: titleCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Listing title',
                                hintText:
                                    'Spacious 3-bedroom apartment in Lekki',
                              ),
                              textCapitalization: TextCapitalization.sentences,
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Title is required'
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: descCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Description',
                              ),
                              maxLines: 5,
                              minLines: 3,
                              textCapitalization: TextCapitalization.sentences,
                            ),
                            const SizedBox(height: 16),
                            _SectionHeader(title: 'Listing Type'),
                            const SizedBox(height: 8),
                            _ChipsSelector(
                              options: listingTypes,
                              selected: {listingType},
                              multi: false,
                              onChanged: (s) =>
                                  setState(() => listingType = s.first),
                            ),
                            const SizedBox(height: 16),
                            _SectionHeader(title: 'Property Type'),
                            const SizedBox(height: 8),
                            _ChipsSelector(
                              options: propertyTypes,
                              selected: {
                                if (propertyType != null) propertyType!,
                              },
                              multi: false,
                              onChanged: (s) =>
                                  setState(() => propertyType = s.first),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: priceCtrl,
                                    decoration: InputDecoration(
                                      labelText: 'Price',
                                      prefixText: '$currency ',
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'Price is required';
                                      }
                                      final d = double.tryParse(
                                        v.replaceAll(',', ''),
                                      );
                                      if (d == null || d <= 0) {
                                        return 'Enter a valid price';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: currency,
                                    items: currencyList
                                        .map(
                                          (c) => DropdownMenuItem(
                                            value: c,
                                            child: Text(c),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (v) => setState(
                                      () => currency = v ?? currency,
                                    ),
                                    decoration: const InputDecoration(
                                      labelText: 'Currency',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: sizeCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Size',
                                      hintText: 'e.g., 120',
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: sizeUnit,
                                    items: sizeUnits
                                        .map(
                                          (u) => DropdownMenuItem(
                                            value: u,
                                            child: Text(u),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (v) => setState(
                                      () => sizeUnit = v ?? sizeUnit,
                                    ),
                                    decoration: const InputDecoration(
                                      labelText: 'Unit',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _CounterField(
                                    label: 'Bedrooms',
                                    value: bedrooms,
                                    onChanged: (v) =>
                                        setState(() => bedrooms = v),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _CounterField(
                                    label: 'Bathrooms',
                                    value: bathrooms,
                                    onChanged: (v) =>
                                        setState(() => bathrooms = v),
                                  ),
                                ),
                                const SizedBox(width: 12),
                              ],
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              value: furnishing,
                              items: furnishingOptions
                                  .map(
                                    (f) => DropdownMenuItem(
                                      value: f,
                                      child: Text(f),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) => setState(() => furnishing = v),
                              decoration: const InputDecoration(
                                labelText: 'Furnishing',
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: yearBuiltCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Year Built',
                                      hintText: 'e.g., 2019',
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      final now = DateTime.now();
                                      final first = DateTime(now.year - 60);
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate: availableFrom ?? now,
                                        firstDate: first,
                                        lastDate: DateTime(now.year + 2),
                                      );
                                      if (picked != null) {
                                        setState(() => availableFrom = picked);
                                      }
                                    },
                                    child: InputDecorator(
                                      decoration: const InputDecoration(
                                        labelText: 'Available From',
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                      ),
                                      child: Text(
                                        availableFrom == null
                                            ? 'Select date'
                                            : MaterialLocalizations.of(
                                                context,
                                              ).formatMediumDate(
                                                availableFrom!,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: leaseTermsCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Lease Terms (optional)',
                                hintText:
                                    'e.g., 12 months minimum, 2 months deposit',
                              ),
                              minLines: 2,
                              maxLines: 3,
                            ),
                            const SizedBox(height: 8),
                            SwitchListTile(
                              value: petsAllowed,
                              onChanged: (v) => setState(() => petsAllowed = v),
                              title: const Text('Pets Allowed'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Step(
                      title: const Text('Location'),
                      isActive: _currentStep >= 2,
                      state: (addressCtrl.text.isNotEmpty)
                          ? StepState.indexed
                          : StepState.indexed,
                      content: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    icon: const Icon(Icons.search),
                                    label: const Text('Search'),
                                    onPressed: _openLocationSearch,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    icon: const Icon(Icons.pin_drop_outlined),
                                    label: const Text('Google Map'),
                                    onPressed: _pickOnMap,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: addressCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Address',
                                prefixIcon: Icon(Icons.location_on_outlined),
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Address is required'
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: cityCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'City',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: stateCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'State/Region',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                /*   Expanded(
                                  child: TextFormField(
                                    controller: countryCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Country',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: postalCodeCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Zip Code',
                                    ),
                                  ),
                                ),*/
                              ],
                            ),
                            const SizedBox(height: 12),
                            /* Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: 'Latitude',
                                      hintText:
                                          latitude?.toStringAsFixed(6) ??
                                          'Not set',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: 'Longitude',
                                      hintText:
                                          longitude?.toStringAsFixed(6) ??
                                          'Not set',
                                    ),
                                  ),
                                ),
                              ],
                            ),*/
                            const SizedBox(height: 8),
                            Text(
                              'Tip: Use Search or Pick on Map to set coordinates.',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Step(
                      title: const Text('Amenities'),
                      isActive: _currentStep >= 3,
                      state: selectedAmenities.isNotEmpty
                          ? StepState.complete
                          : StepState.indexed,
                      content: SingleChildScrollView(
                        controller: _scrollController,
                        child: _AmenitiesWrap(
                          options: amenityOptions,
                          selected: selectedAmenities,
                          onChanged: (s) => setState(() {
                            if (selectedAmenities.contains(s)) {
                              selectedAmenities.remove(s);
                            } else {
                              selectedAmenities.add(s);
                            }
                          }),
                        ),
                      ),
                    ),
                    Step(
                      title: const Text('Review & Publish'),
                      isActive: _currentStep >= 4,
                      state: StepState.indexed,
                      content: _buildReviewSection(context),
                    ),
                  ],
                ),
              ),
            ),
            _BottomBar(
              busy: _submitting,
              onPublish: () => _handleSubmit(publish: true),
              onSaveDraft: () => _handleSubmit(publish: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewSection(BuildContext context) {
    final theme = Theme.of(context);
    final missing = <String>[];
    if (titleCtrl.text.trim().isEmpty) missing.add('Title');
    if (propertyType == null) missing.add('Property Type');
    if (priceCtrl.text.trim().isEmpty) missing.add('Price');
    if (addressCtrl.text.trim().isEmpty) missing.add('Address');
    if (_photos.isEmpty) missing.add('At least 1 Photo');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (missing.isNotEmpty) ...[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Missing information', style: theme.textTheme.titleMedium),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: missing.map((m) => Chip(label: Text(m))).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        _kv('Title', titleCtrl.text),
        _kv('Listing Type', listingType),
        _kv('Property Type', propertyType ?? '-'),
        _kv('Price', '$currency ${priceCtrl.text}'),
        _kv('Size', '${sizeCtrl.text} $sizeUnit'),
        _kv('Rooms', '🛏 $bedrooms  •  🛁 $bathrooms  •  🚗 $parking'),
        _kv('Furnishing', furnishing ?? '-'),
        _kv('Pets Allowed', petsAllowed ? 'Yes' : 'No'),
        _kv(
          'Available From',
          availableFrom == null
              ? '-'
              : MaterialLocalizations.of(
                  context,
                ).formatMediumDate(availableFrom!),
        ),
        const Divider(height: 24),
        _kv('Address', addressCtrl.text),
        _kv('City', cityCtrl.text),
        _kv('State', stateCtrl.text),
        _kv('Country', countryCtrl.text),
        _kv('Postal Code', postalCodeCtrl.text),
        _kv(
          'Coordinates',
          (latitude == null || longitude == null)
              ? '-'
              : '${latitude!.toStringAsFixed(6)}, ${longitude!.toStringAsFixed(6)}',
        ),
        const Divider(height: 24),
        _kv(
          'Amenities',
          selectedAmenities.isEmpty ? '-' : selectedAmenities.join(', '),
        ),
        const SizedBox(height: 12),
        _kv('Photos', '${_photos.length} selected'),
        _kv(
          'Videos',
          '${_videos.length} files, ${_videoUrlCtrls.where((c) => c.text.isNotEmpty).length} links',
        ),
      ],
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(k, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }

  _firstString(map) {}
}

// Bottom action bar
class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.busy,
    required this.onPublish,
    required this.onSaveDraft,
  });
  final bool busy;
  final VoidCallback onPublish;
  final VoidCallback onSaveDraft;

  @override
  Widget build(BuildContext context) {
    return Container(); /*SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: busy ? null : onSaveDraft,
                child: const Text('Save draft'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: busy ? null : onPublish,
                icon: busy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.publish_outlined),
                label: const Text('Publish Listing'),
              ),
            ),
          ],
        ),
      ),
    );*/
  }
}

// Section header with optional action
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.action});
  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleMedium;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: style),
        if (action != null) action!,
      ],
    );
  }
}

// Counter field for bedrooms/bathrooms/parking
class _CounterField extends StatelessWidget {
  const _CounterField({
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      child: Row(
        children: [
          _IconBtn(
            icon: Icons.remove,
            onTap: value > 0 ? () => onChanged(value - 1) : null,
          ),
          Expanded(
            child: Center(
              child: Text('$value', style: theme.textTheme.titleMedium),
            ),
          ),
          _IconBtn(icon: Icons.add, onTap: () => onChanged(value + 1)),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: onTap,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

// Chips selector for single/multi choice
class _ChipsSelector extends StatelessWidget {
  const _ChipsSelector({
    required this.options,
    required this.selected,
    required this.onChanged,
    this.multi = true,
  });

  final List<String> options;
  final Set<String> selected;
  final bool multi;
  final ValueChanged<Set<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: -8,
      children: options.map((o) {
        final isSel = selected.contains(o);
        return ChoiceChip(
          label: Text(o),
          selected: isSel,
          onSelected: (sel) {
            final s = Set<String>.from(selected);
            if (multi) {
              if (sel) {
                s.add(o);
              } else {
                s.remove(o);
              }
            } else {
              s
                ..clear()
                ..add(o);
            }
            onChanged(s);
          },
        );
      }).toList(),
    );
  }
}

// Amenities chip wrap
class _AmenitiesWrap extends StatelessWidget {
  const _AmenitiesWrap({
    required this.options,
    required this.selected,
    required this.onChanged,
  });
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: -8,
      children: options.map((o) {
        final sel = selected.contains(o);
        return FilterChip(
          label: Text(o),
          selected: sel,
          onSelected: (_) => onChanged(o),
        );
      }).toList(),
    );
  }
}

// Photo grid with reorder/delete
class _MediaPhotoGrid extends StatelessWidget {
  const _MediaPhotoGrid({
    required this.files,
    required this.onRemove,
    required this.onReorder,
  });

  final List<XFile> files;
  final void Function(int index) onRemove;
  final void Function(int oldIndex, int newIndex) onReorder;

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) {
      return Container(
        height: 140,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text('No photos added yet.'),
      );
    }
    return ReorderableWrap(
      spacing: 8,
      runSpacing: 8,
      onReorder: onReorder,
      children: List.generate(files.length, (i) {
        return _PhotoThumb(
          key: ValueKey(files[i].path),
          file: files[i],
          onRemove: () => onRemove(i),
          indexLabel: '#${i + 1}',
        );
      }),
    );
  }
}

// Simple reorderable wrap (no external deps)
class ReorderableWrap extends StatefulWidget {
  const ReorderableWrap({
    super.key,
    required this.children,
    required this.onReorder,
    this.spacing = 8,
    this.runSpacing = 8,
  });

  final List<Widget> children;
  final void Function(int oldIndex, int newIndex) onReorder;
  final double spacing;
  final double runSpacing;

  @override
  State<ReorderableWrap> createState() => _ReorderableWrapState();
}

class _ReorderableWrapState extends State<ReorderableWrap> {
  @override
  Widget build(BuildContext context) {
    // Basic wrap without drag-to-reorder interaction (tap reorder dialog).
    // Keeps zero external dependencies. Provides manual reorder UX.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: widget.spacing,
          runSpacing: widget.runSpacing,
          children: widget.children,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: widget.children.length < 2
                ? null
                : () async {
                    final newOrder = await showDialog<List<int>>(
                      context: context,
                      builder: (ctx) =>
                          _ReorderDialog(count: widget.children.length),
                    );
                    if (newOrder == null) return;
                    // Apply mapping
                    for (
                      int newIndex = 0;
                      newIndex < newOrder.length;
                      newIndex++
                    ) {
                      final oldIndex = newOrder[newIndex];
                      if (oldIndex != newIndex) {
                        widget.onReorder(oldIndex, newIndex);
                      }
                    }
                  },
            icon: const Icon(Icons.swap_vert),
            label: const Text('Reorder'),
          ),
        ),
      ],
    );
  }
}

class _ReorderDialog extends StatefulWidget {
  const _ReorderDialog({required this.count});
  final int count;

  @override
  State<_ReorderDialog> createState() => _ReorderDialogState();
}

class _ReorderDialogState extends State<_ReorderDialog> {
  late List<int> order;

  @override
  void initState() {
    super.initState();
    order = List<int>.generate(widget.count, (i) => i);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reorder Photos'),
      content: SizedBox(
        width: 280,
        height: 280,
        child: ReorderableListView(
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) newIndex -= 1;
              final item = order.removeAt(oldIndex);
              order.insert(newIndex, item);
            });
          },
          children: [
            for (int i = 0; i < order.length; i++)
              ListTile(
                key: ValueKey('r$i'),
                leading: const Icon(Icons.drag_handle),
                title: Text('Photo ${order[i] + 1}'),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, order),
          child: const Text('Apply'),
        ),
      ],
    );
  }
}

class _PhotoThumb extends StatelessWidget {
  const _PhotoThumb({
    super.key,
    required this.file,
    required this.onRemove,
    required this.indexLabel,
  });

  final XFile file;
  final VoidCallback onRemove;
  final String indexLabel;

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (kIsWeb) {
      image = FutureBuilder(
        future: file.readAsBytes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox(
              width: 100,
              height: 100,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }
          return Image.memory(
            snapshot.data as Uint8List,
            fit: BoxFit.cover,
            width: 120,
            height: 120,
          );
        },
      );
    } else {
      image = Image.file(
        File(file.path),
        fit: BoxFit.cover,
        width: 120,
        height: 120,
      );
    }

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(width: 120, height: 120, child: image),
        ),
        Positioned(
          right: 6,
          top: 6,
          child: InkWell(
            onTap: onRemove,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.black.withOpacity(0.6),
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
        Positioned(
          left: 6,
          bottom: 6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              indexLabel,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

// Video file list (simple)
class _MediaVideoList extends StatelessWidget {
  const _MediaVideoList({required this.videos, required this.onRemove});
  final List<XFile> videos;
  final void Function(int index) onRemove;

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: List.generate(videos.length, (i) {
        final v = videos[i];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.videocam_outlined),
            title: Text(v.name),
            subtitle: Text(
              FutureBuilder(
                    future: v.length(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return Text(
                          '${(snapshot.data! / (1024 * 1024)).toStringAsFixed(2)} MB',
                        );
                      } else {
                        return const Text('Calculating...');
                      }
                    },
                  )
                  as String,
              maxLines: 1,
            ),
            trailing: IconButton(
              onPressed: () => onRemove(i),
              icon: const Icon(Icons.delete_outline),
            ),
          ),
        );
      }),
    );
  }
}

// Data model to collect and submit
class AgentListingFormData {
  AgentListingFormData({
    required this.title,
    required this.description,
    required this.listingType,
    required this.propertyType,
    required this.price,
    required this.currency,
    required this.size,
    required this.sizeUnit,
    required this.furnishing,
    required this.bedrooms,
    required this.bathrooms,
    required this.parking,
    required this.petsAllowed,
    required this.availableFrom,
    required this.leaseTerms,
    required this.amenities,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.photos,
    required this.videos,
    required this.videoUrls,
    required this.createdAt,
  });

  final String title;
  final String description;
  final String listingType;
  final String propertyType;
  final double price;
  final String currency;
  final double size;
  final String sizeUnit;
  final String? furnishing;
  final int bedrooms;
  final int bathrooms;
  final int parking;
  final bool petsAllowed;
  final DateTime? availableFrom;
  final String? leaseTerms;
  final List<String> amenities;
  final String address;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final double? latitude;
  final double? longitude;
  final List<XFile> photos;
  final List<XFile> videos;
  final List<String> videoUrls;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'listingType': listingType,
    'propertyType': propertyType,
    'price': price,
    'currency': currency,
    'size': size,
    'sizeUnit': sizeUnit,
    'furnishing': furnishing,
    'bedrooms': bedrooms,
    'bathrooms': bathrooms,
    'parking': parking,
    'petsAllowed': petsAllowed,
    'availableFrom': availableFrom?.toIso8601String(),
    'leaseTerms': leaseTerms,
    'amenities': amenities,
    'address': address,
    'city': city,
    'state': state,
    'country': country,
    'postalCode': postalCode,
    'latitude': latitude,
    'longitude': longitude,
    'photoCount': photos.length,
    'videoCount': videos.length,
    'videoUrls': videoUrls,
    'createdAt': createdAt.toIso8601String(),
  };
}

// Simple place search provider abstraction
abstract class PlaceSearchProvider {
  Future<List<GeoAddress>> search(String query);
}

class GeoAddress {
  GeoAddress({
    this.fullAddress,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.lat,
    this.lng,
  });

  final String? fullAddress;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final double? lat;
  final double? lng;
}

// SearchDelegate for place search
class PlaceSearchDelegate extends SearchDelegate<GeoAddress?> {
  PlaceSearchDelegate({required this.provider});
  final PlaceSearchProvider provider;

  List<GeoAddress> _results = [];
  bool _loading = false;
  String _error = '';

  Future<void> _doSearch(String q) async {
    _error = '';
    _loading = true;
    _results = [];
    try {
      _results = await provider.search(q.trim());
    } catch (e) {
      _error = 'Search failed: $e';
    } finally {
      _loading = false;
    }
  }

  @override
  String get searchFieldLabel => 'Search address, area, city';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: _doSearch(query),
      builder: (context, snapshot) {
        if (_loading) return const Center(child: CircularProgressIndicator());
        if (_error.isNotEmpty) return Center(child: Text(_error));
        if (_results.isEmpty) return const Center(child: Text('No results'));
        return ListView.separated(
          itemCount: _results.length,
          separatorBuilder: (_, __) => const Divider(height: 0),
          itemBuilder: (context, i) {
            final r = _results[i];
            return ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: Text(r.fullAddress ?? _composeLine(r)),
              subtitle: Text(_composeLine(r)),
              onTap: () => close(context, r),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim().length < 3) {
      return const Center(child: Text('Type at least 3 characters to search'));
    }
    return buildResults(context);
  }

  String _composeLine(GeoAddress r) {
    final parts = [
      if (r.city?.isNotEmpty == true) r.city!,
      if (r.state?.isNotEmpty == true) r.state!,
      if (r.country?.isNotEmpty == true) r.country!,
      if (r.postalCode?.isNotEmpty == true) r.postalCode!,
    ];
    return parts.join(', ');
  }
}
