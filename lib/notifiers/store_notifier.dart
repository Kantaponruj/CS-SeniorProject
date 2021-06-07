import 'dart:collection';

import 'package:cs_senior_project/models/store.dart';
import 'package:flutter/material.dart';

class StoreNotifier with ChangeNotifier {
  List<Store> _storeList = [];

  UnmodifiableListView<Store> get storeList => UnmodifiableListView(_storeList);

  set storeList(List<Store> storeList) {
    Future.delayed(Duration(seconds: 2), () {
      _storeList = storeList;
      notifyListeners();
    });
  }
}
