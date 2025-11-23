import 'package:flutter/foundation.dart';
import 'package:locai/widgets/place_card.dart';

class FavoritesState {
  FavoritesState._();

  static final FavoritesState instance = FavoritesState._();

  final ValueNotifier<List<Place>> favorites =
  ValueNotifier<List<Place>>([]);

  bool isFavorite(Place place) {
    return favorites.value.any((p) => p.name == place.name);
  }

  void setFavorite(Place place, bool isFavorite) {
    final current = List<Place>.from(favorites.value);
    final index = current.indexWhere((p) => p.name == place.name);

    if (isFavorite) {
      if (index == -1) {
        current.add(place);
      }
    } else {
      if (index != -1) {
        current.removeAt(index);
      }
    }

    favorites.value = current;
  }

  void toggleFavorite(Place place) {
    setFavorite(place, !isFavorite(place));
  }
}
