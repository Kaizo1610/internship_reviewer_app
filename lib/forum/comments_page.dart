import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentsPage extends StatelessWidget {
  final String postId;

  CommentsPage({required this.postId});

  final _auth = FirebaseAuth.instance;
  final TextEditingController _commentController = TextEditingController();

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
                  .doc(postId)
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

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: (data['profilePic'] ?? "").isNotEmpty
                            ? NetworkImage(data['profilePic'])
                            : null,
                        child: (data['profilePic'] ?? "").isEmpty
                            ? Text((data['author'] ?? "?")[0].toUpperCase())
                            : null,
                      ),
                      title: Text(data['author'] ?? 'Anonymous'),
                      subtitle: Text(data['text'] ?? ''),
                      trailing: Text(
                        (data['timestamp'] as Timestamp).toDate().toString(),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
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
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _addComment();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addComment() {
    String commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    String currentUserId = _auth.currentUser?.uid ?? "";
    String currentUserName = _auth.currentUser?.displayName ?? "Anonymous";
    String profilePic = _auth.currentUser?.photoURL ?? "";

    FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').add({
      'author': currentUserName,
      'text': commentText,
      'profilePic': profilePic,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _commentController.clear();
  }
}
