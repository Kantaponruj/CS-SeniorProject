import 'package:aboutlx/models/JoinedEvent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'exhibition.dart';

class Event{
  String id;
  String name;
  String detail;
  String exhibition;
  DateTime start;
  DateTime end;
  String room;

  Event({this.id, this.name, this.detail, this.exhibition, this.start, this.end, this.room});

   Future<int> getLike()async{
    var respectsQuery = Firestore.instance.collection('join').where('event', isEqualTo: id);
    var querySnapshot = await respectsQuery.getDocuments();
    int totalEquals = querySnapshot.documents.length;
    print(id);
    print(name + totalEquals.toString());
    return totalEquals;
  }

  String getExhibitionName(List<Exhibition> ex){
    for(Exhibition e in ex){
      if(exhibition==e.id)
        return e.name;
    }
  }

  JoinedEvent getUserJoin(List<JoinedEvent> alljoin){
    for(JoinedEvent e in alljoin){
      if(id==e.event)
        return e;
    }
    return null;
  }

//  addToDB() async{
//    await Firestore.instance.collection('events').add({
//      'name': name,
//      'detail' : detail,
//      'exhibition' : exhibition,
//      'start' : start,
//      'end' : end,
//      'room' : room,
//    });
//  }
}