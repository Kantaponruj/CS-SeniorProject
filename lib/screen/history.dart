import 'package:aboutlx/component/HistoryList.dart';
import 'package:aboutlx/component/text_style.dart';
import 'package:aboutlx/models/JoinedEvent.dart';
import 'package:aboutlx/models/event.dart';
import 'package:aboutlx/models/exhibition.dart';
import 'package:aboutlx/models/user.dart';
import 'package:aboutlx/services/databaseService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class history extends StatefulWidget {
  User user;
  history({this.user});
  @override
  _historyState createState() => _historyState();
}

class _historyState extends State<history> {
  DateTime currentDate;
  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now();
    currentDate = DateTime.parse(currentDate.toString().substring(0,10)+" 00:00:00");
  }
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Exhibition>>.value(
      value: DatabaseService().exhibitions,
      child: StreamProvider<List<Event>>.value(
        value: DatabaseService().events,
        child: StreamProvider<List<JoinedEvent>>.value(
          value: DatabaseService(uid: widget.user.uid).joinedEvent,
          child: Scaffold(
            appBar:AppBar(
              elevation: 0.0,
              title: Text("History"),
            ),
            body: widget.user.isAnon ?
            Container(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[TitleText("Log in is required for this feature")],))) : HistoryList(currentDate: currentDate,),
          ),
        ),
      ),
    );

  }
}