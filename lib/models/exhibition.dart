import 'package:aboutlx/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'JoinedEvent.dart';

class Exhibition{
  final String id;
  final String name;
  final String detail;
  final DateTime date;
  final String pic;
  List<Event> events = new List<Event>();

  Exhibition({this.id, this.name, this.detail, this.date, this.pic});

  setEvents(List<Event> allEvent){
    events = new List<Event>();
    for(Event e in allEvent){
      if(e.exhibition==id){
        events.add(e);
      }
    }
  }

  setJoinedEvents(List<Event> allEvent,List<JoinedEvent> allJoinEvent){
    events = new List<Event>();
    for(Event e in allEvent){
      for(JoinedEvent je in allJoinEvent){
        if(je.event==e.id && e.exhibition==id){
          events.add(e);
          break;
        }
      }
    }
  }

  monthInName(){
    switch (date.month){
      case 1:{
        return "Jan";
      }break;
      case 2:{
        return "Feb";
      }break;
      case 3:{
        return "Mar";
      }break;
      case 4:{
        return "Apr";
      }break;
      case 5:{
        return "May";
      }break;
      case 6:{
        return "Jun";
      }break;
      case 7:{
        return "Jul";
      }break;
      case 8:{
        return "Aug";
      }break;
      case 9:{
        return "Sep";
      }break;
      case 10:{
        return "Oct";
      }break;
      case 11:{
        return "Nov";
      }break;
      case 12:{
        return "Dec";
      }break;
    }
  }

//  addToDB() async{
//    await Firestore.instance.collection('exhibitions').add({
//      'name': name,
//      'detail' : detail,
//      'date' : date.getDateTime(),
//      'pic' : pic,
//    });
//  }
}

class Date{
  int day;
  int month;
  int year;

  Date(int d,int m,int y){
    day=d;
    month=m;
    year=y;
  }

  monthInName(){
    switch (month){
      case 1:{
        return "Jan";
      }break;
      case 2:{
        return "Feb";
      }break;
      case 3:{
        return "Mar";
      }break;
      case 4:{
        return "Apr";
      }break;
      case 5:{
        return "May";
      }break;
      case 6:{
        return "Jun";
      }break;
      case 7:{
        return "Jul";
      }break;
      case 8:{
        return "Aug";
      }break;
      case 9:{
        return "Sep";
      }break;
      case 10:{
        return "Oct";
      }break;
      case 11:{
        return "Nov";
      }break;
      case 12:{
        return "Dec";
      }break;
    }
  }

  DateTime getDateTime(){
    String m;
    String d;
    if(month<10)
      m = "0"+month.toString();
    else
      m = month.toString();
    if(day<10)
      d = "0"+day.toString();
    else
      d = day.toString();
    return DateTime.parse(year.toString()+"-"+m+"-"+d+" "+"00:00:00");
  }
}