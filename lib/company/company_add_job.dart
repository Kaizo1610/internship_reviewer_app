import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage_company.dart';

class CompanyAddJob extends StatefulWidget {
  @override
  _CompanyAddJobState createState() => _CompanyAddJobState();
}

class _CompanyAddJobState extends State<CompanyAddJob> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _company = '';
  String _location = '';
  String _salary = '';
  String _jobMode = '';

  Future<void> _submitJob() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot userJobs = await FirebaseFirestore.instance
            .collection('jobs')
            .where('userId', isEqualTo: user.uid)
            .get();
        if (userJobs.docs.length < 5) {
          await FirebaseFirestore.instance.collection('jobs').add({
            'title': _title,
            'company': _company,
            'location': _location,
            'salary': _salary,
            'jobMode': _jobMode,
            'userId': user.uid,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Successfully submitted new job')),
          );
          _formKey.currentState!.reset();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You can only submit up to 5 jobs')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Job for Interns'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Job Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a job title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Company Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a company name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _company = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
                onSaved: (value) {
                  _location = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Salary'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a salary';
                  }
                  return null;
                },
                onSaved: (value) {
                  _salary = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Job Mode'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a job mode';
                  }
                  return null;
                },
                onSaved: (value) {
                  _jobMode = value!;
                },
              ),
              SizedBox(height: 10),
              Icon(Icons.business),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _submitJob,
                child: Text('Submit Job'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Job',
          ),
        ],
        currentIndex: 1,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomepageCompany()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CompanyAddJob()),
              );
              break;
          }
        },
      ),
    );
  }
}