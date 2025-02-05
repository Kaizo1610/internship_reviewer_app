import 'package:flutter/material.dart';
import 'package:internship_reviewer_app/forum/forum_page.dart';
import 'package:internship_reviewer_app/forum/add_post_page.dart';
import 'package:internship_reviewer_app/save_job/bookmarks.dart';
import 'job_details_screen.dart'; 
import 'package:internship_reviewer_app/Profile/profile_page.dart';
import 'job_search_screen.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<int> bookmarkedIndices = [];
  String username = '';
  int physicalJobCount = 0;
  int remoteJobCount = 0;
  int hybridJobCount = 0;
  List<Map<String, dynamic>> jobs = [];

  @override
  void initState() {
    super.initState();
    _fetchUsername();
    _fetchJobs();
  }

  Future<void> _fetchUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        username = userDoc['name'];
      });
    }
  }

  Future<void> _fetchJobs() async {
    QuerySnapshot jobSnapshot = await FirebaseFirestore.instance.collection('jobs').get();
    List<Map<String, dynamic>> fetchedJobs = jobSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    setState(() {
      jobs = fetchedJobs;
      _countJobCategories();
    });
  }

  void _countJobCategories() {
    setState(() {
      physicalJobCount = jobs.where((job) => job['jobMode'] == 'Physical').length;
      remoteJobCount = jobs.where((job) => job['jobMode'] == 'Remote').length;
      hybridJobCount = jobs.where((job) => job['jobMode'] == 'Hybrid').length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          "Hello $username,",
          style: const TextStyle(
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
                MaterialPageRoute(builder: (context) => ProfilePage()),
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
                        "Share your internship experience with us!!",
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
                            MaterialPageRoute(builder: (context) => AddPostPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        child: const Text("Add Post Now"), 
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
                _jobCategoryCard("Physical Job", physicalJobCount.toString(), Colors.lightBlue, Icons.work_outline, "Physical"),
                _jobCategoryCard("Remote Job", remoteJobCount.toString(), Colors.purpleAccent, Icons.laptop, "Remote"),
                _jobCategoryCard("Hybrid Job", hybridJobCount.toString(), Colors.orangeAccent, Icons.phone, "Hybrid"),
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
            ...jobs.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> job = entry.value;
              return Column(
                children: [
                  _jobCard(
                    index: index,
                    title: job['title'],
                    company: job['company'],
                    location: job['location'],
                    salary: job['salary'],
                    tags: [job['jobMode']],
                    companyLogo: 'lib/assets/images/logo_${job['company'].toLowerCase().replaceAll(' ', '_')}.png',
                  ),
                  SizedBox(height: 10),
                ],
              );
            }).toList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.white), label: "Home", backgroundColor: Colors.deepPurple),
          BottomNavigationBarItem(icon: Icon(Icons.forum, color: Colors.white), label: "Forum", backgroundColor: Colors.deepPurple),
          BottomNavigationBarItem(icon: Icon(Icons.add, color: Colors.white), label: "Add Post", backgroundColor: Colors.deepPurple),
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

  Widget _jobCard({required int index, required String title, required String company, required String location, required String salary, required List<String> tags, required String companyLogo}) {
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
              Image.asset(
                companyLogo,
                width: 40,
              ), // Replaced Icon with Image.asset
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