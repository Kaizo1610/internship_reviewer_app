import 'package:flutter/material.dart';
import 'package:internship_reviewer_app/auth/splash_screen.dart';
import 'auth/loading_screen.dart';
import 'widgets/bottom_nav_bar.dart';
import 'forum/forum_page.dart';
import 'notification/notifications_page.dart';
import 'forum/add_post_page.dart';
import 'forum/edit_post_page.dart';

void main() {
  runApp(const InternovaApp());
}

class InternovaApp extends StatelessWidget {
  const InternovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Internova',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const LoadingScreen(),
      routes: {
        '/loading': (context) => const LoadingScreen(),
        '/splash': (context) => const SplashScreen(),
        '/forum': (context) => ForumPage(),
        '/notifications': (context) => NotificationsPage(),
        '/add_post': (context) => AddPostPage(),
        '/edit_post': (context) => EditPostPage(
          postId: ModalRoute.of(context)!.settings.arguments as String,
          postData: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
        ),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    LoadingScreen(),
    SplashScreen(),
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