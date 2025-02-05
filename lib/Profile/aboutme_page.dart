import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AboutMePage extends StatefulWidget {
  final String initialContent;

  const AboutMePage({Key? key, required this.initialContent}) : super(key: key);

  @override
  _AboutMePageState createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  late TextEditingController _aboutMeController;
  late String _originalContent;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _originalContent = widget.initialContent;
    _aboutMeController = TextEditingController(text: _originalContent);
    _aboutMeController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    setState(() {
      _hasChanges = _aboutMeController.text != _originalContent;
    });
  }

  void _undoChanges() {
    setState(() {
      _aboutMeController.text = _originalContent;
      _hasChanges = false;
    });
  }

  void _showUndoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Undo Changes?'),
          content: const Text('Are you sure you want to revert to the original content?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                _undoChanges();
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('UNDO CHANGES'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    if (_hasChanges) {
      final shouldSave = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Save Changes?'),
            content: const Text('You have unsaved changes. Do you want to save them before exiting?'),
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
        Navigator.pop(context, _aboutMeController.text); // Save changes and exit
        return false;
      } else if (shouldSave == false) {
        Navigator.pop(context, _originalContent); // Discard changes and exit
        return false;
      }
      return true; // Stay on the page
    }
    return true; // No changes, allow exit
  }

  void _saveChanges() async {
    String aboutMeContent = _aboutMeController.text;
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'aboutMe': aboutMeContent,
      });
    }
    Navigator.pop(context, aboutMeContent);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('About Me'),
          actions: [
            IconButton(
              icon: const Icon(Icons.undo),
              onPressed: () {
                if (_hasChanges) {
                  _showUndoDialog(context);
                }
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _aboutMeController,
                maxLines: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'About Me',
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity, // Make the button full width
                height: 50, // Increase the height of the button
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // Button color
                    foregroundColor: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners
                    ),
                    elevation: 5, // Add a slight shadow
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 18), // Larger text
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}