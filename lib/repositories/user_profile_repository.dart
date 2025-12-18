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
        .set(profile.toMap());
  }

  /// READ
  Future<UserProfile?> getProfile(String uid) async {
    final doc = await _firestore.collection(_collection).doc(uid).get();

    if (!doc.exists) return null;

    return UserProfile.fromDoc(doc);
  }

  /// UPDATE
  Future<void> updateUsername(String uid, String newUsername) {
    return _firestore.collection(_collection).doc(uid).update({
      'username': newUsername,
    });
  }
}
