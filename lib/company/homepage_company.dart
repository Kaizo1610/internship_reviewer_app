import 'package:flutter/material.dart';
import 'company_add_job.dart'; 
import 'package:internship_reviewer_app/Profile/setting_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomepageCompany extends StatefulWidget {
  @override
  _HomepageCompanyState createState() => _HomepageCompanyState();
}

class _HomepageCompanyState extends State<HomepageCompany> {
  List<int> bookmarkedIndices = [];
  String username = '';

  @override
  void initState() {
    super.initState();
    _fetchUsername();
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

  Widget _buildJobCard(DocumentSnapshot document, int index) {
    return _jobCard(
      index: index,
      title: document['title'],
      company: document['company'],
      location: document['location'],
      salary: document['salary'],
      tags: [document['title'], document['jobMode']],
    );
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
          "Welcome Back $username,",
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
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
            child: Icon(
              Icons.settings,
              color: Colors.black,
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
                        "Add on more internship potential jobs now!!",
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
                            MaterialPageRoute(builder: (context) => CompanyAddJob()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        child: Text("Add Job"), 
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

            SizedBox(height: 20),
            const Text(
              "Recent Add Job List",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),
            Container(
              height: 400, // Set a fixed height for the StreamBuilder
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('jobs')
                    .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          SizedBox(height: 10),
                          _buildJobCard(snapshot.data!.docs[index], index),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Job',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomepageCompany()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CompanyAddJob()),
              );
              break;
          }
        },
      ),
    );
  }

  Widget _jobCard({required int index, required String title, required String company, required String location, required String salary, required List<String> tags}) {
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
                'lib/assets/images/logo_${company.toLowerCase().replaceAll(' ', '_')}.png',
                width: 80,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("$company • $location", style: TextStyle(color: Colors.grey)),
                ],
              ),
              Spacer(),
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
            ],
          ),
        ],
      ),
    );
  }
}