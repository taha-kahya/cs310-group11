import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/search_history.dart';

class RecentSearchesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'recent_searches';

  Stream<List<SearchHistory>> watchSearches(String uid) {
    return _firestore
        .collection(_collection)
        .where('createdBy', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => SearchHistory.fromDoc(doc))
              .toList();
        });
  }

  Future<void> addSearch(SearchHistory search) {
    return _firestore.collection(_collection).add(search.toMap());
  }

  Future<void> deleteSearch(String docId) {
    return _firestore.collection(_collection).doc(docId).delete();
  }
}
