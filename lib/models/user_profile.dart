import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String username;
  final DateTime createdAt;

  UserProfile({
    required this.uid,
    required this.username,
    required this.createdAt,
  });

  /// Dart -> Firestore
  Map<String, dynamic> toMap() {
    return {'username': username, 'createdAt': Timestamp.fromDate(createdAt)};
  }

  /// Firestore -> Dart
  factory UserProfile.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserProfile(
      uid: doc.id,
      username: data['username'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
