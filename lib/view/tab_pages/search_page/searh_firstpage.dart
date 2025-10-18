// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:rentapp/components/demo_lists.dart';
import 'package:rentapp/components/property_card_grid.dart';
import 'package:rentapp/components/shadow_card.dart';
import 'package:rentapp/components/socials_button.dart';
import 'package:rentapp/theme/theme.dart';
import 'package:rentapp/view/tab_pages/search_page/buy/buy_firstpage.dart';
import 'package:rentapp/view/tab_pages/search_page/filterpage/filterpage.dart';
import 'package:rentapp/view/tab_pages/search_page/search_page_widget_component/property_card.dart';

class SearhFirstpage extends StatefulWidget {
  const SearhFirstpage({super.key});

  @override
  State<SearhFirstpage> createState() => _SearhFirstpageState();
}

class _SearhFirstpageState extends State<SearhFirstpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        elevation: 0.5,
        centerTitle: false,
        systemOverlayStyle:
            SystemUiOverlayStyle.dark, // dark status icons on light bg
        toolbarHeight: 64,
        titleSpacing: 16,
        title: const Text(
          'Search & Discover',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24), // Curved bottom edge
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(88),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: igBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Get.to(() => FiltersPage());
                    },
                    child: const Text(
                      'Rent',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
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
                    onPressed: () {
                      Get.to(() => FiltersPage());
                    },
                    child: const Text(
                      'Buy',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 8),
              child: Row(
                children: [
                  Text(
                    'Hot Properties Around You',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.local_fire_department,
                    color: Colors.red,
                    size: 24,
                  ),
                ],
              ),
            ),
            Expanded(
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
            ),
          ],
        ),
      ),
    );
  }
}
