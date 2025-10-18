import 'package:flutter/material.dart';
import 'package:rentapp/theme/theme.dart';
import 'package:rentapp/view/tab_pages/agent_listing_page/agent_listings_page.dart';
import 'package:rentapp/view/tab_pages/favourites_page/enquiry_firstpage.dart';
import 'package:rentapp/view/tab_pages/saved_page/saved_firstpage.dart';
import 'package:rentapp/view/tab_pages/search_page/searh_firstpage.dart';
import 'package:rentapp/view/tab_pages/user_profile_page/profile_firstpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<Widget> _pages = [
    SearhFirstpage(),
    SavedFirstpage(),
    AgentListingsPage(),
    EnquiryFirstPage(),
    ProfileFirstpage(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutQuint,
      //curve: Curves.easeInOutQuint,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(opacity: _animation, child: _pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: igBlue, // Color for selected icon
        unselectedItemColor: igText2, // Color for unselected icons
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.travel_explore_outlined),
            label: 'Explore',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Saved'),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined),
            label: 'Listings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            label: 'Enquiries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
        ],
        selectedFontSize: 14, // Keep font size consistent
        unselectedFontSize: 14, // Keep font size consistent
        selectedIconTheme: IconThemeData(size: 24), // Keep icon size consistent
        unselectedIconTheme: IconThemeData(
          size: 24,
        ), // Keep icon size consistent
      ),
    );
  }
}
