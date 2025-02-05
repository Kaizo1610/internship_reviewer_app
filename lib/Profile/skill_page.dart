import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SkillPage extends StatefulWidget {
  final List<String>? initialSkills;
  const SkillPage({Key? key, this.initialSkills}) : super(key: key);

  @override
  _SkillPageState createState() => _SkillPageState();
}

class _SkillPageState extends State<SkillPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _selectedSkills = [];
  final List<String> _allSkills = [
    'Leadership',
    'Teamwork',
    'Visionary',
    'Target oriented',
    'Consistent',
    'Good communication skills',
    'English',
    'Responsibility',
    'Graphic Design',
    'UX/UI Design',
    'Adobe InDesign',
    'Web Design',
    'InDesign',
    'Canva Design',
    'User Interface Design',
    'Product Design',
    'User Experience Design'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialSkills != null) {
      _selectedSkills.addAll(widget.initialSkills!);
    }
  }

  void _addSkill(String skill) {
    setState(() {
      _selectedSkills.add(skill);
    });
  }

  void _removeSkill(String skill) {
    setState(() {
      _selectedSkills.remove(skill);
    });
  }

  void _saveChanges() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'skills': _selectedSkills,
      });
    }
    Navigator.pop(context, _selectedSkills);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skill (${_selectedSkills.length})'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, _selectedSkills);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search skills',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                // Implement search functionality here
              },
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              children: _selectedSkills.map((skill) {
                return Chip(
                  label: Text(skill),
                  deleteIcon: Icon(Icons.close),
                  onDeleted: () {
                    _removeSkill(skill);
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 16), 
            Wrap(
              spacing: 8.0,
              children: _allSkills.where((skill) => !_selectedSkills.contains(skill)).map((skill) {
                return OutlinedButton(
                  onPressed: () {
                    _addSkill(skill);
                  },
                  child: Text(skill),
                );
              }).toList(),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _selectedSkills.isEmpty ? null : _saveChanges,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(_selectedSkills.isEmpty ? 'No Skills Selected' : 'SAVE'),
            ),
          ],
        ),
      ),
    );
  }
}