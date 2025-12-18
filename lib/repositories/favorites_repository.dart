import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/favorite_place.dart';

class FavoritesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'favorites';

  /// READ (real-time)
  Stream<List<FavoritePlace>> watchFavorites(String uid) {
    return _firestore
        .collection(_collection)
        .where('createdBy', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => FavoritePlace.fromDoc(doc))
              .toList();
        });
  }

  /// CREATE
  Future<void> addFavorite(FavoritePlace place) {
    return _firestore.collection(_collection).add(place.toMap());
  }

  /// DELETE
  Future<void> deleteFavorite(String docId) {
    return _firestore.collection(_collection).doc(docId).delete();
  }
}
