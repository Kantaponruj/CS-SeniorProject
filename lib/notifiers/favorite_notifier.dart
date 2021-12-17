import 'dart:collection';

import 'package:cs_senior_project/models/favorite.dart';
import 'package:cs_senior_project/models/store.dart';
import 'package:flutter/material.dart';

class FavoriteNotifier with ChangeNotifier {
  List<Favorite> _favoriteList = [];
  List<Store> _favStoresList = [];

  UnmodifiableListView<Favorite> get favoriteList =>
      UnmodifiableListView(_favoriteList);

  UnmodifiableListView<Store> get favStoresList =>
      UnmodifiableListView(_favStoresList);

  set favoriteList(List<Favorite> favoriteList) {
    _favoriteList = favoriteList;
    notifyListeners();
  }

  set favStoresList(List<Store> storeList) {
    _favStoresList = storeList;
    notifyListeners();
  }

  addFavorite(Favorite favorite) {
    _favoriteList.insert(_favoriteList.length, favorite);
    notifyListeners();
  }

  deleteFavorite(Favorite favorite) {
    _favoriteList.removeWhere((fav) => fav.storeId == favorite.storeId);
    notifyListeners();
  }
}
