import 'dart:collection';

import 'package:cs_senior_project/models/address.dart';
import 'package:flutter/material.dart';

class AddressNotifier with ChangeNotifier {
  List<AddressModel> _addressList = [];

  UnmodifiableListView<AddressModel> get addressList =>
      UnmodifiableListView(_addressList);

  set addressList(List<AddressModel> addressList) {
    _addressList = addressList;
    notifyListeners();
  }

  addAddress(AddressModel address) {
    _addressList.insert(0, address);
    notifyListeners();
  }
}
