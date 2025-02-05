import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkExperiencePage extends StatefulWidget {
  final Map<String, dynamic>? workExperience;

  const WorkExperiencePage({Key? key, this.workExperience}) : super(key: key);

  @override
  _WorkExperiencePageState createState() => _WorkExperiencePageState();
}

class _WorkExperiencePageState extends State<WorkExperiencePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _jobTitleController;
  late TextEditingController _companyController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _descriptionController;
  bool _isCurrentPosition = false;
  String _duration = '';

  // Track original data for undo functionality
  late Map<String, dynamic> _originalData;

  @override
  void initState() {
    super.initState();
    _jobTitleController = TextEditingController(text: widget.workExperience?['jobTitle'] ?? '');
    _companyController = TextEditingController(text: widget.workExperience?['company'] ?? '');
    _startDateController = TextEditingController(text: widget.workExperience?['startDate'] ?? '');
    _endDateController = TextEditingController(text: widget.workExperience?['endDate'] ?? '');
    _descriptionController = TextEditingController(text: widget.workExperience?['description'] ?? '');
    _isCurrentPosition = widget.workExperience?['isCurrentPosition'] ?? false;

    // Save original data for undo functionality
    _originalData = {
      'jobTitle': _jobTitleController.text,
      'company': _companyController.text,
      'startDate': _startDateController.text,
      'endDate': _endDateController.text,
      'description': _descriptionController.text,
      'isCurrentPosition': _isCurrentPosition,
    };

    _calculateDuration();
  }

  void _calculateDuration() {
    if (_startDateController.text.isNotEmpty && _endDateController.text.isNotEmpty) {
      final startDate = DateFormat('dd MMM yyyy').parse(_startDateController.text);
      final endDate = DateFormat('dd MMM yyyy').parse(_endDateController.text);
      final duration = _calculateDateDifference(startDate, endDate);
      setState(() {
        _duration = duration;
      });
    } else {
      setState(() {
        _duration = '';
      });
    }
  }

  String _calculateDateDifference(DateTime startDate, DateTime endDate) {
    int years = endDate.year - startDate.year;
    int months = endDate.month - startDate.month;

    // Adjust for cases where the end month is earlier than the start month
    if (months < 0) {
      years--;
      months += 12;
    }

    // If the end day is earlier than the start day, subtract one month
    if (endDate.day < startDate.day) {
      months--;
      if (months < 0) {
        years--;
        months += 12;
      }
    }

    // Return the duration in years and months
    if (years == 0) {
      return '$months Months';
    } else if (months == 0) {
      return '$years Years';
    } else {
      return '$years Years $months Months';
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final formattedDate = DateFormat('dd MMM yyyy').format(picked);
      controller.text = formattedDate;
      _calculateDuration();
    }
  }

  void _undoChanges() {
    setState(() {
      _jobTitleController.text = _originalData['jobTitle'];
      _companyController.text = _originalData['company'];
      _startDateController.text = _originalData['startDate'];
      _endDateController.text = _originalData['endDate'];
      _descriptionController.text = _originalData['description'];
      _isCurrentPosition = _originalData['isCurrentPosition'];
      _calculateDuration();
    });
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final workExperience = {
        'jobTitle': _jobTitleController.text,
        'company': _companyController.text,
        'startDate': _startDateController.text,
        'endDate': _endDateController.text,
        'description': _descriptionController.text,
        'isCurrentPosition': _isCurrentPosition,
        'duration': _duration,
      };
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'workExperience': workExperience,
        });
      }
      Navigator.pop(context, workExperience);
    }
  }

  Future<bool> _onWillPop() async {
    if (_jobTitleController.text != _originalData['jobTitle'] ||
        _companyController.text != _originalData['company'] ||
        _startDateController.text != _originalData['startDate'] ||
        _endDateController.text != _originalData['endDate'] ||
        _descriptionController.text != _originalData['description'] ||
        _isCurrentPosition != _originalData['isCurrentPosition']) {
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
        Navigator.pop(context, null); // Discard changes and exit
        return false; // Prevent the back button from closing the page
      }
      return true; // Stay on the page
    }
    return true; // No changes, allow exit
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.workExperience == null ? 'Add Work Experience' : 'Change Work Experience'),
          actions: [
  IconButton(
    icon: const Icon(Icons.undo),
    onPressed: () async {
      // Check if there are changes to undo
      if (_jobTitleController.text != _originalData['jobTitle'] ||
          _companyController.text != _originalData['company'] ||
          _startDateController.text != _originalData['startDate'] ||
          _endDateController.text != _originalData['endDate'] ||
          _descriptionController.text != _originalData['description'] ||
          _isCurrentPosition != _originalData['isCurrentPosition']) {
        
        // Show confirmation dialog
        final shouldUndo = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Undo Changes'),
              content: const Text('Are you sure you want to undo the changes?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false); // Do not undo
                  },
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true); // Confirm undo
                  },
                  child: const Text('UNDO'),
                ),
              ],
            );
          },
        );

        // If the user confirmed, undo the changes
        if (shouldUndo == true) {
          _undoChanges();
        }
      }
    },
  ),
],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Job Title Input Field
                TextFormField(
                  controller: _jobTitleController,
                  decoration: InputDecoration(
                    labelText: 'Job Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a job title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Company Input Field
                TextFormField(
                  controller: _companyController,
                  decoration: InputDecoration(
                    labelText: 'Company',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a company';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Start Date and End Date Input Fields
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _startDateController,
                        decoration: InputDecoration(
                          labelText: 'Start Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context, _startDateController),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a start date';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _endDateController,
                        decoration: InputDecoration(
                          labelText: 'End Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        readOnly: true,
                        onTap: _isCurrentPosition
                            ? null
                            : () => _selectDate(context, _endDateController),
                        validator: (value) {
                          if (!_isCurrentPosition && (value == null || value.isEmpty)) {
                            return 'Please enter an end date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Duration Display
                if (_duration.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Duration: $_duration',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                // Current Position Checkbox
                CheckboxListTile(
                  title: const Text('This is my position now'),
                  value: _isCurrentPosition,
                  onChanged: (value) {
                    setState(() {
                      _isCurrentPosition = value ?? false;
                      if (_isCurrentPosition) {
                        _endDateController.text = '';
                        _calculateDuration();
                      }
                    });
                  },
                ),

                // Description Input Field
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),

                // Save Changes Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'SAVE CHANGES',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                // Remove Button (only shown when editing)
                if (widget.workExperience != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context, null);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          'REMOVE',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red[700],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}