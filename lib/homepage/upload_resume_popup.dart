import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io'; 

class UploadResumePopup extends StatefulWidget {
  @override
  _UploadResumePopupState createState() => _UploadResumePopupState();
}

class _UploadResumePopupState extends State<UploadResumePopup> {
  String? fileName;
  String? fileUrl; // To store the Firebase URL of the uploaded file
  TextEditingController infoController = TextEditingController();

  Future<void> pickResume() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );
      if (result != null) {
        String? path = result.files.single.path;
        setState(() {
          fileName = result.files.single.name;
        });

        // Upload file to Firebase Storage
        if (path != null) {
          final storageRef = FirebaseStorage.instance.ref().child('resumes/$fileName');
          File file = File(path);
          try {
            await storageRef.putFile(file);
            String downloadUrl = await storageRef.getDownloadURL();

            setState(() {
              fileUrl = downloadUrl;
            });
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("An error occurred while uploading the file: $e"),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred while picking the file: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> submitApplication() async {
    if (fileUrl != null && infoController.text.isNotEmpty) {
      // Save application data to Firestore
      await FirebaseFirestore.instance.collection('applications').add({
        'fileName': fileName,
        'fileUrl': fileUrl,
        'info': infoController.text,
        'timestamp': DateTime.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Congratulations! Your application has been sent."),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context); // Close the popup
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please upload a resume and provide your information."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text("Upload Resume & Information"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            onPressed: pickResume,
            icon: Icon(Icons.upload_file),
            label: Text(fileName ?? "Upload Resume"),
          ),
          SizedBox(height: 10),
          TextField(
            controller: infoController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Explain why you are the right person for this job",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: submitApplication,
          child: Text("Submit"),
        ),
      ],
    );
  }
}