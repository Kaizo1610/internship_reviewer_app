import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'job_details_screen.dart'; // Ensure this import is present
=======
>>>>>>> 5e53e47b3982f517de964b538adfdcdfb18df0fe

class JobSearchScreen extends StatefulWidget {
  final String category;

  JobSearchScreen({required this.category});

  @override
  _JobSearchScreenState createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  String jobSearch = '';
  String locationSearch = '';
  String jobTypeFilter = '';
  double minSalary = 1000;
  double maxSalary = 20000;

  List<Map<String, dynamic>> jobs = [
    {
      "title": "UI/UX Designer",
      "company": "Shell",
      "location": "Petaling Jaya, Malaysia",
      "jobType": "Remote",
      "salary": 7000,
      "logo": "lib/assets/images/logo_shell.png"
    },
    {
      "title": "Lead Designer",
      "company": "Petronas",
      "location": "Kuala Lumpur, Malaysia",
      "jobType": "Physical",
      "salary": 6000,
      "logo": "lib/assets/images/logo_petronas.png"
    },
    {
      "title": "Software Engineer",
      "company": "Bank Negara Malaysia",
      "location": "Kuala Lumpur, Malaysia",
      "jobType": "Hybrid",
      "salary": 5500,
      "logo": "lib/assets/images/logo_bank_negara.png"
<<<<<<< HEAD
    },
    {
      "title": "Data Analyst",
      "company": "SLB",
      "location": "Petaling Jaya, Malaysia",
      "jobType": "Remote",
      "salary": 6000,
      "logo": "lib/assets/images/logo_slb.png"
=======
>>>>>>> 5e53e47b3982f517de964b538adfdcdfb18df0fe
    }
  ];

  @override
  void initState() {
    super.initState();
    jobTypeFilter = widget.category;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredJobs = jobs.where((job) {
      return (jobSearch.isEmpty ||
              job["title"].toLowerCase().contains(jobSearch.toLowerCase()) ||
              job["company"].toLowerCase().contains(jobSearch.toLowerCase())) &&
          (locationSearch.isEmpty ||
              job["location"].toLowerCase().contains(locationSearch.toLowerCase())) &&
          (jobTypeFilter.isEmpty || job["jobType"] == jobTypeFilter) &&
          (job["salary"] >= minSalary && job["salary"] <= maxSalary);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Job Search",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Job Title & Company Search
            TextField(
              decoration: InputDecoration(
                labelText: "Search job title or company",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  jobSearch = value;
                });
              },
            ),
            SizedBox(height: 10),

            // Location Search
            TextField(
              decoration: InputDecoration(
                labelText: "Search by location",
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  locationSearch = value;
                });
              },
            ),
            SizedBox(height: 10),

            // Filter Button
            ElevatedButton.icon(
              icon: Icon(Icons.filter_alt),
              label: Text("Filters"),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => filterBottomSheet(),
                );
              },
            ),

            SizedBox(height: 10),

            // Job Listings
            Expanded(
              child: ListView.builder(
                itemCount: filteredJobs.length,
                itemBuilder: (context, index) {
                  var job = filteredJobs[index];
<<<<<<< HEAD
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobDetailScreen(
                            title: job["title"],
                            company: job["company"],
                            location: job["location"],
                            salary: "\$${job["salary"]}/Mo",
                            tags: [job["jobType"]],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: Image.asset(job["logo"], width: 40),
                        title: Text(job["title"]),
                        subtitle: Text("${job["company"]} • ${job["location"]}"),
                        trailing: Text("\$${job["salary"]}/Mo"),
                      ),
=======
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: Image.asset(job["logo"], width: 40),
                      title: Text(job["title"]),
                      subtitle: Text("${job["company"]} • ${job["location"]}"),
                      trailing: Text("\$${job["salary"]}/Mo"),
>>>>>>> 5e53e47b3982f517de964b538adfdcdfb18df0fe
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Filter Modal Bottom Sheet
  Widget filterBottomSheet() {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Filters", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),

              // Job Type Filter
              Row(
                children: [
                  Text("Job Type: "),
                  DropdownButton<String>(
                    value: jobTypeFilter.isEmpty ? null : jobTypeFilter,
                    hint: Text("Select"),
                    items: ["Physical", "Remote", "Hybrid"]
                        .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                        .toList(),
                    onChanged: (value) {
                      setModalState(() {
                        jobTypeFilter = value!;
                      });
                    },
                  ),
                ],
              ),

              // Salary Range Filter
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Salary Range: \$$minSalary - \$$maxSalary"),
                  RangeSlider(
                    min: 1000,
                    max: 20000,
                    divisions: 19,
                    values: RangeValues(minSalary, maxSalary),
                    onChanged: (values) {
                      setModalState(() {
                        minSalary = values.start;
                        maxSalary = values.end;
                      });
                    },
                  ),
                ],
              ),

              // Apply Filters Button
              ElevatedButton(
                onPressed: () {
                  setState(() {}); // Update main screen with filters
                  Navigator.pop(context);
                },
                child: Text("Apply Filters"),
              ),
            ],
          ),
        );
      },
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 5e53e47b3982f517de964b538adfdcdfb18df0fe
