// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:rentapp/components/demo_lists.dart';
import 'package:rentapp/components/property_card_grid.dart';
import 'package:rentapp/components/property_card_listview.dart';
import 'package:rentapp/components/shadow_card.dart';
import 'package:rentapp/components/socials_button.dart';
import 'package:rentapp/theme/theme.dart';
import 'package:rentapp/view/tab_pages/search_page/buy/buy_firstpage.dart';
import 'package:rentapp/view/tab_pages/search_page/filterpage/filterpage.dart';
import 'package:rentapp/view/tab_pages/search_page/search_page_widget_component/property_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearhFirstpage extends StatefulWidget {
  const SearhFirstpage({super.key});

  @override
  State<SearhFirstpage> createState() => _SearhFirstpageState();
}

class _SearhFirstpageState extends State<SearhFirstpage> {
  final Set<int> _favorites = {};
  String _selectedPropertyType = 'Hot Properties';

  @override
  void initState() {
    super.initState();
    _loadSavedPropertyType();
  }

  // Load saved property type from local storage
  Future<void> _loadSavedPropertyType() async {
    final prefs = await SharedPreferences.getInstance();
    final savedType = prefs.getString('selected_property_type');
    if (savedType != null) {
      setState(() {
        _selectedPropertyType = savedType;
      });
    }
  }

  // Save property type to local storage
  Future<void> _savePropertyType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_property_type', type);
  }

  void _showPropertyTypeFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    const Text(
                      'Select Property Type',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Filter options
              _buildFilterOption('Hot Properties', Icons.whatshot, Colors.red),
              _buildFilterOption(
                'Recently Sold',
                Icons.check_circle,
                Colors.green,
              ),
              _buildFilterOption('New Listings', Icons.fiber_new, Colors.blue),
              _buildFilterOption('Featured', Icons.star, Colors.amber),
              _buildFilterOption('Trending', Icons.trending_up, Colors.orange),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String title, IconData icon, Color iconColor) {
    final isSelected = _selectedPropertyType == title;
    return InkWell(
      onTap: () async {
        setState(() {
          _selectedPropertyType = title;
        });
        await _savePropertyType(title);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? igBlue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? igBlue : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? igBlue : Colors.black87,
                ),
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: igBlue, size: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey.shade50],
            ),
          ),
        ),
        leading: null,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.1),
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: 68,
        titleSpacing: 16,
        title: Row(
          children: [
            Icon(
              _selectedPropertyType == 'Hot Properties'
                  ? Icons.whatshot
                  : _selectedPropertyType == 'Recently Sold'
                  ? Icons.check_circle
                  : _selectedPropertyType == 'New Listings'
                  ? Icons.fiber_new
                  : Icons.star,
              color: _selectedPropertyType == 'Hot Properties'
                  ? Colors.red
                  : igBlue,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              _selectedPropertyType,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: igBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.filter_list, size: 22),
            ),
            onPressed: _showPropertyTypeFilter,
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: igBlue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: igBlue,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Get.to(() => const FiltersPage());
                      },
                      child: const Text(
                        'Rent',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: igBlue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: igBlue,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Get.to(() => const FiltersPage());
                      },
                      child: const Text(
                        'Buy',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: list_view_properties.length,
              itemBuilder: (context, index) {
                final property = list_view_properties[index];
                final isFavorite = _favorites.contains(property.id);

                return PropertyListViewCard(
                  property: property.toMap(),
                  isFavorite: isFavorite,
                  onFavoriteToggle: () {
                    setState(() {
                      if (isFavorite) {
                        _favorites.remove(property.id);
                      } else {
                        _favorites.add(property.id);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
