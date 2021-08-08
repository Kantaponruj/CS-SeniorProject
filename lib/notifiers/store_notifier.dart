import 'dart:collection';

import 'package:cs_senior_project/models/store.dart';
import 'package:flutter/material.dart';

class StoreNotifier with ChangeNotifier {
  List<Store> _storeList = [];
  Store _currentStore;

  UnmodifiableListView<Store> get storeList => UnmodifiableListView(_storeList);

  Store get currentStore => _currentStore;

  set storeList(List<Store> storeList) {
    Future.delayed(Duration(seconds: 1), () {
      _storeList = storeList;
      notifyListeners();
    });
  }

  set currentStore(Store store) {
    _currentStore = store;
    notifyListeners();
  }
}
