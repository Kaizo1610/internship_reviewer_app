//akim

import 'package:flutter/material.dart';
import '../homepage/dashboard_screen.dart';
import '../forum/display_forum.dart';
import '../posting/add_posting.dart';
import '../qr_scanner/scan_company.dart';
import '../save_job/bookmarks.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset("lib/assets/images/home_icon.png", width: 24, height: 24),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Image.asset("lib/assets/images/forum_icon.png", width: 24, height: 24),
          label: "Forum",
        ),
        BottomNavigationBarItem(
          icon: Image.asset("lib/assets/images/add_icon.png", width: 24, height: 24),
          label: "Add Posting",
        ),
        BottomNavigationBarItem(
          icon: Image.asset("lib/assets/images/qr_scanner_icon.png", width: 24, height: 24),
          label: "Scan Company",
        ),
        BottomNavigationBarItem(
          icon: Image.asset("lib/assets/images/bookmark_icon.png", width: 24, height: 24),
          label: "Save Company",
        ),
      ],
    );
  }
}

class BottomNavBarContainer extends StatefulWidget {
  const BottomNavBarContainer({super.key});

  @override
  _BottomNavBarContainerState createState() => _BottomNavBarContainerState();
}

class _BottomNavBarContainerState extends State<BottomNavBarContainer> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardScreen(),
    DisplayForum(),
    AddPosting(),
    ScanCompany(),
    Bookmarks(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
