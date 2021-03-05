import 'package:aboutlx/component/text_style.dart';
import 'package:aboutlx/models/JoinedEvent.dart';
import 'package:aboutlx/models/event.dart';
import 'package:aboutlx/models/exhibition.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ScheduleCard.dart';

class ScheduleList extends StatelessWidget {
  DateTime currentDate;

  ScheduleList({this.currentDate});

  @override
  Widget build(BuildContext context) {
    final exhibition = Provider.of<List<Exhibition>>(context);
    final event = Provider.of<List<Event>>(context);
    final joinEvent = Provider.of<List<JoinedEvent>>(context);

    List<Exhibition> pastExhibition = new List<Exhibition>();

    for(int i=0 ; i<exhibition.length ; i++){
      if(exhibition[i].date.compareTo(currentDate)>=0){
        pastExhibition.add(exhibition[i]);
      }
    }
    for(int i=0 ; i<pastExhibition.length ; i++){
      pastExhibition[i].setJoinedEvents(event, joinEvent);
      if(pastExhibition[i].events.length==0){
        pastExhibition.removeAt(i);
        i--;
      }
    }
    return ListView.builder(
        itemCount: pastExhibition.length,
        itemBuilder: (context, index) => Container(
          margin: EdgeInsets.only(top: 5,right: 5,left: 5),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TitleText(pastExhibition[index].name),
              SubTitleText(pastExhibition[index].date.day.toString()+" "+pastExhibition[index].monthInName()+" "+pastExhibition[index].date.year.toString()),
              Divider(
                thickness: 2,
              ),
              ScheduleCard(exhibition: pastExhibition[index],),
            ],
          ),
        )
    );
  }
}
