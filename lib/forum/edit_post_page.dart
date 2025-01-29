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

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.postData['title']);
    _descriptionController = TextEditingController(text: widget.postData['description']);
  }

  void _updatePost() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
        'title': _titleController.text,
        'description': _descriptionController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post Updated Successfully!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Post')),
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
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 4,
                validator: (value) => value!.isEmpty ? 'Enter a description' : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updatePost,
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
