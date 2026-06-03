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
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          var allDocs = snapshot.data!.docs;

          var pendingRequests = allDocs.where((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return data['status'] == 'pending';
          }).toList();

          if (pendingRequests.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No pending requests found.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'UID: $currentUserId',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Total Documents: ${allDocs.length}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: pendingRequests.length,
            itemBuilder: (context, index) {
              var request =
                  pendingRequests[index].data() as Map<String, dynamic>;

              String senderId = request['senderId'] ?? '';
              String senderName = request['senderName'] ?? 'Unknown User';

              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    senderName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Wants to be your friend',
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () => acceptFriendRequest(
                            currentUserId: currentUserId,
                            senderUserId: senderId,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                          decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => rejectFriendRequest(
                            currentUserId: currentUserId,
                            senderUserId: senderId,
                          ),
                        ),
                      ),
                    ],
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
