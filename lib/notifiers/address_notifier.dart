import 'dart:collection';

import 'package:cs_senior_project/models/address.dart';
import 'package:flutter/material.dart';

class AddressNotifier with ChangeNotifier {
  List<AddressModel> _addressList = [];
  AddressModel _currentAddress;

  UnmodifiableListView<AddressModel> get addressList =>
      UnmodifiableListView(_addressList);

  AddressModel get currentAddress => _currentAddress;

  set addressList(List<AddressModel> addressList) {
    _addressList = addressList;
    notifyListeners();
  }

  set currentAddress(AddressModel address) {
    _currentAddress = address;
    notifyListeners();
  }

  addAddress(AddressModel address) {
    _addressList.insert(0, address);
    notifyListeners();
  }

  deleteAddress(AddressModel address) {
    _addressList
        .removeWhere((_address) => _address.addressId == address.addressId);
    notifyListeners();
  }
}
