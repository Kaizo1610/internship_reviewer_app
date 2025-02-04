//akim

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:internship_reviewer_app/auth/splash_screen.dart';
import 'forgot_password.dart';
import 'sign_up.dart';
import 'package:internship_reviewer_app/homepage/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const SplashScreen()),
            );
          },
        ),
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
                    "Welcome Back",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Welcome back! Ready to explore and review your internship journey? Let's dive in and make every experience count! 🚀✨",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
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
              onPressed: _signIn,
              child: const Text("LOGIN", style: TextStyle(color: Colors.white)),
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
                      const TextSpan(text: "You don’t have an account yet? "),
                      TextSpan(
                        text: "Sign up",
                        style: TextStyle(color: Colors.deepPurple[900], fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => SignUpScreen()),
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

  Future<void> _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the correct email and password!')),
      );
      return;
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        if (user.emailVerified) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please verify your email before signing in.')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid credentials. Please try again.')),
      );
    }
  }
}
