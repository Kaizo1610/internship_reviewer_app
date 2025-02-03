import 'package:flutter/material.dart';
import 'upload_resume_popup.dart';

class JobDetailScreen extends StatefulWidget {
  final String title;
  final String company;
  final String location;
  final String salary;
  final List<String> tags;

  JobDetailScreen({
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.tags,
  });

  @override
  _JobDetailScreenState createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  bool isDescriptionSelected = true;
  bool isBookmarked = false;

  void toggleBookmark() {
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'lib/assets/images/logo_${widget.company.toLowerCase().replaceAll(' ', '_')}.png',
                      width: 80,
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "${widget.company} • ${widget.location}",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isDescriptionSelected = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDescriptionSelected ? Colors.deepPurple : Colors.grey.shade300,
                      ),
                      child: Text("Description", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isDescriptionSelected = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !isDescriptionSelected ? Colors.deepPurple : Colors.grey.shade300,
                      ),
                      child: Text("Company", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              isDescriptionSelected ? _buildJobDescription() : _buildCompanyInfo(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              iconSize: 45, 
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: isBookmarked ? Colors.deepPurple : Colors.grey,
              ),
              onPressed: toggleBookmark,
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return UploadResumePopup();
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 150, vertical: 20),
              ),
              child: Text(
                "APPLY NOW",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Job Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text("- Design and improve user experience.", style: TextStyle(fontSize: 14, color: Colors.grey)),
        SizedBox(height: 8),
        Text("- Work with developers to implement UI.", style: TextStyle(fontSize: 14, color: Colors.grey)),
        SizedBox(height: 8),
        Text("- Location: ${widget.location}", style: TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildCompanyInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("About Company", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text("Google is an internet-based company providing search, cloud, and advertising solutions.", style: TextStyle(fontSize: 14, color: Colors.grey)),
        SizedBox(height: 8),
        Text("Website: https://www.google.com", style: TextStyle(fontSize: 14, color: Colors.blue)),
        SizedBox(height: 8),
        Text("Employee size: 132,121 Employees", style: TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}