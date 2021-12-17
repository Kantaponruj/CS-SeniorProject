import 'dart:collection';

import 'package:cs_senior_project/models/order.dart';
import 'package:cs_senior_project/services/user_service.dart';
import 'package:cs_senior_project/models/activities.dart';
import 'package:flutter/material.dart';

class ActivitiesNotifier with ChangeNotifier {
  List<Activity> _activitiesList = [];
  List<OrderModel> _orderMenuList = [];
  Activity _currentActivity;

  String _dateOrdered;
  String _startWaitingTime;
  String _endWaitingTime;
  String _arrivableTime;

  UnmodifiableListView<Activity> get activitiesList =>
      UnmodifiableListView(_activitiesList);

  List<OrderModel> get orderMenuList => _orderMenuList;

  Activity get currentActivity => _currentActivity;

  String get dateOrdered => _dateOrdered;
  String get startWaitingTime => _startWaitingTime;
  String get endWaitingTime => _endWaitingTime;
  String get arrivableTime => _arrivableTime;

  set activitiesList(List<Activity> activity) {
    _activitiesList = activity;
    notifyListeners();
  }

  set currentActivity(Activity activity) {
    _currentActivity = activity;
    notifyListeners();
  }

  set orderMenuList(List<OrderModel> orderMenuList) {
    _orderMenuList = orderMenuList;
    notifyListeners();
  }

  saveDateOrdered(String date) {
    _dateOrdered = date;
  }

  saveStartWaitingTime(String startT) {
    _startWaitingTime = startT;
  }

  saveEndWaitingTime(String endT) {
    _endWaitingTime = endT;
  }

  resetDateTimeOrdered() {
    _dateOrdered = null;
    _startWaitingTime = null;
    _endWaitingTime = null;
  }

  reloadActivityModel(String uid, String activityId) async {
    _currentActivity = await getActivityById(uid, activityId);
    notifyListeners();
  }

  getArrivableTime(String time) {
    _arrivableTime = time;
  }
}
