import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class UserProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'users';

  /// CREATE (on signup)
  Future<void> createProfile(UserProfile profile) {
    return _firestore
        .collection(_collection)
        .doc(profile.uid)
        .set(
      {
        'username': profile.username,
        'createdAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  /// READ
  Stream<UserProfile?> watchProfile(String uid) {
    return _firestore
        .collection(_collection)
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return UserProfile.fromDoc(doc);
    });
  }

  /// UPDATE
  Future<void> updateUsername(String uid, String newUsername) {
    return _firestore.collection('users').doc(uid).set(
      {'username': newUsername},
      SetOptions(merge: true),
    );
  }
}
