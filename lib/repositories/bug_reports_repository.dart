import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bug_report.dart';

class BugReportsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'bug_reports';

  Future<void> submitBugReport(BugReport bug) {
    return _firestore.collection(_collection).add(bug.toMap());
  }
}
