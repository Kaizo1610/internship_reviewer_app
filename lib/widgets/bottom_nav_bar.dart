import 'package:flutter/material.dart';
import '../homepage/dashboard_screen.dart';
import '../forum/display_forum.dart';
import '../posting/add_posting.dart';
import '../qr_scanner/scan_company.dart';
import '../save_job/bookmarks.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
      ),
    );
  }
}
