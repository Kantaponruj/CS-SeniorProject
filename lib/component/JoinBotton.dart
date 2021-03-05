import 'package:aboutlx/screen/schedule.dart';
import 'package:provider/provider.dart';
import 'package:aboutlx/component/text_style.dart';
import 'package:aboutlx/models/event.dart';
import 'package:aboutlx/models/user.dart';
import 'package:aboutlx/models/JoinedEvent.dart';
import 'package:aboutlx/services/databaseService.dart';
import 'package:flutter/material.dart';

class JoinBotton extends StatelessWidget {
  Event event;
  User user;
  var deviceData;
  bool past;

  JoinBotton({this.event,this.deviceData,this.user,this.past});
  @override
  Widget build(BuildContext context) {
    final allEvent = Provider.of<List<Event>>(context);
    final joinEvent = Provider.of<List<JoinedEvent>>(context);
    JoinedEvent userJoin = event.getUserJoin(joinEvent);
    if(past){
      return InkWell(
        child: Container(
          width: deviceData.size.width,
          child: Material(
            borderRadius: BorderRadius.circular(10.0),
            color:Color.fromRGBO(189, 189, 189, 1),
            child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  WhiteTitleText("Event already end"),
                ],
              ),
            ),
          ),
        ),
      );
    }
    else if(user.isAnon){
      return InkWell(
        child: Container(
          width: deviceData.size.width,
          child: Material(
            borderRadius: BorderRadius.circular(10.0),
            color:Color.fromRGBO(189, 189, 189, 1),
            child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  WhiteTitleText("Need to log in"),
                ],
              ),
            ),
          ),
        ),
      );
    }
    else if(userJoin==null){
      return InkWell(
        onTap: () async {
          print("Join it");
          bool overlap=false;
          for(JoinedEvent je in joinEvent){
            if(je.getEventInfo(allEvent).start.compareTo(event.start)>0&&je.getEventInfo(allEvent).start.compareTo(event.end)<0 || je.getEventInfo(allEvent).end.compareTo(event.start)>0&&je.getEventInfo(allEvent).end.compareTo(event.end)<0){
              overlap=true;
              break;
            }
          }
          if(overlap){
            showDialog(
              context: context,
              builder: (context)=> AlertDialog(
                title: TitleText("Overlap time"),
                content: SubTitleText("This event have overlaping time with evwnt you already joined"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Close"),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("Edit"),
                    onPressed: (){
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => schedule(user: user,)));
                    },
                  ),
                  FlatButton(
                    child: Text("Join"),
                    onPressed: ()async{
                      Navigator.of(context).pop();
                      dynamic result = await DatabaseService(uid: user.uid).join(event.id);
                    },
                  ),
                ],
              )
            );
          }
          else{
            dynamic result = await DatabaseService(uid: user.uid).join(event.id);
          }
        },
        child: Container(
          width: deviceData.size.width,
          child: Material(
            borderRadius: BorderRadius.circular(10.0),
            color:Color.fromRGBO(240, 102, 74, 1),
            child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  WhiteTitleText("Join"),
                ],
              ),
            ),
          ),
        ),
      );
    }
    else{
      return InkWell(
        onTap: () async {
          print("Join it");
          dynamic result = await DatabaseService(uid: user.uid).unJoin(userJoin);
        },
        child: Container(
          width: deviceData.size.width,
          child: Material(
            borderRadius: BorderRadius.circular(10.0),
            color:Color.fromRGBO(240, 102, 74, 0.3),
            child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TitleText("Un Join"),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
