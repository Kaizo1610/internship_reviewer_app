import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:internship_reviewer_app/homepage/dashboard_screen.dart';
import 'sign_in.dart';
import 'forgot_password.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
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
            SizedBox(height: 30),
            Text("Full Name"),
            TextField(
              decoration: InputDecoration(
                hintText: "Enter your full name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            Text("Email"),
            TextField(
              decoration: InputDecoration(
                hintText: "Enter your email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text("Password"),
            TextField(
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: "Enter your password",
                border: OutlineInputBorder(),
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
                    Text("Remember me"),
                  ],
                ),
                TextButton(onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                );
                }, child: Text("Forgot Password?")),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple[900],
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DashboardScreen()),
                );
              },
              child: Text("SIGN UP", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple[100],
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {},
              icon: Image.asset('lib/assets/images/logo_google.png', height: 24),
              label: Text("SIGN UP WITH GOOGLE", style: TextStyle(color: Colors.black)),
            ),
            SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: () {},
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(text: "Already have an account? "),
                      TextSpan(
                        text: "Sign in",
                        style: TextStyle(color: Colors.deepPurple[900], fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => SignInScreen()),
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
