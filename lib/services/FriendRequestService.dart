import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send friend request
  Future<void> sendFriendRequest({
    required String currentUserId,
    required String currentUserName,
    required String targetUserId,
  }) async {
    await _firestore
        .collection('users')
        .doc(targetUserId)
        .collection('friend_requests')
        .doc(currentUserId)
        .set({
          'senderId': currentUserId,
          'senderName': currentUserName,
          'status': 'pending',
          'timestamp': FieldValue.serverTimestamp(),
        });
  }
}
