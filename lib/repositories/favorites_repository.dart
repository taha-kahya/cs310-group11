import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/favorite_place.dart';

class FavoritesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'favorites';

  Stream<List<FavoritePlace>> watchFavorites(String uid) {
    return _firestore
        .collection(_collection)
        .where('createdBy', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(FavoritePlace.fromDoc).toList());
  }

  Future<void> addFavorite(FavoritePlace place) async {
    final docId = '${place.createdBy}_${place.placeId}';
    await _firestore.collection(_collection).doc(docId).set(place.toMap());
  }

  Future<void> deleteFavoriteByPlaceId({
    required String uid,
    required String placeId,
  }) async {
    final docId = '${uid}_$placeId';
    await _firestore.collection(_collection).doc(docId).delete();
  }
}