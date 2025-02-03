import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadResumePopup extends StatefulWidget {
  @override
  _UploadResumePopupState createState() => _UploadResumePopupState();
}

class _UploadResumePopupState extends State<UploadResumePopup> {
  String? fileName;
  TextEditingController infoController = TextEditingController();

  Future<void> pickResume() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx']);
      if (result != null) {
        setState(() {
          fileName = result.files.single.name;
        });
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

  void submitApplication() {
    if (fileName != null && infoController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Congratulations!! Your application has been sent"),
          backgroundColor: Colors.green,
        ),
      );
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
      title: Text("Upload CV & Information"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            onPressed: pickResume,
            icon: Icon(Icons.upload_file),
            label: Text(fileName ?? "Upload CV/Resume"),
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