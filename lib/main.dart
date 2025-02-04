import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:internship_reviewer_app/auth/splash_screen.dart';
import 'package:internship_reviewer_app/auth/loading_screen.dart';
import 'package:internship_reviewer_app/forum/forum_page.dart';
import 'package:internship_reviewer_app/notification/notifications_page.dart';
import 'package:internship_reviewer_app/forum/add_post_page.dart';
import 'package:internship_reviewer_app/forum/edit_post_page.dart';
import 'firebase_options.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }

  runApp(const InternovaApp());
}

class InternovaApp extends StatelessWidget {
  const InternovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Internova',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const LoadingScreen(),
      routes: {
        '/loading': (context) => const LoadingScreen(),
        '/splash': (context) => const SplashScreen(),
        '/forum': (context) => ForumPage(),
        '/notifications': (context) => NotificationsPage(),
        '/add_post': (context) => AddPostPage(),
        '/edit_post': (context) => EditPostPage(
          postId: (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['postId'] as String,
          postData: (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['postData'] as Map<String, dynamic>,
        ),
      },
    );
  }
}
