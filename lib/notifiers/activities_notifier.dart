import 'dart:collection';

import 'package:cs_senior_project/services/user_service.dart';
import 'package:cs_senior_project/models/activities.dart';
import 'package:flutter/material.dart';

class ActivitiesNotifier with ChangeNotifier {
  List<Activity> _activitiesList = [];
  Activity _currentActivity;

  String _dateOrdered;
  String _timeOrdered;
  String _arrivableTime;

  UnmodifiableListView<Activity> get activitiesList =>
      UnmodifiableListView(_activitiesList);

  Activity get currentActivity => _currentActivity;

  String get dateOrdered => _dateOrdered;
  String get timeOrdered => _timeOrdered;
  String get arrivableTime => _arrivableTime;

  set activitiesList(List<Activity> activity) {
    _activitiesList = activity;
    notifyListeners();
  }

  set currentActivity(Activity activity) {
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

  reloadActivityModel(String uid, String activityId) async {
    _currentActivity = await getActivityById(uid, activityId);
    notifyListeners();
  }

  getArrivableTime(String time) {
    _arrivableTime = time;
  }

  calculateEstimateTime(int estimateTime, int timeOrdered) {
    int arrivableTime;
    arrivableTime = estimateTime + timeOrdered;

    if (arrivableTime == 60) {
      arrivableTime = 00;
    } else if (arrivableTime > 60) {
      arrivableTime = estimateTime;
    }

    _arrivableTime = arrivableTime.toString();
  }
}
