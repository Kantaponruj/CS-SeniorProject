import 'package:aboutlx/component/text_style.dart';
import 'package:aboutlx/models/JoinedEvent.dart';
import 'package:aboutlx/models/event.dart';
import 'package:aboutlx/models/exhibition.dart';
import 'package:aboutlx/screen/eventPage.dart';
import 'package:aboutlx/screen/exhibitionPage.dart';
import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate<String>{
  List<Exhibition> exhibitions;
  List<Event> events;
  List<JoinedEvent> joinedEvent;
  DateTime currentDate;

  DataSearch({this.exhibitions,this.events,this.joinedEvent,this.currentDate});

  @override
  List<Widget> buildActions(BuildContext context) {
    //actions for app bar
    return [
      IconButton(
        icon: Icon(Icons.cancel),
        onPressed: (){
          query = "";
        },
      ),
    ];
//    throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    //actions for left leading
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
//    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // show result of searching
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //show when someone searches for something
    var deviceData = MediaQuery.of(context);
    final List<Event> eventsuggestionList = events.where((element) => element.name.toLowerCase().contains(query.toLowerCase())).toList();
    final exhibitionsuggestionList = exhibitions.where((element) => element.name.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView(
      children: <Widget>[
        ListView.builder(
          shrinkWrap: true,
          itemCount: exhibitionsuggestionList.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context,index)=>ListTile(
            title: TitleText(exhibitionsuggestionList[index].name),
            subtitle: SubTitleText("Exhibition"),
            onTap: () {
              MaterialPageRoute exhibitionPageRoute = MaterialPageRoute(
                  builder: (BuildContext context) => exhibitionPage(exhibitionsuggestionList[index],deviceData));
              Navigator.of(context).push(exhibitionPageRoute);
            },
          )
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: eventsuggestionList.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context,index)=>ListTile(
              title: TitleText(eventsuggestionList[index].name),
              subtitle: SubTitleText("Event"),
              onTap: (){
                MaterialPageRoute eventPageRoute = MaterialPageRoute(
                    builder: (BuildContext context) => eventPage(
                        eventsuggestionList[index],
                        deviceData,
                        eventsuggestionList[index].getUserJoin(joinedEvent),
                        eventsuggestionList[index].getExhibitionName(exhibitions),
                        eventsuggestionList[index].start.compareTo(currentDate)<0
                    )
                );
                Navigator.of(context).push(eventPageRoute);
              },
            )
        ),
      ],
    );
    throw UnimplementedError();
  }

}