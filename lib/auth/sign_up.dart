//akim

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'sign_in.dart';
import 'forgot_password.dart';
import 'package:internship_reviewer_app/homepage/dashboard_screen.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internship_reviewer_app/company/homepage_company.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? selectedUserType;

  @override
  void initState() {
    super.initState();
  }

  void _signUp() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (selectedUserType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a user type')),
      );
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification email sent. Please check your inbox.')),
        );

        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'userType': selectedUserType, // Save user type to Firestore
        });

        if (selectedUserType == 'interns') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          );
        } else if (selectedUserType == 'company') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomepageCompany()),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign up: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  Text(
                    "Create an Account",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Welcome aboard! 🚀 Start your journey of sharing and discovering real internship experiences. Sign up now and make your voice count! ✨",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text("Full Name"),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: "Enter your full name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            const Text("Email"),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: "Enter your email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Password"),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: "Enter your password",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("User Type"),
            DropdownButtonFormField<String>(
              value: selectedUserType,
              onChanged: (String? newValue) {
                setState(() {
                  selectedUserType = newValue;
                });
              },
              items: const [
                DropdownMenuItem(value: 'interns', child: Text('Interns')),
                DropdownMenuItem(value: 'company', child: Text('Company')),
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value!;
                        });
                      },
                    ),
                    const Text("Remember me"),
                  ],
                ),
                TextButton(onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                );
                }, child: const Text("Forgot Password?")),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple[900],
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _signUp,
              child: const Text("SIGN UP", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: () {},
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      const TextSpan(text: "Already have an account? "),
                      TextSpan(
                        text: "Sign in",
                        style: TextStyle(color: Colors.deepPurple[900], fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const SignInScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
