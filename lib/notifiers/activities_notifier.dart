import 'dart:collection';

import 'package:cs_senior_project/models/activities.dart';
import 'package:flutter/material.dart';

class ActivitiesNotifier with ChangeNotifier {
  List<Activities> _activitiesList = [];
  Activities _currentActivity;

  UnmodifiableListView<Activities> get activitiesList =>
      UnmodifiableListView(_activitiesList);

  Activities get currentActivity => _currentActivity;

  set activitiesList(List<Activities> activity) {
    _activitiesList = activity;
    notifyListeners();
  }

  set currentActivity(Activities activity) {
    _currentActivity = activity;
    notifyListeners();
  }

  // addActivity(Activities activity) {
  //   _activitiesList.insert(0, activity);
  //   notifyListeners();
  // }
}
