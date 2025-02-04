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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Post Title'),
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
              ),
              SizedBox(height: 16),
              
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: 'Select Company'),
                value: _selectedCompany,
                items: companies.map((company) {
                  return DropdownMenuItem(value: company, child: Text(company));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCompany = value as String?;
                  });
                },
                validator: (value) => value == null ? 'Select a company' : null,
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 4,
                validator: (value) => value!.isEmpty ? 'Enter a description' : null,
              ),
              SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _updatePost,
                    child: Text('Update'),
                  ),
                  ElevatedButton(
                    onPressed: _deletePost,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}