import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
Future<void> acceptFriendRequest({
  required String currentUserId,
  required String senderUserId,
}) async {
  WriteBatch batch = _firestore.batch();

  DocumentReference requestRef = _firestore
      .collection('users')
      .doc(currentUserId)
      .collection('friend_requests')
      .doc(senderUserId);
  batch.update(requestRef, {'status': 'accepted'});

  DocumentReference currentUserRef = _firestore
      .collection('users')
      .doc(currentUserId);
  batch.update(currentUserRef, {
    'friends': FieldValue.arrayUnion([senderUserId]),
  });

  DocumentReference senderUserRef = _firestore
      .collection('users')
      .doc(senderUserId);
  batch.update(senderUserRef, {
    'friends': FieldValue.arrayUnion([currentUserId]),
  });

  await batch.commit();
}

Future<void> rejectFriendRequest({
  required String currentUserId,
  required String senderUserId,
}) async {
  await _firestore
      .collection('users')
      .doc(currentUserId)
      .collection('friend_requests')
      .doc(senderUserId)
      .delete();
}
