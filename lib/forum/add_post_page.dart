import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internship_reviewer_app/homepage/dashboard_screen.dart';
import 'package:internship_reviewer_app/forum/forum_page.dart';
import 'package:internship_reviewer_app/save_job/bookmarks.dart';

class AddPostPage extends StatefulWidget {
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _role = '';
  String _department = '';
  String _selectedCompany = '';

  final List<String> companies = [
    "Petronas",
    "Bank Negara Malaysia (BNM)",
    "Tenaga Nasional Berhad (TNB)",
    "Telekom Malaysia (TM)",
    "Malaysia Airlines (MAG)",
    "Proton",
    "AirAsia",
    "KPJ Healthcare Berhad",
  ];

  Future<void> _submitPost() async {
    if (_formKey.currentState!.validate() && _selectedCompany.isNotEmpty) {
      _formKey.currentState!.save();

      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User not logged in.")));
        return;
      }

      String authorName = user.displayName ?? "Anonymous";
      String profilePicUrl = user.photoURL ?? "";

      await FirebaseFirestore.instance.collection('posts').add({
        'title': _title,
        'description': _description,
        'company': _selectedCompany,
        'role': _role,
        'department': _department,
        'author': authorName,
        'profilePic': profilePicUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post Added Successfully!')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Add Post', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser?.photoURL ?? ''),
                  backgroundColor: Colors.grey[300],
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      FirebaseAuth.instance.currentUser?.displayName ?? 'Anonymous',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),

SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Post Title', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Write the title of your post here',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter a title' : null,
                    onSaved: (value) => _title = value!,
                  ),
                  SizedBox(height: 16),
                  Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  TextFormField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'What do you want to talk about?',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter a description' : null,
                    onSaved: (value) => _description = value!,
                  ),
                  SizedBox(height: 16),
                  Text('Select Company', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    items: companies.map((company) {
                      return DropdownMenuItem(value: company, child: Text(company));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCompany = value as String;
                      });
                    },
                    validator: (value) => value == null ? 'Select a company' : null,
                  ),
                  SizedBox(height: 16),
                  Text('Role', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Enter your role',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter your role' : null,
                    onSaved: (value) => _role = value!,
                  ),
                  SizedBox(height: 16),
                  Text('Department', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Enter your department',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter your department' : null,
                    onSaved: (value) => _department = value!,
                  ),
                  SizedBox(height: 24),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: _submitPost,
                      child: Text('Post', style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 2:
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
}