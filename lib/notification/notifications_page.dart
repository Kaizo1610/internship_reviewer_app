import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? userId;
  List<String> targetedRoles = [];

  @override
  void initState() {
    super.initState();
    getUserId();
    requestNotificationPermissions();
    listenForNotifications();
  }

  // Get the logged-in user ID
  void getUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
      fetchTargetedRoles();
    }
  }

  // Fetch targeted job roles from Firestore
  Future<void> fetchTargetedRoles() async {
    if (userId == null) return;
    var userDoc = await FirebaseFirestore.instance.collection('interns').doc(userId).get();
    setState(() {
      targetedRoles = List<String>.from(userDoc.data()?['targeted_roles'] ?? []);
    });
  }

  // Request permission for Firebase Messaging
  void requestNotificationPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission for push notifications");
    }
  }

  // Listen for incoming push notifications
  void listenForNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print("New Notification: ${message.notification!.title}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message.notification!.title ?? 'New Notification')),
        );
      }
    });
  }

  // Stream notifications filtered by targeted job roles
  Stream<QuerySnapshot> getNotificationsStream() {
    if (targetedRoles.isEmpty) {
      return FirebaseFirestore.instance.collection('notifications').snapshots();
    }
    return FirebaseFirestore.instance
        .collection('notifications')
        .where('job_role', whereIn: targetedRoles)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: StreamBuilder<QuerySnapshot>(
        stream: getNotificationsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No notifications.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Icon(Icons.notifications, color: Colors.deepPurple),
                  title: Text(data['title'] ?? 'No Title'),
                  subtitle: Text(data['description'] ?? 'No Description'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => FirebaseFirestore.instance
                        .collection('notifications')
                        .doc(snapshot.data!.docs[index].id)
                        .delete(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
