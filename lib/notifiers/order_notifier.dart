import 'dart:math';

import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderNotifier with ChangeNotifier {
  List<OrderModel> _orderList = [];
  OrderModel _currentOrder;
  int _netPrice = 0;
  int _totalFoodPrice = 0;
  int _oldShippingFee;
  String _distance;
  String _shippingFee = '0';

  List<OrderModel> get orderList => _orderList;

  OrderModel get currentOrder => _currentOrder;

  int get netPrice => _netPrice;
  int get totalFoodPrice => _totalFoodPrice;
  String get distance => _distance;
  String get shippingFee => _shippingFee;

  List<LatLng> _polylineCoordinates = [];
  PolylinePoints _polylinePoints = PolylinePoints();
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

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

  setPolylines(LatLng customerP, LatLng storeP) async {
    _oldShippingFee = int.parse(_shippingFee);
    _shippingFee = '0';

    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAPS_API_KEY,
      PointLatLng(customerP.latitude, customerP.longitude),
      PointLatLng(storeP.latitude, storeP.longitude),
    );

    if (result.status == 'OK') {
      result.points.forEach((PointLatLng point) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      calculateDistance();
    }
  }

  void calculateDistance() {
    double totalDistance = 0.0;
    double distance;

    for (int i = 0; i < _polylineCoordinates.length - 1; i++) {
      totalDistance += _coordinateDistance(
        _polylineCoordinates[i].latitude,
        _polylineCoordinates[i].longitude,
        _polylineCoordinates[i + 1].latitude,
        _polylineCoordinates[i + 1].longitude,
      );
    }

    _distance = totalDistance.toStringAsFixed(2);

    if (double.parse(_distance) > 1) {
      distance = double.parse(_distance) - 1;
      _shippingFee = (distance * 5).toInt().toString();
      _netPrice += int.parse(_shippingFee);
    } else {
      _netPrice -= _oldShippingFee;
    }

    _polylineCoordinates.clear();
  }
}
