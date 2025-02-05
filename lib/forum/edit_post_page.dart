import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPostPage extends StatefulWidget {
  final String postId;
  final Map<String, dynamic> postData;

  EditPostPage({required this.postId, required this.postData});

  @override
  _EditPostPageState createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String? _selectedCompany;

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

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.postData['title']);
    _descriptionController = TextEditingController(text: widget.postData['description']);
    _selectedCompany = widget.postData['company'];
  }

  void _updatePost() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'company': _selectedCompany,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post Updated Successfully!')),
      );

      Navigator.pop(context);
    }
  }

  void _deletePost() async {
    final confirmation = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Post'),
        content: Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmation == true) {
      await FirebaseFirestore.instance.collection('posts').doc(widget.postId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post Deleted Successfully!')),
      );

      Navigator.pop(context); // Return to the previous screen
    }
  }


@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: _deletePost,
          ),
        ],
      ),
      body: SingleChildScrollView( // Added for scrollability
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch form fields
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Job Position*', // Changed to Job Position
                  border: OutlineInputBorder(), // Added border
                ),
                validator: (value) => value!.isEmpty ? 'Enter a job position' : null, // Updated validation message
              ),
              SizedBox(height: 16),

              DropdownButtonFormField<String>( // Explicitly typed DropdownButtonFormField
                decoration: InputDecoration(
                  labelText: 'Company*', // Changed to Company
                  border: OutlineInputBorder(), // Added border
                ),
                value: _selectedCompany,
                items: companies.map((company) {
                  return DropdownMenuItem<String>( // Explicitly typed DropdownMenuItem
                    value: company,
                    child: Text(company),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCompany = value;
                  });
                },
                validator: (value) => value == null ? 'Select a company' : null,
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description*', // Changed to Description
                  border: OutlineInputBorder(), // Added border
                ),
                maxLines: 4,
                validator: (value) => value!.isEmpty ? 'Enter a description' : null,
              ),
              SizedBox(height: 24), // Increased spacing

              ElevatedButton(
                onPressed: _updatePost,
                style: ElevatedButton.styleFrom( // Improved button styling
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('Update', style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: 16), // Added spacing

              ElevatedButton(
                onPressed: _deletePost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Red color
                  padding: EdgeInsets.symmetric(vertical: 16), // Improved button styling
                ),
                child: Text('Delete', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}