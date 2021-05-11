import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_stores/models/customer.dart';

Future updateUserLocation(String uid, Position position) async {
  final DocumentReference userRef =
      FirebaseFirestore.instance.collection('users').doc(uid);

  await userRef
      .update(
          {'realtimeLocation': GeoPoint(position.latitude, position.longitude)})
      .then((value) => print("Sucessfully"))
      .catchError((error) => print("Failed to add user: $error"));
}
