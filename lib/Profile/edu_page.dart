import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EduPage extends StatefulWidget {
  final Map<String, dynamic>? education;
  const EduPage({Key? key, this.education}) : super(key: key);

  @override
  _EduPageState createState() => _EduPageState();
}

class _EduPageState extends State<EduPage> {
  final _formKey = GlobalKey<FormState>();
  late String _levelOfEducation;
  late String _institutionName;
  late String _fieldOfStudy;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late String _description;
  bool _isCurrentPosition = false;
  bool _hasChanges = false;
  String _duration = '';

  // Track original data for undo functionality (immutable after initialization)
  late Map<String, dynamic> _originalData;

  @override
  void initState() {
    super.initState();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    if (widget.education != null) {
      _levelOfEducation = widget.education!['levelOfEducation'];
      _institutionName = widget.education!['institutionName'];
      _fieldOfStudy = widget.education!['fieldOfStudy'];
      _startDateController.text = widget.education!['startDate'];
      _endDateController.text = widget.education!['endDate'];
      _description = widget.education!['description'];
      _isCurrentPosition = widget.education!['isCurrentPosition'];
    } else {
      _levelOfEducation = '';
      _institutionName = '';
      _fieldOfStudy = '';
      _startDateController.text = '';
      _endDateController.text = '';
      _description = '';
      _isCurrentPosition = false;
    }
    // Save original data for undo functionality (immutable)
    _originalData = {
      'levelOfEducation': _levelOfEducation,
      'institutionName': _institutionName,
      'fieldOfStudy': _fieldOfStudy,
      'startDate': _startDateController.text,
      'endDate': _endDateController.text,
      'description': _description,
      'isCurrentPosition': _isCurrentPosition,
    };
    print('Original Data Initialized: $_originalData'); // Debugging line
    _calculateDuration();
    // Add listeners to controllers to track changes
    _startDateController.addListener(_onFieldChanged);
    _endDateController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    setState(() {
      _hasChanges = _levelOfEducation != _originalData['levelOfEducation'] ||
          _institutionName != _originalData['institutionName'] ||
          _fieldOfStudy != _originalData['fieldOfStudy'] ||
          _startDateController.text != _originalData['startDate'] ||
          _endDateController.text != _originalData['endDate'] ||
          _description != _originalData['description'] ||
          _isCurrentPosition != _originalData['isCurrentPosition'];
    });
    print('Has Changes: $_hasChanges'); // Debugging line
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
    if (months < 0) {
      years--;
      months += 12;
    }
    if (endDate.day < startDate.day) {
      months--;
      if (months < 0) {
        years--;
        months += 12;
      }
    }
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
      _onFieldChanged(); // Notify that changes have been made
    }
  }

  void _undoChanges() {
    setState(() {
      // Reset all fields to their original values
      _levelOfEducation = _originalData['levelOfEducation'];
      _institutionName = _originalData['institutionName'];
      _fieldOfStudy = _originalData['fieldOfStudy'];
      _startDateController.text = _originalData['startDate']; // Reset controller text
      _endDateController.text = _originalData['endDate']; // Reset controller text
      _description = _originalData['description'];
      _isCurrentPosition = _originalData['isCurrentPosition'];
      _hasChanges = false; // No changes after undo
      _calculateDuration(); // Recalculate duration
    });
    print('Undo Changes Applied. Current Data: $_originalData'); // Debugging line
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final education = {
        'levelOfEducation': _levelOfEducation,
        'institutionName': _institutionName,
        'fieldOfStudy': _fieldOfStudy,
        'startDate': _startDateController.text,
        'endDate': _endDateController.text,
        'description': _description,
        'isCurrentPosition': _isCurrentPosition,
        'duration': _duration,
      };
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'education': education,
        });
      }
      Navigator.pop(context, education);
    }
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
        Navigator.pop(context, _originalData); // Discard changes and exit
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
          title: Text(widget.education == null ? 'Add Education' : 'Change Education'),
          actions: [
            IconButton(
              icon: const Icon(Icons.undo),
              onPressed: () async {
                // Check if there are changes to undo
                if (_levelOfEducation != _originalData['levelOfEducation'] ||
                    _institutionName != _originalData['institutionName'] ||
                    _fieldOfStudy != _originalData['fieldOfStudy'] ||
                    _startDateController.text != _originalData['startDate'] ||
                    _endDateController.text != _originalData['endDate'] ||
                    _description != _originalData['description'] ||
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
                DropdownButtonFormField<String>(
                  value: _levelOfEducation.isNotEmpty ? _levelOfEducation : null,
                  decoration: InputDecoration(
                    labelText: 'Level of education',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  items: ['Bachelor', 'Master', 'PhD', 'Diploma']
                      .map((level) => DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _levelOfEducation = value!;
                      _onFieldChanged();
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a level of education';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _institutionName,
                  decoration: InputDecoration(
                    labelText: 'Institution name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) {
                    _institutionName = value;
                    _onFieldChanged();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the institution name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _fieldOfStudy,
                  decoration: InputDecoration(
                    labelText: 'Field of study',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) {
                    _fieldOfStudy = value;
                    _onFieldChanged();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the field of study';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _startDateController,
                        decoration: InputDecoration(
                          labelText: 'Start date',
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
                            return 'Please enter the start date';
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
                          labelText: 'End date',
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
                            return 'Please enter the end date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
                CheckboxListTile(
                  title: const Text('This is my current position'), 
                  value: _isCurrentPosition,
                  onChanged: (value) {
                    setState(() {
                      _isCurrentPosition = value!;
                      _onFieldChanged();
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _description,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  maxLines: 3,
                  onChanged: (value) {
                    _description = value;
                    _onFieldChanged();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'SAVE',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                // Remove Button (only shown when editing)
                if (widget.education != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context, null); // Return null to indicate removal
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