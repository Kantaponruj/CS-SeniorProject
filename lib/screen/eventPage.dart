import 'package:aboutlx/models/JoinedEvent.dart';
import 'package:aboutlx/models/user.dart';
import 'package:aboutlx/services/databaseService.dart';
import 'package:flutter/material.dart';
import 'package:aboutlx/models/event.dart';
import 'package:aboutlx/component/text_style.dart';
import 'package:aboutlx/component/JoinBotton.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class eventPage extends StatefulWidget {
  bool past;
  String exhibition;
  Event event;
  var deviceData;
  JoinedEvent join;
  eventPage(this.event,this.deviceData,this.join,this.exhibition,this.past);
  @override
  _eventPageState createState() => _eventPageState(event,deviceData,join);
}

class _eventPageState extends State<eventPage> {
  Event event;
  var deviceData;
  JoinedEvent join;
  _eventPageState(this.event,this.deviceData,this.join);
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamProvider<List<Event>>.value(
      value: DatabaseService().events,
      child: StreamProvider<List<JoinedEvent>>.value(
        value: DatabaseService(uid: user.uid).joinedEvent,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
//        backgroundColor: Colors.white,
            elevation: 0.0,
            title: Text("Event Info"),
          ),
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TitleText.withSize(event.name,20),
                        SubTitleText(DateFormat.Hm().format(event.start)+" - "+DateFormat.Hm().format(event.end)),
                        SubTitleText("Room: "+event.room),
                        SubTitleText("Exhibiton: "+widget.exhibition),
                        SizedBox(height: 10,),
                        Text(event.detail),
                        SizedBox(height: 20,),
                        JoinBotton(event: event,deviceData: deviceData,user: user,past: widget.past,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
