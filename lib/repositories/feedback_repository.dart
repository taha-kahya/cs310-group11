import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_feedback.dart';

class FeedbackRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'feedback';

  Future<void> submitFeedback(UserFeedback feedback) {
    return _firestore.collection(_collection).add(feedback.toMap());
  }
}
