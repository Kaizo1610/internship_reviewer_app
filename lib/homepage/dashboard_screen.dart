import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart'; 

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(), 
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40), // Space for status bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, Orlando Diggs",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text("Find your dream job today!", style: TextStyle(color: Colors.grey)),
                  ],
                ),
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('lib/assets/images/profile_picture.png'),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Promo Card
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "50% off take any courses",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Image.asset('lib/assets/images/course_tutor.png', height: 60),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text("Find Your Job", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            // Job Type Stats
            Row(
              children: [
                Expanded(
                  child: _jobStatCard("44.5k", "Remote Job", Colors.blueAccent),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _jobStatCard("66.8k", "Full Time", Colors.purpleAccent),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _jobStatCard("38.9k", "Part Time", Colors.orangeAccent),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text("Recent Job List", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            _jobCard("Product Designer", "Google Inc • California, USA", "\$15K/Month"),
          ],
        ),
      ),
    );
  }

  Widget _jobStatCard(String value, String title, Color color) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          SizedBox(height: 5),
          Text(title, style: TextStyle(fontSize: 14, color: Colors.black)),
        ],
      ),
    );
  }

  Widget _jobCard(String title, String company, String salary) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('lib/assets/images/logo_google.png'),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(company, style: TextStyle(fontSize: 14, color: Colors.grey)),
                SizedBox(height: 5),
                Text(salary, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              ],
            ),
          ),
          Icon(Icons.bookmark_border, color: Colors.grey),
        ],
      ),
    );
  }
}
