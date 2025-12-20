import 'package:flutter/foundation.dart';

class SearchProvider extends ChangeNotifier {
  String? _query;

  String? get query => _query;

  void setQuery(String query) {
    _query = query;
    notifyListeners();
  }

  void clear() {
    _query = null;
    notifyListeners();
  }
}
