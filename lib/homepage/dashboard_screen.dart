import 'package:flutter/material.dart';
import 'package:internship_reviewer_app/forum/display_forum.dart';
import 'package:internship_reviewer_app/posting/add_posting.dart';
import 'package:internship_reviewer_app/qr_scanner/scan_company.dart';
import 'package:internship_reviewer_app/save_job/bookmarks.dart';
import 'job_details_screen.dart'; 
import 'profile_screen.dart';
import 'job_search_screen.dart'; 

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<int> bookmarkedIndices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          "Hello Aiman Akim,",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
            child: CircleAvatar(
              backgroundImage: AssetImage('lib/assets/images/profile_picture.png'),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Scan Your Dream Company Logo Now!!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ScanCompany()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        child: Text("Scan Now"), 
                      ),
                    ],
                  ),
                  Image.asset(
                    'lib/assets/images/course_tutor.png', 
                    width: 100,
                  ),
                ],
              ),
            ),

            SizedBox(height: 25),
            const Text(
              "Find Your Job",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, 
              children: [
                _jobCategoryCard("Physical Job", "5", Colors.lightBlue, Icons.work_outline, "Physical"),
                _jobCategoryCard("Remote Job", "3", Colors.purpleAccent, Icons.laptop, "Remote"),
                _jobCategoryCard("Hybrid Job", "2", Colors.orangeAccent, Icons.phone, "Hybrid"),
              ],
            ),

            SizedBox(height: 20),
            const Text(
              "Recent Job List",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),
            _jobCard(
              index: 0,
              title: "Data Analyst Intern",
              company: "Shell",
              location: "Kuala Lumpur, Malaysia",
              salary: "\$11K/Mo",
              tags: ["Data Analyst Intern", "Physical"],
              logo: "lib/assets/images/logo_shell.png",
            ),
            SizedBox(height: 10),
            _jobCard(
              index: 1,
              title: "3D Designer intern",
              company: "Petronas",
              location: "Kuala Lumpur, Malaysia",
              salary: "\$12K/Mo",
              tags: ["3D Designer intern", "Remote"],
              logo: "lib/assets/images/logo_petronas.png",
            ),
            SizedBox(height: 10),
            _jobCard(
              index: 2,
              title: "Data Scientist intern",
              company: "SLB",
              location: "Petaling Jaya, Malaysia",
              salary: "\$16K/Mo",
              tags: ["Data Scientist intern", "Hybrid"],
              logo: "lib/assets/images/logo_slb.png",
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.white), label: "Home", backgroundColor: Colors.deepPurple),
          BottomNavigationBarItem(icon: Icon(Icons.forum, color: Colors.white), label: "Forum", backgroundColor: Colors.deepPurple),
          BottomNavigationBarItem(icon: Icon(Icons.add, color: Colors.white), label: "Add Post", backgroundColor: Colors.deepPurple),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code, color: Colors.white), label: "Scan Company", backgroundColor: Colors.deepPurple),
          BottomNavigationBarItem(icon: Icon(Icons.bookmarks, color: Colors.white), label: "Bookmarks", backgroundColor: Colors.deepPurple),
        ],
        currentIndex: 0,
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
                MaterialPageRoute(builder: (context) => DisplayForum()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPosting()),
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

  Widget _jobCategoryCard(String title, String count, Color color, IconData icon, String category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobSearchScreen(category: category),
          ),
        );
      },
      child: Container(
        width: 130,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            SizedBox(height: 8),
            Text(
              count,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _jobCard({required int index, required String title, required String company, required String location, required String salary, required List<String> tags, required String logo}) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(logo, width: 40),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("$company • $location", style: TextStyle(color: Colors.grey)),
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (bookmarkedIndices.contains(index)) {
                      bookmarkedIndices.remove(index);
                    } else {
                      bookmarkedIndices.add(index);
                    }
                  });
                },
                child: Icon(
                  bookmarkedIndices.contains(index) ? Icons.bookmark : Icons.bookmark_border,
                  color: bookmarkedIndices.contains(index) ? Colors.deepPurple : Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(salary, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Row(
            children: [
              ...tags.map((tag) => Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Chip(label: Text(tag)),
                  )),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobDetailScreen(
                        title: title,
                        company: company,
                        location: location,
                        salary: salary,
                        tags: tags,
                      ),
                    ),
                  );
                },
                child: Text("Apply"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
