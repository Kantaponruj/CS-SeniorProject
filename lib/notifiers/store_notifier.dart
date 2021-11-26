import 'dart:collection';

import 'package:cs_senior_project/models/menu.dart';
import 'package:cs_senior_project/models/store.dart';
import 'package:cs_senior_project/services/store_service.dart';
import 'package:flutter/material.dart';

class StoreNotifier with ChangeNotifier {
  List<Store> _storeList = [];
  Store _currentStore;

  List<MenuModel> _menuList = [];
  MenuModel _currentMenu;

  List<ToppingModel> _toppingList = [];

  List<StoreOpenDateTime> _dateTimeList = [];

  List<String> _categoriesList = [];

  UnmodifiableListView<Store> get storeList => UnmodifiableListView(_storeList);
  Store get currentStore => _currentStore;

  UnmodifiableListView<MenuModel> get menuList =>
      UnmodifiableListView(_menuList);
  MenuModel get currentMenu => _currentMenu;

  UnmodifiableListView<ToppingModel> get toppingList =>
      UnmodifiableListView(_toppingList);

  UnmodifiableListView<StoreOpenDateTime> get dateTimeList =>
      UnmodifiableListView(_dateTimeList);

  UnmodifiableListView<String> get categoriesList =>
      UnmodifiableListView(_categoriesList);

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
    _categoriesList.clear();
    menuList.forEach((menu) {
      if (_categoriesList.contains(menu.categoryFood)) {
      } else {
        _categoriesList.add(menu.categoryFood);
      }
    });

    _menuList = menuList;
    notifyListeners();
  }

  set currentMenu(MenuModel menu) {
    _currentMenu = menu;
    notifyListeners();
  }

  set toppingList(List<ToppingModel> topping) {
    _toppingList = topping;
    notifyListeners();
  }

  set dateTimeList(List<StoreOpenDateTime> dateTime) {
    _dateTimeList = dateTime;
    notifyListeners();
  }

  reloadStoreModel(String storeId) async {
    _currentStore = await getStoreById(storeId);
    notifyListeners();
  }
}
