import 'dart:collection';

import 'package:cs_senior_project/models/order.dart';
import 'package:flutter/material.dart';

class OrderNotifier with ChangeNotifier {
  List<OrderModel> _orderList = [];
  OrderModel _currentOrder;

  UnmodifiableListView<OrderModel> get orderList =>
      UnmodifiableListView(_orderList);

  OrderModel get currentOrder => _currentOrder;

  set orderList(List<OrderModel> orderList) {
    _orderList = orderList;
    notifyListeners();
  }

  set currentOrder(OrderModel order) {
    _currentOrder = order;
    // notifyListeners();
  }

  addOrder(OrderModel order) {
    _orderList.add(order);
    notifyListeners();
  }
}
