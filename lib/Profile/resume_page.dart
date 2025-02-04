import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart'; // Use file_selector instead of file_picker
import 'package:intl/intl.dart'; // For date formatting

class ResumePage extends StatefulWidget {
  final Map<String, dynamic>? initialResume;
  const ResumePage({Key? key, this.initialResume}) : super(key: key);

  @override
  _ResumePageState createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  final _formKey = GlobalKey<FormState>();
  String? _resumePath;
  String? _fileName;
  String? _fileSize;
  String? _uploadDateTime;
  bool _hasChanges = false;
  bool _isCurrentFile = false;

  // Track original data for undo functionality
  late Map<String, dynamic> _originalData;

  @override
  void initState() {
    super.initState();
    if (widget.initialResume != null) {
      _resumePath = widget.initialResume!['path'];
      _fileName = widget.initialResume!['name'];
      _fileSize = widget.initialResume!['size'];
      _uploadDateTime = widget.initialResume!['uploadDateTime'];
      _isCurrentFile = true;
    } else {
      _resumePath = null;
      _fileName = null;
      _fileSize = null;
      _uploadDateTime = null;
      _isCurrentFile = false;
    }

    // Save original data for undo functionality
    _originalData = {
      'path': _resumePath,
      'name': _fileName,
      'size': _fileSize,
      'uploadDateTime': _uploadDateTime,
    };
  }

  Future<void> _pickFile() async {
    final XFile? file = await openFile(
      acceptedTypeGroups: [
        XTypeGroup(label: 'PDF', extensions: ['pdf']),
      ],
    );

    if (file != null) {
      final filePath = file.path;
      final fileName = file.name;
      final fileSize = (await file.length()) / 1024; // Convert bytes to KB
      final uploadDateTime = DateFormat('dd MMM yyyy HH:mm a').format(DateTime.now());

      setState(() {
        _resumePath = filePath;
        _fileName = fileName;
        _fileSize = fileSize.toStringAsFixed(2);
        _uploadDateTime = uploadDateTime;
        _isCurrentFile = true;
        _hasChanges = true;
      });
    }
  }

  void _removeResume() {
    setState(() {
      _resumePath = null;
      _fileName = null;
      _fileSize = null;
      _uploadDateTime = null;
      _isCurrentFile = false;
      _hasChanges = true;
    });
  }

  void _undoChanges() {
    setState(() {
      _resumePath = _originalData['path'];
      _fileName = _originalData['name'];
      _fileSize = _originalData['size'];
      _uploadDateTime = _originalData['uploadDateTime'];
      _isCurrentFile = _originalData['path'] != null;
      _hasChanges = false;
    });
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final resume = {
        'path': _resumePath,
        'name': _fileName,
        'size': _fileSize,
        'uploadDateTime': _uploadDateTime,
      };
      Navigator.pop(context, resume);
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
          title: Text(_isCurrentFile ? 'Edit Resume' : 'Add Resume'),
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (!_isCurrentFile) _buildUploadArea(),
                if (_isCurrentFile) _buildResumeCard(),
                const SizedBox(height: 16),
                _buildInstructions(),
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
                if (_isCurrentFile)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                        onPressed: _removeResume,
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

  Widget _buildUploadArea() {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 2,
            style: BorderStyle.solid, // Use BorderStyle.solid or BorderStyle.none
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: ElevatedButton(
            onPressed: _pickFile,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.upload),
                SizedBox(width: 8),
                Text('Upload CV/Resume'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResumeCard() {
    return Card(
      color: Colors.lightBlue[50],
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.file_present, color: Colors.red, size: 50),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _fileName!,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_fileSize KB • $_uploadDateTime',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _removeResume,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.transparent),
                    foregroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.delete, size: 16),
                      SizedBox(width: 4),
                      Text('Remove file'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return const Text(
      'Upload files in PDF format up to 5 MB. Just upload it once and you can use it in your next application.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 14),
    );
  }
}