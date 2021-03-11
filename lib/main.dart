import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {  

  GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller) {
  mapController = controller;
  setMarkers();
}

      double startLat = 13.652720;
double startLng = 100.493635;
double endLat = 13.6640896;
double endLng = 100.4357021;
// For holding instance of Marker
final Set<Marker> markers = {};   
      setMarkers() {
  markers.add(Marker(
    markerId: MarkerId("Home"),
    position: LatLng(startLat, startLng),
    infoWindow: InfoWindow(
      title: "Home",
      snippet: "Home Sweet Home",
    ),
  ),
  );
markers.add(Marker(
    markerId: MarkerId("Destination"),
    position: LatLng(endLat, endLng),
    infoWindow: InfoWindow(
      title: "Masjid",
      snippet: "5 star rated place",
    ),
  ));
  setState(() {});
}

static final CameraPosition _sit = CameraPosition(
      // bearing: 192.8334901395799,
      target: LatLng(13.652720, 100.493635),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: 
      GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: const LatLng(13.652720, 100.493635),
          zoom: 13,
        ),
        markers: markers,

      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheSIT,
      //   label: Text('To the SIT!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // Future<void> _goToTheSIT() async {
  //   final GoogleMapController controller = await mapController;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_sit));
  // }
}
