import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppreciationPage extends StatefulWidget {
  final List<Map<String, dynamic>>? initialAppreciations;
  const AppreciationPage({Key? key, this.initialAppreciations}) : super(key: key);

  @override
  _AppreciationPageState createState() => _AppreciationPageState();
}

class _AppreciationPageState extends State<AppreciationPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _awardNameController;
  late TextEditingController _categoryController;
  late TextEditingController _yearController;
  late TextEditingController _descriptionController;
  bool _hasChanges = false;

  // Track original data for undo functionality
  late List<Map<String, dynamic>> _appreciations;

  @override
  void initState() {
    super.initState();
    _awardNameController = TextEditingController();
    _categoryController = TextEditingController();
    _yearController = TextEditingController();
    _descriptionController = TextEditingController();

    _appreciations = widget.initialAppreciations?.toList() ?? [];
  }

  void _onFieldChanged() {
    setState(() {
      _hasChanges = true;
    });
  }

  Future<bool> _onWillPop() async {
    if (_hasChanges) {
      final shouldSave = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Unsaved Changes'),
            content: const Text('Do you want to save your changes before exiting?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false); // Discard changes
                },
                child: const Text('DISCARD'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true); // Save changes
                },
                child: const Text('SAVE'),
              ),
            ],
          );
        },
      );
      if (shouldSave == true) {
        _saveChanges();
        return false; // Prevent the back button from closing the page
      } else if (shouldSave == false) {
        Navigator.pop(context, _appreciations); // Discard changes and exit
        return false; // Prevent the back button from closing the page
      }
      return true; // Stay on the page
    }
    return true; // No changes, allow exit
  }

  void _addAppreciation() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _appreciations.add({
          'awardName': _awardNameController.text,
          'category': _categoryController.text,
          'year': _yearController.text,
          'description': _descriptionController.text,
        });
        _awardNameController.clear();
        _categoryController.clear();
        _yearController.clear();
        _descriptionController.clear();
        _hasChanges = true;
      });
    }
  }

  void _saveChanges() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'appreciations': _appreciations,
      });
    }
    Navigator.pop(context, _appreciations);
  }

  void _undoChanges() {
    setState(() {
      _awardNameController.clear();
      _categoryController.clear();
      _yearController.clear();
      _descriptionController.clear();
      _hasChanges = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Appreciation'),
          actions: [
            IconButton(
              icon: const Icon(Icons.undo),
              onPressed: _undoChanges,
              tooltip: 'Undo Changes',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: _appreciations.isEmpty
                    ? const Center(
                        child: Text(
                          'No appreciations added yet.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _appreciations.length,
                        itemBuilder: (context, index) {
                          final appreciation = _appreciations[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                appreciation['awardName'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Category: ${appreciation['category']}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'Year: ${appreciation['year']}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  if (appreciation['description'] != null &&
                                      appreciation['description'].isNotEmpty)
                                    Text(
                                      'Description: ${appreciation['description']}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _appreciations.removeAt(index);
                                    _hasChanges = true;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _awardNameController,
                      decoration: const InputDecoration(
                        labelText: 'Award Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an award name';
                        }
                        return null;
                      },
                      onChanged: (value) => _onFieldChanged(),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Category/Achievement',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a category';
                        }
                        return null;
                      },
                      onChanged: (value) => _onFieldChanged(),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _yearController,
                      decoration: const InputDecoration(
                        labelText: 'Year',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a year';
                        }
                        return null;
                      },
                      onChanged: (value) => _onFieldChanged(),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onChanged: (value) => _onFieldChanged(),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addAppreciation,
                      child: const Text('ADD APPRECIATION'), 
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}