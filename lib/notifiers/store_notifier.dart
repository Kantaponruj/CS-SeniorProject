import 'dart:collection';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_map_stores/models/store.dart';

class StoreNotifier with ChangeNotifier {
  List<Store> _storeList = [];

  UnmodifiableListView<Store> get storeList => UnmodifiableListView(_storeList);

  set storeList(List<Store> storeList) {
    _storeList = storeList;
    notifyListeners();
  }
}
