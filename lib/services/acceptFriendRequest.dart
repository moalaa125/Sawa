import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
Future<void> acceptFriendRequest({
  required String currentUserId,
  required String senderUserId,
}) async {
  WriteBatch batch = _firestore.batch();

  // 1. Update the request status to accepted
  DocumentReference requestRef = _firestore
      .collection('users')
      .doc(currentUserId)
      .collection('friend_requests')
      .doc(senderUserId);
  batch.update(requestRef, {'status': 'accepted'});

  // 2. Add sender to current user's friends list array
  DocumentReference currentUserRef = _firestore
      .collection('users')
      .doc(currentUserId);
  batch.update(currentUserRef, {
    'friends': FieldValue.arrayUnion([senderUserId]),
  });

  // 3. Add current user to sender's friends list array
  DocumentReference senderUserRef = _firestore
      .collection('users')
      .doc(senderUserId);
  batch.update(senderUserRef, {
    'friends': FieldValue.arrayUnion([currentUserId]),
  });

  // Commit all changes together safely
  await batch.commit();
}

// Reject friend request
Future<void> rejectFriendRequest({
  required String currentUserId,
  required String senderUserId,
}) async {
  // Delete the request document to reject it
  await _firestore
      .collection('users')
      .doc(currentUserId)
      .collection('friend_requests')
      .doc(senderUserId)
      .delete();
}
