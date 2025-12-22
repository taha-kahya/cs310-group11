import 'dart:async';
import 'package:flutter/material.dart';
import '../models/favorite_place.dart';
import '../repositories/favorites_repository.dart';

class FavoritesProvider extends ChangeNotifier {
  final FavoritesRepository _repo;

  FavoritesProvider(this._repo);

  bool isLoading = false;
  String? error;

  final Map<String, FavoritePlace> _byPlaceId = <String, FavoritePlace>{};
  StreamSubscription<List<FavoritePlace>>? _sub;

  List<FavoritePlace> get favorites => _byPlaceId.values.toList();

  void start(String uid) {
    _sub?.cancel();

    _byPlaceId.clear();

    isLoading = true;
    error = null;
    notifyListeners();

    _sub = _repo.watchFavorites(uid).listen(
          (items) {
        _byPlaceId.clear();
        for (var item in items) {
          _byPlaceId[item.placeId] = item;
        }
        isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        error = e.toString();
        isLoading = false;
        notifyListeners();
      },
    );
  }

  bool isFavorite(String placeId) {
    return _byPlaceId.containsKey(placeId);
  }

  Future<void> toggleFavorite({
    required String uid,
    required String placeId,
    FavoritePlace? fav,
    required bool makeFavorite,
  }) async {
    try {
      if (makeFavorite) {
        if (fav == null) {
          throw Exception('FavoritePlace object required when adding favorite');
        }

        // Optimistically add to local state
        _byPlaceId[placeId] = fav;
        notifyListeners();

        // Then update Firestore
        await _repo.addFavorite(fav);
      } else {
        // Optimistically remove from local state
        _byPlaceId.remove(placeId);
        notifyListeners();

        // Then update Firestore
        await _repo.deleteFavoriteByPlaceId(
          uid: uid,
          placeId: placeId,
        );
      }
    } catch (e) {
      error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}