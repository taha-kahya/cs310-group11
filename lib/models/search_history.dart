import 'package:cloud_firestore/cloud_firestore.dart';

class SearchHistory {
  final String id;
  final String query;
  final String createdBy;
  final DateTime createdAt;

  SearchHistory({
    required this.id,
    required this.query,
    required this.createdBy,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'query': query,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory SearchHistory.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return SearchHistory(
      id: doc.id,
      query: data['query'],
      createdBy: data['createdBy'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
