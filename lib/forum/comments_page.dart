import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class CommentsPage extends StatefulWidget { // Changed to StatefulWidget
  final String postId;

  CommentsPage({required this.postId});

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> { // State class
  final _auth = FirebaseAuth.instance;
  final TextEditingController _commentController = TextEditingController();

  void _addComment() {
    String commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    String currentUserId = _auth.currentUser?.uid ?? "";
    String currentUserName = _auth.currentUser?.displayName ?? "Anonymous";
    String profilePic = _auth.currentUser?.photoURL ?? "";

    FirebaseFirestore.instance.collection('posts').doc(widget.postId).collection('comments').add({ // Use widget.postId
      'author': currentUserName,
      'text': commentText,
      'profilePic': profilePic,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _commentController.clear();
  }


@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.postId) // Use widget.postId
                  .collection('comments')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No comments available.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var comment = snapshot.data!.docs[index];
                    var data = comment.data() as Map<String, dynamic>;

                    return Card( // Wrapped in Card for visual separation
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Added margin
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: (data['profilePic'] ?? "").isNotEmpty
                              ? NetworkImage(data['profilePic'])
                              : null,
                          child: (data['profilePic'] ?? "").isEmpty
                              ? Text((data['author'] ?? "?")[0].toUpperCase())
                              : null,
                        ),
                        title: Text(data['author'] ?? 'Anonymous', style: TextStyle(fontWeight: FontWeight.bold)), // Bold author name
                        subtitle: Text(data['text'] ?? ''),
                        trailing: Text(
                          DateFormat.yMMMd().add_jm().format((data['timestamp'] as Timestamp).toDate()), // Formatted date and time
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    );
                  },
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
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder( // Added border
                        borderRadius: BorderRadius.circular(25.0), // Rounded border
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16), // Added padding
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}