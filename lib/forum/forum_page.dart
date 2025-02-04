import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../notification/notifications_page.dart';

class ForumPage extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forum'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
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
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No posts available.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var post = snapshot.data!.docs[index];
              var data = post.data() as Map<String, dynamic>;
              String postId = post.id;

              return Card(
                margin: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: (data['profilePic'] ?? "").isNotEmpty
                            ? NetworkImage(data['profilePic'])
                            : null,
                        child: (data['profilePic'] ?? "").isEmpty
                            ? Text((data['author'] ?? "?")[0].toUpperCase())
                            : null,
                      ),
                      title: Text(data['title'] ?? 'No Title', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("By: ${data['author'] ?? 'Unknown'}"),
                          Text("Company: ${data['company'] ?? 'Not specified'}"),
                          SizedBox(height: 5),
                          Text(data['description'] ?? 'No description available'),
                        ],
                      ),
                    ),

                    // ✅ Image Handling Fix
                    if (data.containsKey('imageUrl') && (data['imageUrl'] ?? "").isNotEmpty)
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Image.network(
                          data['imageUrl'],
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildLikeButton(context, postId, data),
                          TextButton(
                            onPressed: () => _showComments(context, postId),
                            child: Text("Comments"),
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
    );
  }

Widget _buildLikeButton(BuildContext context, String postId, Map<String, dynamic> data) {
    String currentUserId = _auth.currentUser?.uid ?? "";

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('posts').doc(postId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Icon(Icons.favorite_border);

        var postData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
        List<dynamic> likes = postData['likes'] ?? [];
        bool isLiked = likes.contains(currentUserId);

        return Row(
          children: [
            IconButton(
              icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: isLiked ? Colors.red : Colors.grey),
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
              SizedBox(height: 10),
              Text("Comments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Divider(),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(postId)
                      .collection('comments')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                    if (snapshot.data!.docs.isEmpty) return Center(child: Text("No comments yet."));

                    return ListView(
                      children: snapshot.data!.docs.map((doc) {
                        var commentData = doc.data() as Map<String, dynamic>;
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: (commentData['profilePic'] ?? "").isNotEmpty
                                ? NetworkImage(commentData['profilePic'])
                                : null,
                            child: (commentData['profilePic'] ?? "").isEmpty
                                ? Text((commentData['author'] ?? "?")[0].toUpperCase())
                                : null,
                          ),
                          title: Text(commentData['author'] ?? "Anonymous"),
                          subtitle: Text(commentData['text'] ?? "No content"),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(hintText: "Write a comment...", border: OutlineInputBorder()),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.blue),
                      onPressed: () {
                        _addComment(postId, commentController.text);
                        commentController.clear();
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
    if (commentText.trim().isEmpty) return;

    String currentUserId = _auth.currentUser?.uid ?? "";
    String currentUserName = _auth.currentUser?.displayName ?? "Anonymous";
    String profilePic = _auth.currentUser?.photoURL ?? "";

    FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').add({
      'author': currentUserName,
      'text': commentText,
      'profilePic': profilePic,
      'timestamp': FieldValue.serverTimestamp(),
    });

    FirebaseFirestore.instance.collection('posts').doc(postId).get().then((postSnapshot) {
      var postData = postSnapshot.data() as Map<String, dynamic>? ?? {};
      _sendNotification(postData['authorId'], "New Comment", "Someone commented on your post.");
    });
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