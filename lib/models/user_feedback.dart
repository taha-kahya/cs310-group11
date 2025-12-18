import 'package:cloud_firestore/cloud_firestore.dart';

class UserFeedback {
  final String id;
  final String message;
  final int rating;
  final String createdBy;
  final DateTime createdAt;

  UserFeedback({
    required this.id,
    required this.message,
    required this.rating,
    required this.createdBy,
    required this.createdAt,
  });

  /// Dart → Firestore
  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'rating': rating,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Firestore → Dart
  factory UserFeedback.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserFeedback(
      id: doc.id,
      message: data['message'],
      rating: (data['rating'] as num).toInt(),
      createdBy: data['createdBy'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
