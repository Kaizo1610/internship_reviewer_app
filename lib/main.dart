import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:internship_reviewer_app/auth/splash_screen.dart';
import 'auth/loading_screen.dart';
import 'forum/forum_page.dart';
import 'notification/notifications_page.dart';
import 'forum/add_post_page.dart';
import 'forum/edit_post_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
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

