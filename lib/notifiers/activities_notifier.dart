import 'dart:collection';

import 'package:cs_senior_project/models/activities.dart';
import 'package:flutter/material.dart';

class ActivitiesNotifier with ChangeNotifier {
  List<Activities> _activitiesList = [];
  Activities _currentActivity;

  String _dateOrdered;
  String _timeOrdered;

  UnmodifiableListView<Activities> get activitiesList =>
      UnmodifiableListView(_activitiesList);

  Activities get currentActivity => _currentActivity;

  String get dateOrdered => _dateOrdered;
  String get timeOrdered => _timeOrdered;

  set activitiesList(List<Activities> activity) {
    _activitiesList = activity;
    notifyListeners();
  }

  set currentActivity(Activities activity) {
    _currentActivity = activity;
    notifyListeners();
  }

  saveDateOrdered(String date) {
    _dateOrdered = date;
  }

  svaeTimeOrdered(String time) {
    _timeOrdered = time;
  }

  resetDateTimeOrdered() {
    _dateOrdered = null;
    _timeOrdered = null;
  }

  // addActivity(Activities activity) {
  //   _activitiesList.insert(0, activity);
  //   notifyListeners();
  // }
}
