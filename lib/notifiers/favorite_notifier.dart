import 'dart:collection';

import 'package:cs_senior_project/models/favorite.dart';
import 'package:flutter/material.dart';

class FavoriteNotifier with ChangeNotifier {
  List<Favorite> _favoriteList = [];
  // Favorite _currentFavorite;

  UnmodifiableListView<Favorite> get favoriteList =>
      UnmodifiableListView(_favoriteList);
  // Favorite get currentFavorite => _currentFavorite;

  set favoriteList(List<Favorite> favoriteList) {
    _favoriteList = favoriteList;
    notifyListeners();
  }

  // set currentFavorite(Favorite favorite) {
  //   _currentFavorite = favorite;
  //   notifyListeners();
  // }

  addFavorite(Favorite favorite) {
    _favoriteList.add(favorite);
    notifyListeners();
  }

  deleteFavorite(Favorite favorite) {
    _favoriteList.removeWhere((fav) => fav.storeId == favorite.storeId);
    notifyListeners();
  }
}
