import 'package:aboutlx/models/JoinedEvent.dart';
import 'package:aboutlx/models/event.dart';
import 'package:aboutlx/models/exhibition.dart';
import'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;

  DatabaseService({this.uid});

  final CollectionReference eventCollection = Firestore.instance.collection('events');
  List<Event> _eventFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Event(
        id : doc.documentID,
        name : doc.data["name"],
        detail : doc.data["detail"],
        exhibition : doc.data["exhibition"],
        start : (doc.data["start"] as Timestamp).toDate(),
        end : (doc.data["end"] as Timestamp).toDate(),
        room : doc.data["room"],
      );
    }).toList();
  }
  Stream<List<Event>> get events{
    return eventCollection.orderBy('start').snapshots().map(_eventFromSnapshot);
  }

  //exhibition list from snapshot
  final CollectionReference exhibitionCollection = Firestore.instance.collection('exhibitions');

  List<Exhibition> _exhibitionFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Exhibition(
        id : doc.documentID,
        name :doc.data["name"],
        detail : doc.data["detail"],
        date : (doc.data["date"] as Timestamp).toDate(),
        pic :"images/DSC_0019.jpg",
      );
    }).toList();
  }
  Stream<List<Exhibition>> get exhibitions{
    return exhibitionCollection.orderBy('date').snapshots().map(_exhibitionFromSnapshot);
  }

  //join unjoin joinlist
  final CollectionReference joinCollection = Firestore.instance.collection('join');
  Future join(String evnetID)async{
    return await joinCollection.add({
      'user' : uid,
      'event' : evnetID,
    });
  }
  Future unJoin(JoinedEvent evnet)async{
    return await joinCollection.document(evnet.id).delete();
  }
  List<JoinedEvent> _joinedEventFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return JoinedEvent(
        id : doc.documentID,
        event :doc.data["event"],
      );
    }).toList();
  }
  Stream<List<JoinedEvent>> get joinedEvent{
    return joinCollection.where('user',isEqualTo: uid).snapshots().map(_joinedEventFromSnapshot);
  }
}