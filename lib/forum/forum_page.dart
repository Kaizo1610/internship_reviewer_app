import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../notification/notifications_page.dart';
import 'edit_post_page.dart';
import 'add_post_page.dart';
import 'package:internship_reviewer_app/homepage/dashboard_screen.dart';
import 'package:internship_reviewer_app/save_job/bookmarks.dart';

class ForumPage extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Let Give Your Review on Internship'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No posts available.'));
          }

return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var post = snapshot.data!.docs[index];
              var data = post.data() as Map<String, dynamic>;
              String postId = post.id;

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: (data['profilePic'] != null && data['profilePic'] is String && data['profilePic'].isNotEmpty)
                            ? NetworkImage(data['profilePic'])
                            : null,
                        child: (data['profilePic'] == null || data['profilePic'].isEmpty)
                            ? Text((data['author'] ?? "?")[0].toUpperCase())
                            : null,
                      ),
                      title: Text(
                        data['title'] ?? 'No Title',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("By: ${data['author'] ?? 'Unknown'}"),
                          Text("Company: ${data['company'] ?? 'Not specified'}"),
                          const SizedBox(height: 5),
                          Text(data['description'] ?? 'No description available'),
                        ],
                      ),
                      trailing: (data['authorId'] == _auth.currentUser?.uid)
                          ? IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditPostPage(postId: postId, postData: data),
                                  ),
                                );
                              },
                            )
                          : null,
                    ),

Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildLikeButton(context, postId, data),
                          TextButton(
                            onPressed: () => _showComments(context, postId),
                            child: const Text("Comments"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.white), label: "Home", backgroundColor: Colors.deepPurple),
          BottomNavigationBarItem(icon: Icon(Icons.forum, color: Colors.white), label: "Forum", backgroundColor: Colors.deepPurple),
          BottomNavigationBarItem(icon: Icon(Icons.add, color: Colors.white), label: "Add Post", backgroundColor: Colors.deepPurple),
          BottomNavigationBarItem(icon: Icon(Icons.bookmarks, color: Colors.white), label: "Bookmarks", backgroundColor: Colors.deepPurple),
        ],
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ForumPage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPostPage()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Bookmarks()),
              );
              break;
          }
        },
      ),
    );
  }

Widget _buildLikeButton(BuildContext context, String postId, Map<String, dynamic> data) {
  String currentUserId = _auth.currentUser?.uid ?? "";
  return StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance.collection('posts').doc(postId).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData || snapshot.data == null) return const Icon(Icons.favorite_border);

      var postData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
      List<dynamic> likes = (postData['likes'] is List) ? postData['likes'] as List<dynamic> : [];
      bool isLiked = likes.contains(currentUserId);

      return Row(
        children: [
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              if (isLiked) {
                likes.remove(currentUserId);
              } else {
                likes.add(currentUserId);
                _sendNotification(postData['authorId'], "New Like", "Your post was liked.");
              }
              FirebaseFirestore.instance.collection('posts').doc(postId).update({'likes': likes});
            },
          ),
          Text('${likes.length}'),
        ],
      );
    },
  );
}


void _showComments(BuildContext context, String postId) {
    TextEditingController commentController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Comments",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(postId)
                      .collection('comments')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                    if (snapshot.data!.docs.isEmpty) return const Center(child: Text("No comments yet."));
                    return ListView(
                      children: snapshot.data!.docs.map((doc) {
                        var commentData = doc.data() as Map<String, dynamic>;
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: (commentData['profilePic'] != null && commentData['profilePic'] is String && commentData['profilePic'].isNotEmpty)
                                ? NetworkImage(commentData['profilePic'])
                                : null,
                            child: (commentData['profilePic'] == null || commentData['profilePic'].isEmpty)
                                ? Text((commentData['author'] ?? "?")[0].toUpperCase())
                                : null,
                          ),
                          title: Text(commentData['author'] ?? "Anonymous"),
                          subtitle: Text(commentData['text'] ?? "No content"),
                          trailing: (commentData['authorId'] == _auth.currentUser?.uid)
                              ? IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _deleteComment(postId, doc.id);
                                  },
                                )
                              : null,
                        );
                      }).toList(),
                    );
                  },
                ),
              ),

Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: const InputDecoration(
                          hintText: "Add a comment...",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (commentController.text.isNotEmpty) {
                          _addComment(postId, commentController.text);
                          commentController.clear();
                        }
                      },
                    ),

],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addComment(String postId, String commentText) {
    String currentUserId = _auth.currentUser?.uid ?? "";
    String currentUserName = _auth.currentUser?.displayName ?? "Anonymous";
    String profilePic = _auth.currentUser?.photoURL ?? "";

    FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').add({
      'author': currentUserName,
      'text': commentText,
      'profilePic': profilePic,
      'authorId': currentUserId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

void _deleteComment(String postId, String commentId) {
    FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').doc(commentId).delete();
  }

  void _sendNotification(String? userId, String title, String description) {
    if (userId == null) return;
    FirebaseFirestore.instance.collection('notifications').add({
      'userId': userId,
      'title': title,
      'description': description,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}