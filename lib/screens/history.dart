import 'package:cs_senior_project/component/appBar.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  static const routeName = '/history';

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoundedAppBar(appBarTitle: 'History',),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('This is history page'),
          ],
        ),
      ),
    );
  }
}
