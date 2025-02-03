import 'package:flutter/material.dart';
import 'package:internship_reviewer_app/homepage/dashboard_screen.dart';
import 'package:internship_reviewer_app/forum/forum_page.dart';
import 'package:internship_reviewer_app/forum/add_post_page.dart';
import 'package:internship_reviewer_app/save_job/bookmarks.dart';

class ScanCompany extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Company'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text('Which Company do you want to scan?'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.white), label: "Home", backgroundColor: Colors.deepPurple),
          BottomNavigationBarItem(icon: Icon(Icons.forum, color: Colors.white), label: "Forum", backgroundColor: Colors.deepPurple),
          BottomNavigationBarItem(icon: Icon(Icons.add, color: Colors.white), label: "Add Post", backgroundColor: Colors.deepPurple),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code, color: Colors.white), label: "Scan Company", backgroundColor: Colors.deepPurple),
          BottomNavigationBarItem(icon: Icon(Icons.bookmarks, color: Colors.white), label: "Bookmarks", backgroundColor: Colors.deepPurple),
        ],
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ForumPage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPostPage()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScanCompany()),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Bookmarks()),
              );
              break;
          }
        },
      ),
    );
  }
}