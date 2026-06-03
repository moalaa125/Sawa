import 'package:chat_app/constant.dart';
import 'package:chat_app/services/acceptFriendRequest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class Requests extends StatelessWidget {
  const Requests({super.key});

  @override
  Widget build(BuildContext context) {

    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    
    return Scaffold(
      backgroundColor: kPrimaryColor,

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .collection('friend_requests')
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          var docs = snapshot.data!.docs;
          if (docs.isEmpty) return Center(child: Text("No pending requests"));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var request = docs[index].data() as Map<String, dynamic>;
              String senderId = request['senderId'];

              return ListTile(
                title: Text(request['senderName'] ?? 'Unknown User'),
                subtitle: Text("Wants to be your friend"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () => acceptFriendRequest(  
                        currentUserId: currentUserId,
                        senderUserId: senderId,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () => rejectFriendRequest(   
                        currentUserId: currentUserId,
                        senderUserId: senderId,
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
}
