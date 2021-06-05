import 'package:cs_senior_project/component/appBar.dart';
import 'package:flutter/material.dart';


class Notifications extends StatefulWidget {
  static const routeName = '/notifications';

  @override
  _NotificationsState createState() => _NotificationsState();
}


class _NotificationsState extends State<Notifications> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoundedAppBar(appBarTitle: 'Notification',),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('This is notification page'),
          ],
        ),
      ),
    );
  }
}
