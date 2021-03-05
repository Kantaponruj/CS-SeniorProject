import 'package:aboutlx/models/event.dart';

class JoinedEvent{
  String id;
  String event;

  JoinedEvent({this.id,this.event});

  Event getEventInfo(List<Event> allEvent){
    for(Event e in allEvent){
      if(event==e.id)
        return e;
    }
  }
}