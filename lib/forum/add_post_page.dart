import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forum_page.dart';
import 'package:internship_reviewer_app/qr_scanner/scan_company.dart';
import 'package:internship_reviewer_app/homepage/dashboard_screen.dart';
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
      appBar: AppBar(title: Text('Add Your Post Now!!'), 
      automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title Input
              TextFormField(
                decoration: InputDecoration(labelText: 'Post Title'),
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
                onSaved: (value) => _title = value!,
              ),
              SizedBox(height: 16),

              // Company Selection Dropdown
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: 'Select Company'),
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

              // Role Input
              TextFormField(
                decoration: InputDecoration(labelText: 'Role'),
                validator: (value) => value!.isEmpty ? 'Enter your role' : null,
                onSaved: (value) => _role = value!,
              ),
              SizedBox(height: 16),

              // Department Input (User can manually enter)
              TextFormField(
                decoration: InputDecoration(labelText: 'Department'),
                validator: (value) => value!.isEmpty ? 'Enter your department' : null,
                onSaved: (value) => _department = value!,
              ),
              SizedBox(height: 16),

              // Description Input
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 4,
                validator: (value) => value!.isEmpty ? 'Enter a description' : null,
                onSaved: (value) => _description = value!,
              ),
              SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: _submitPost,
                child: Text('Post'),
              ),
            ],
          ),
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
        currentIndex: 2,
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