import 'package:aboutlx/models/JoinedEvent.dart';
import 'package:aboutlx/models/user.dart';
import 'package:aboutlx/services/databaseService.dart';
import 'package:flutter/material.dart';
import 'package:aboutlx/models/exhibition.dart';
import 'package:aboutlx/component/text_style.dart';
import 'package:aboutlx/screen/eventPage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventListView extends StatefulWidget {

  var deviceData;
  Exhibition exhibition;
  EventListView(Exhibition e, var deviceData) {
    exhibition = e;
    this.deviceData = deviceData;
  }

  @override
  _EventListViewState createState() => _EventListViewState();
}

class _EventListViewState extends State<EventListView> {
  DateTime currentDate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentDate = DateTime.now();
    currentDate = DateTime.parse(currentDate.toString().substring(0,10)+" 00:00:00");
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamProvider<List<JoinedEvent>>.value(
      value : DatabaseService(uid: user.uid).joinedEvent,
      child: EventItem(widget.exhibition,widget.deviceData,currentDate)
    );
  }
}

class EventItem extends StatelessWidget {
  DateTime currentDate;
  var deviceData;
  Exhibition exhibition;
  EventItem(Exhibition e, var deviceData,DateTime c) {
    exhibition = e;
    this.deviceData = deviceData;
    currentDate = c;
  }

  @override
  Widget build(BuildContext context) {
    final joinedEvent = Provider.of<List<JoinedEvent>>(context);
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemExtent: deviceData.size.width,
      itemCount: exhibition.events.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          MaterialPageRoute eventPageRoute = MaterialPageRoute(
              builder: (BuildContext context) => eventPage(exhibition.events[index],deviceData,exhibition.events[index].getUserJoin(joinedEvent),exhibition.name,
                  exhibition.events[index].start.compareTo(currentDate)<0
              )
          );
          Navigator.of(context).push(eventPageRoute);
        },
        child: Container(
          padding: EdgeInsets.all(30),
          child: Material(
            borderRadius: BorderRadius.circular(10.0),
            color:
            index % 2 == 0 ? Colors.orange : Colors.amberAccent,
            child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  WhiteTitleText(exhibition.events[index].name),
                  WhiteTitleText(DateFormat.Hm().format(exhibition.events[index].start) + " to " + DateFormat.Hm().format(exhibition.events[index].end)),
//                  SubTitleText(exhibition.events[index].getLike().toString())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



