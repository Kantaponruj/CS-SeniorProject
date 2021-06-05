import 'package:cs_senior_project/component/appBar.dart';
import 'package:flutter/material.dart';


class NotificationsPage extends StatefulWidget {
  static const routeName = '/notifications';

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}


class _NotificationsPageState extends State<NotificationsPage> {

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
