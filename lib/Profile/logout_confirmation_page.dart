import 'package:flutter/material.dart';
import 'package:internship_reviewer_app/auth/sign_in.dart';

class LogoutConfirmationPage extends StatelessWidget {
  const LogoutConfirmationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Log Out'),
      content: const Text('Are you sure you want to log out?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Cancel logout
          },
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            // Implement logout logic here
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logged out successfully!')),
            );
            Navigator.pop(context); // Confirm logout

            // Navigate to the sign-in page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
            );
          },
          child: const Text('YES'),
        ),
      ],
    );
  }
}