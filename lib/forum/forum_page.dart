import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ForumPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forum')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No posts available.'));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: data['profilePic'] != null && data['profilePic'].isNotEmpty
                            ? NetworkImage(data['profilePic'])
                            : null,
                        child: data['profilePic'] == null ? Text(data['author'][0]) : null,
                      ),
                      title: Text(data['title']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("By: ${data['author']}"),
                          Text("Company: ${data['company']}"),
                          Text(data['description']),
                          if (data['imageUrl'] != null) Image.network(data['imageUrl']),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
