import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_map_stores/notifiers/store_notifier.dart';
import 'package:google_map_stores/screens/directionPage.dart';
import 'package:google_map_stores/services/store_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  // const Home({@required this.title});
  // final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream<QuerySnapshot> _stores;
  final Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    super.initState();
    _stores = FirebaseFirestore.instance
        .collection('stores')
        .orderBy('name')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome"),
        ),
        body: StreamBuilder(
            stream: _stores,
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
                          mapController: _mapController)),
                  Flexible(
                      flex: 3,
                      child: StoreList(
                          documents: snapshot.data.docs,
                          mapController: _mapController)),
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
      {Key key,
      @required this.documents,
      @required this.initialPosition,
      @required this.mapController})
      : super(key: key);

  final List<DocumentSnapshot> documents;
  final LatLng initialPosition;
  final Completer<GoogleMapController> mapController;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: initialPosition, zoom: 15),
      markers: documents
          .map((document) => Marker(
                markerId: MarkerId(document['storeId']),
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
          .toSet(),
      onMapCreated: (mapController) {
        this.mapController.complete(mapController);
      },
    );
  }
}

class StoreList extends StatelessWidget {
  const StoreList(
      {Key key, @required this.documents, @required this.mapController})
      : super(key: key);

  final List<DocumentSnapshot> documents;
  final Completer<GoogleMapController> mapController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final document = documents[index];
          return ListTile(
            title: Text(document['name']),
            subtitle: Text(document['address']),
            onTap: () async {
              final controller = await mapController.future;
              await controller.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(document['location'].latitude,
                          document['location'].longitude),
                      zoom: 18)));
            },
          );
        });
  }
}
