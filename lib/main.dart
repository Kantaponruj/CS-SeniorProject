import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_map_stores/directionPage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Around KMUTT'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({@required this.title});
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream<QuerySnapshot> _iceCreamStores;
  // final Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    super.initState();
    _iceCreamStores = FirebaseFirestore.instance
        .collection('stores_places')
        .orderBy('name')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: StreamBuilder(
            stream: _iceCreamStores,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData) {
                return Center(child: Text('Loading...'));
              }
              return Column(
                children: [
                  Flexible(
                      flex: 2,
                      child: StoreMap(
                        documents: snapshot.data.docs,
                        initialPosition: const LatLng(
                            13.655258306757673, 100.49825516513702),
                        // mapController: _mapController
                      )),
                  Flexible(
                      flex: 3,
                      child: StoreList(
                        documents: snapshot.data.docs,
                        // mapController: _mapController
                      )),
                  FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DirectionPage()));
                    },
                    label: Text('Go to Direction !'),
                    icon: Icon(Icons.directions_boat),
                  )
                ],
              );
            }));
  }
}

const _marker = 350.0;

class StoreMap extends StatelessWidget {
  const StoreMap(
      {Key key, @required this.documents, @required this.initialPosition})
      : super(key: key);

  final List<DocumentSnapshot> documents;
  final LatLng initialPosition;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        initialCameraPosition:
            CameraPosition(target: initialPosition, zoom: 15),
        markers: documents
            .map((document) => Marker(
                  markerId: MarkerId(document['placeId']),
                  icon: BitmapDescriptor.defaultMarkerWithHue(_marker),
                  position: LatLng(
                    document['location'].latitude,
                    document['location'].longitude,
                  ),
                  infoWindow: InfoWindow(
                    title: document['name'],
                    snippet: document['address'],
                  ),
                ))
            .toSet());
  }
}

class StoreList extends StatelessWidget {
  const StoreList({
    Key key,
    @required this.documents,
  }) : super(key: key);

  final List<DocumentSnapshot> documents;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final document = documents[index];
          return ListTile(
            title: Text(document['name']),
            subtitle: Text(document['address']),
          );
        });
  }
}
