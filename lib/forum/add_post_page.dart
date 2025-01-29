import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddPostPage extends StatefulWidget {
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _selectedCompany = '';
  File? _image;
  bool _isUploading = false;

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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child('post_images/$fileName.jpg');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<void> _submitPost() async {
    if (_formKey.currentState!.validate() && _selectedCompany.isNotEmpty) {
      setState(() {
        _isUploading = true;
      });

      _formKey.currentState!.save();
      
      User? user = FirebaseAuth.instance.currentUser;
      String authorName = user?.displayName ?? "Anonymous";
      String profilePicUrl = user?.photoURL ?? "";

      String? imageUrl = _image != null ? await _uploadImage(_image!) : null;

      await FirebaseFirestore.instance.collection('posts').add({
        'title': _title,
        'description': _description,
        'company': _selectedCompany,
        'imageUrl': imageUrl,
        'author': authorName,
        'profilePic': profilePicUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post Added Successfully!')),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields and select a company!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Post')),
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

              // Description Input
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 4,
                validator: (value) => value!.isEmpty ? 'Enter a description' : null,
                onSaved: (value) => _description = value!,
              ),
              SizedBox(height: 16),

              // Image Picker
              _image != null
                  ? Image.file(_image!, height: 150)
                  : TextButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.image),
                      label: Text("Upload Image"),
                    ),
              SizedBox(height: 16),

              // Submit Button
              _isUploading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitPost,
                      child: Text('Post'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
