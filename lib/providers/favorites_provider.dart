import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  bool isLoading = false;
  String? error;

  // data model
  List<dynamic> favorites = [];

  void clear() {
    favorites.clear();
    notifyListeners();
  }
}