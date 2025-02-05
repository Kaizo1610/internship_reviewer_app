import 'package:flutter/material.dart';
import 'package:internship_reviewer_app/homepage/dashboard_screen.dart';
import 'aboutme_page.dart';
import 'workexp_page.dart'; // Import the WorkExperiencePage
import 'edu_page.dart'; // Import the EduPage
import 'skill_page.dart'; // Import the SkillPage
import 'appreciate_page.dart'; // Import the AppreciationPage
import 'lang_page.dart'; // Import the LanguagePage
import 'resume_page.dart'; // Import the ResumePage
import 'setting_page.dart'; // Import the SettingsPage
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String aboutMeContent =
      'Add your details here!';
  Map<String, dynamic>? workExperience;
  Map<String, dynamic>? education;
  List<String> skills = [
    'Leadership',
    'Teamwork',
    'Visionary',
    'Target oriented',
    'Consistent',
    'Good communication skills',
    'English',
    'Responsibility'
  ];
  List<Map<String, dynamic>> appreciations = [
    {
      'awardName': 'Wireless Symposium (RWS)',
      'category': 'Young Scientist',
      'year': '2014',
    },
  ];
  bool _isSkillExpanded = false; // Added state variable for skill expansion
  List<Map<String, dynamic>> languages = [
    // Added languages list
    {
      'language': 'English',
      'oralLevel': 'Fluent',
      'writtenLevel': 'Fluent',
    },
    {
      'language': 'German',
      'oralLevel': 'Intermediate',
      'writtenLevel': 'Intermediate',
    },
    {
      'language': 'Spanish',
      'oralLevel': 'Basic',
      'writtenLevel': 'Basic',
    },
  ];
  Map<String, dynamic>? resume; // Added resume variable
  String username = ''; // Initialize username as an empty string

  @override
  void initState() {
    super.initState();
    _fetchUsername(); // Fetch username when the widget is initialized
  }

  Future<void> _fetchUsername() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          setState(() {
            username = userDoc['name']; // Fetch the name field from Firestore
          });
        } else {
          setState(() {
            username = 'User document does not exist';
          });
        }
      } else {
        setState(() {
          username = 'No user is currently signed in';
        });
      }
    } catch (e) {
      setState(() {
        username = 'Error fetching username: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6A1B9A), Color(0xFF512DA8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Arrow and Settings Icon at the top
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DashboardScreen(),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('lib/assets/images/madd.png'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    username.isEmpty ? 'Loading...' : '$username', // Use string interpolation
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'IIUM, Gombak',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                    label: const Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white24,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Enhanced Expandable Sections
            _buildCustomExpandableSection(
              title: 'About me',
              icon: Icons.person,
              content: aboutMeContent,
              onEdit: () async {
                final updatedContent = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutMePage(initialContent: aboutMeContent),
                  ),
                );
                if (updatedContent != null) {
                  setState(() {
                    aboutMeContent = updatedContent;
                  });
                }
              },
            ),
            _buildCustomExpandableSection(
              title: 'Work experience',
              icon: Icons.work,
              content: workExperience == null
                  ? 'Add your experience here'
                  : '${workExperience!['jobTitle']}\n${workExperience!['company']}\n${workExperience!['startDate']} - ${workExperience!['endDate']} • ${workExperience!['duration']}',
              onEdit: () async {
                final updatedWorkExperience = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkExperiencePage(workExperience: workExperience),
                  ),
                );
                if (updatedWorkExperience != null) {
                  setState(() {
                    workExperience = updatedWorkExperience;
                  });
                } else {
                  setState(() {
                    workExperience = null; // Clear work experience if discarded
                  });
                }
              },
            ),
            _buildCustomExpandableSection(
              title: 'Education',
              icon: Icons.school,
              content: education == null
                  ? 'Add your education here'
                  : '${education!['levelOfEducation']}\n${education!['institutionName']}\n${education!['fieldOfStudy']}\n${education!['startDate']} - ${education!['endDate']} • ${education!['duration']}',
              onEdit: () async {
                final updatedEducation = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EduPage(education: education),
                  ),
                );
                if (updatedEducation != null) {
                  setState(() {
                    education = updatedEducation;
                  });
                } else if (updatedEducation == null) {
                  setState(() {
                    education = null; // Clear education if removed
                  });
                }
              },
            ),
            _buildCustomExpandableSection(
              title: 'Skill',
              icon: Icons.settings,
              content: '', // Content is not needed since skillWidget is used
              onEdit: () async {
                final updatedSkills = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SkillPage(initialSkills: skills),
                  ),
                );
                if (updatedSkills != null) {
                  setState(() {
                    skills = updatedSkills;
                  });
                }
              },
              skillWidget: _buildSkillWidget(),
            ),
            _buildCustomExpandableSection(
              title: 'Language',
              icon: Icons.translate,
              content: '', // Content is not needed since languageWidget is used
              skillWidget: _buildLanguageWidget(),
              onEdit: () async {
                final updatedLanguages = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LanguagePage(initialLanguages: languages),
                  ),
                );
                if (updatedLanguages != null) {
                  setState(() {
                    languages = updatedLanguages;
                  });
                }
              },
            ),
            _buildCustomExpandableSection(
              title: 'Appreciation',
              icon: Icons.emoji_events,
              content: appreciations.isEmpty
                  ? 'Add your appreciation here'
                  : appreciations.map((appreciation) {
                      return '${appreciation['awardName']}\n${appreciation['category']} • ${appreciation['year']}';
                    }).join('\n\n'),
              onEdit: () async {
                final updatedAppreciations = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppreciationPage(initialAppreciations: appreciations),
                  ),
                );
                if (updatedAppreciations != null) {
                  setState(() {
                    appreciations = updatedAppreciations;
                  });
                }
              },
            ),
            _buildCustomExpandableSection(
              title: 'Resume',
              icon: Icons.insert_drive_file,
              content: '', // Content is not needed since resumeWidget is used
              onEdit: () async {
                final updatedResume = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResumePage(initialResume: resume),
                  ),
                );
                if (updatedResume != null) {
                  setState(() {
                    resume = updatedResume;
                  });
                } else if (updatedResume == null) {
                  setState(() {
                    resume = null; // Clear resume if removed
                  });
                }
              },
              skillWidget: _buildResumeWidget(),
            ),
          ],
        ),
      ),
      // Remove the bottom navigation bar
    );
  }

  Widget _buildHeaderIcon(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildCustomExpandableSection({
    required String title,
    required IconData icon,
    required String content,
    VoidCallback? onEdit,
    Widget? skillWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        elevation: 5, // Add shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ExpansionTile(
          leading: Icon(icon, color: Colors.orange, size: 28), // Larger icon
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20, // Larger font size
              color: Colors.black87,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_drop_down, // More modern arrow icon
            color: Colors.redAccent,
            size: 30,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  if (skillWidget != null) skillWidget,
                  if (content.isNotEmpty && skillWidget == null)
                    Text(
                      content,
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  if (onEdit != null)
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange, size: 24), // Larger edit icon
                      onPressed: onEdit,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: skills.take(_isSkillExpanded ? skills.length : 5).map((skill) {
            return Chip(
              label: Text(skill),
              onDeleted: () {
                setState(() {
                  skills.remove(skill);
                });
              },
              deleteIcon: Icon(Icons.close, size: 16),
            );
          }).toList(),
        ),
        if (skills.length > 5)
          TextButton(
            onPressed: () {
              setState(() {
                _isSkillExpanded = !_isSkillExpanded;
              });
            },
            child: Text(
              _isSkillExpanded ? 'See less' : 'See more',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLanguageWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: languages.map((language) {
            return Chip(
              label: Text('${language['language']} (Oral: ${language['oralLevel']}, Written: ${language['writtenLevel']})'),
              onDeleted: () {
                setState(() {
                  languages.remove(language);
                });
              },
              deleteIcon: Icon(Icons.close, size: 16),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildResumeWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (resume != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'File Name: ${resume!['name']}',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
                'File Size: ${resume!['size']} KB',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
                'Uploaded: ${resume!['uploadDateTime']}',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        if (resume == null)
          const Text(
            'Add your resume here',
            style: TextStyle(fontSize: 16, color: Colors.black87), //tryd
          ),
      ],
    );
  }
}