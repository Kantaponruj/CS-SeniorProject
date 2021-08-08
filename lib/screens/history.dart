import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/component/shopAppBar.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  static const routeName = '/history';

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: RoundedAppBar(appBarTitle: 'ประวัติการสั่งซื้อ',),
        // AppBar(
        //   title: Text('Test'),
        //   centerTitle: true,
        //   shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        // ),
        body: Container(

        ),
      ),
    );
  }
}
