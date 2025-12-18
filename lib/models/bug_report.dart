import 'package:cloud_firestore/cloud_firestore.dart';

class BugReport {
  final String id;
  final String description;
  final String priority; // low / medium / high
  final String createdBy;
  final DateTime createdAt;

  BugReport({
    required this.id,
    required this.description,
    required this.priority,
    required this.createdBy,
    required this.createdAt,
  });

  /// Dart → Firestore
  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'priority': priority,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Firestore → Dart
  factory BugReport.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return BugReport(
      id: doc.id,
      description: data['description'],
      priority: data['priority'],
      createdBy: data['createdBy'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
