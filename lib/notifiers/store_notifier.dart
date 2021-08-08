import 'dart:collection';

import 'package:cs_senior_project/models/menu.dart';
import 'package:cs_senior_project/models/store.dart';
import 'package:flutter/material.dart';

class StoreNotifier with ChangeNotifier {
  List<Store> _storeList = [];
  Store _currentStore;

  List<MenuModel> _menuList = [];
  MenuModel _currentMenu;

  UnmodifiableListView<Store> get storeList => UnmodifiableListView(_storeList);
  UnmodifiableListView<MenuModel> get menuList =>
      UnmodifiableListView(_menuList);

  Store get currentStore => _currentStore;
  MenuModel get currentMenu => _currentMenu;

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

  set menuList(List<MenuModel> menuList) {
    _menuList = menuList;
    notifyListeners();
  }

  set currentMenu(MenuModel menu) {
    _currentMenu = menu;
    notifyListeners();
  }
}
