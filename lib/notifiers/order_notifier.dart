import 'dart:collection';

import 'package:cs_senior_project/models/order.dart';
import 'package:flutter/material.dart';

class OrderNotifier with ChangeNotifier {
  List<OrderModel> _orderList = [];
  OrderModel _currentOrder;
  int _netPrice;
  int _totalFoodPrice;
  String _distance;
  String _shippingFee;

  List<OrderModel> get orderList => _orderList;

  OrderModel get currentOrder => _currentOrder;

  int get netPrice => _netPrice;
  int get totalFoodPrice => _totalFoodPrice;
  String get distance => _distance;
  String get shippingFee => _shippingFee;

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

  removeOrder(OrderModel order) {
    _totalFoodPrice = _totalFoodPrice - int.parse(order.totalPrice);
    _netPrice = _netPrice - int.parse(order.totalPrice);
    _orderList.removeWhere((_order) => _order.menuId == order.menuId);
    notifyListeners();
  }

  getNetPrice(int totalPrice) {
    _totalFoodPrice = totalPrice;
    _netPrice = totalPrice + int.parse(_shippingFee);
    notifyListeners();
  }

  getDistanceAndShippingFee(String distance, String shippingFee) {
    _distance = distance;
    _shippingFee = shippingFee;
  }
}
