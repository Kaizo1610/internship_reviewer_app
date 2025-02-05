//akim

import 'package:flutter/material.dart';
import 'sign_in.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Text(
                "Internova",
                style: TextStyle(
                  fontSize: screenSize.width * 0.045,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.05),
            Center(
              child: Image.asset(
                'lib/assets/images/splash_screen.png', 
                width: screenSize.width * 0.5,
                height: screenSize.height * 0.4,
              ),
            ),
            SizedBox(height: screenSize.height * 0.05),
            RichText(
              text: TextSpan(
                text: "Find Your ",
                style: TextStyle(
                  fontSize: screenSize.width * 0.07,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "Internship",
                    style: TextStyle(color: Colors.orange),
                  ),
                  TextSpan(text: " Here!"),
                ],
              ),
            ),
            SizedBox(height: screenSize.height * 0.01),
            Text(
              "Explore all the most exciting internship opportunities based on your interest and study major.",
              style: TextStyle(color: Colors.black54, fontSize: screenSize.width * 0.04),
            ),
            SizedBox(height: screenSize.height * 0.05),
            Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(screenSize.width * 0.04),
                  decoration: const BoxDecoration(
                    color: Colors.indigo,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_forward, color: Colors.white, size: screenSize.width * 0.07),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
