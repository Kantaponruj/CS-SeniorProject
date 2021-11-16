import 'package:cs_senior_project/component/show_datetime.dart';
import 'package:cs_senior_project/notifiers/activities_notifier.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DatePickerWidget extends StatefulWidget {
  DatePickerWidget({Key key}) : super(key: key);

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime date;

  String getText() {
    if (date == null) {
      return DateFormat('d MMMM y').format(DateTime.now());
    } else {
      return DateFormat('d MMMM y').format(date);
    }
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: date ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    setState(() {
      ActivitiesNotifier activity =
          Provider.of<ActivitiesNotifier>(context, listen: false);
      date = newDate;
      activity.saveDateOrdered(getText());
    });
  }

  @override
  Widget build(BuildContext context) {
    ActivitiesNotifier activity = Provider.of<ActivitiesNotifier>(context);

    return ShowDateTime(
      icon: Icons.calendar_today,
      text: activity.dateOrdered != null ? activity.dateOrdered : getText(),
      onClicked: () => pickDate(context),
    );
  }
}

class TimePickerWidget extends StatefulWidget {
  TimePickerWidget({Key key, this.isStartWaitingTime}) : super(key: key);
  final bool isStartWaitingTime;

  @override
  _TimePickerWidgetState createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  TimeOfDay time;
  String timeStr;

  String getText() {
    if (time == null) {
      return widget.isStartWaitingTime ? 'ตอนนี้' : 'ระบุเวลา';
    } else {
      final hours = time.hour.toString().padLeft(2, '0');
      final minutes = time.minute.toString().padLeft(2, '0');

      return '$hours:$minutes';
    }
  }

  Future pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: time ?? initialTime,
    );

    if (newTime == null) return;

    setState(() {
      ActivitiesNotifier activity =
          Provider.of<ActivitiesNotifier>(context, listen: false);
      time = newTime;
      widget.isStartWaitingTime
          ? activity.saveStartWaitingTime(getText())
          : activity.saveEndWaitingTime(getText());
    });
  }

  @override
  Widget build(BuildContext context) {
    ActivitiesNotifier activity = Provider.of<ActivitiesNotifier>(context);
    timeStr = widget.isStartWaitingTime
        ? activity.startWaitingTime
        : activity.endWaitingTime;

    return ShowDateTime(
      icon: Icons.access_time,
      text: timeStr != null ? timeStr : getText(),
      onClicked: () => pickTime(context),
    );
  }
}
