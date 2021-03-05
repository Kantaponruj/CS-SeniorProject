import 'package:aboutlx/screen/exhibitionMap.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class KMUTTmap extends StatefulWidget {
  @override
  _KMUTTmapState createState() => _KMUTTmapState();
}

class _KMUTTmapState extends State<KMUTTmap> {
  // Completer<GoogleMapController> _controller = Completer();
  // static const LatLng _center = const LatLng(13.649497, 100.492955);
  // final Set<Marker> _markers = {};
  // LatLng _lastMapPosition = _center;
  // MapType _currentMapType = MapType.normal;

  // static final CameraPosition _position1 = CameraPosition(
  //   bearing: 192.833,
  //   target: LatLng(13.649497, 100.492955),
  //   tilt: 59.440,
  //   zoom: 11.0,
  // );

  // Future<void> _goToPosition1() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_position1));
  // }

  // _onMapCreated(GoogleMapController controller) {
  //   _controller.complete(controller);
  // }

  // _onCameraMove(CameraPosition position) {
  //   _lastMapPosition = position.target;
  // }

  // _onMapTypeButtonPressed() {
  //   setState(() {
  //     _currentMapType = _currentMapType == MapType.normal
  //         ? MapType.satellite
  //         : MapType.normal;
  //   });
  // }

  // _onAddMarkerButtonPressed() {
  //   setState(() {
  //     _markers.add(
  //       Marker(
  //         markerId: MarkerId(_lastMapPosition.toString()),
  //         position: _lastMapPosition,
  //         infoWindow: InfoWindow(
  //           title: 'This is a Title',
  //           snippet: 'This is a snippet',
  //         ),
  //         icon: BitmapDescriptor.defaultMarker,
  //       ),
  //     );
  //   });
  // }

  // Widget button(Function function, IconData icon) {
  //   return FloatingActionButton(
  //     onPressed: function,
  //     materialTapTargetSize: MaterialTapTargetSize.padded,
  //     backgroundColor: Colors.orange,
  //     child: Icon(icon, size: 36.0),
  //   );
  // }

  GoogleMapController _controller;
  GoogleMapController myController;
  String _selectedMap = null;

  List<Marker> allMarkers = [];

  Widget popupMennuButton() {
    return PopupMenuButton<String>(
      icon: Icon(Icons.add, size: 30.0),
      itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          value: "Exhibition",
          child: Text("Exhibition Map"),
        ),
        PopupMenuItem<String>(
          value: "KMUTT",
          child: Text("KMUTT Map"),
        ),
      ],
      onSelected: (answer) {
        print(answer);
        if (answer == "Exhibition") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ControllerPhotoViewPage()),
          );
        } else if (answer == "KMUTT") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => KMUTTmap()),
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    allMarkers.add(Marker(
      markerId: MarkerId('myMarker'),
      draggable: false,
      onTap: () {
        print('Marker Tapped');
      },
      position: LatLng(51.5074, 0.1278)
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KMUTT Map'),
        actions: <Widget>[
          popupMennuButton(),
        ],
      ),
      body: SingleChildScrollView(
              child: Column(children: <Widget>[
          // FittedBox(
          //   child: GoogleMap(
          //     onMapCreated: _onMapCreated,
          //     initialCameraPosition: CameraPosition(
          //       target: _center,
          //       zoom: 11.0,
          //     ),
          //     mapType: _currentMapType,
          //     markers: _markers,
          //     onCameraMove: _onCameraMove,
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.all(16.0),
          //   child: Column(
          //     children: <Widget>[
          //       button(_onMapTypeButtonPressed, Icons.map),
          //       SizedBox(
          //         height: 16.0,
          //       ),
          //       button(_onAddMarkerButtonPressed, Icons.add_location),
          //       SizedBox(
          //         height: 16.0,
          //       ),
          //       button(_goToPosition1, Icons.location_searching)
          //     ],
          //   ),
          // ),

          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(51.5074, 0.1278),
                zoom: 12.0,
              ),
              markers: Set.from(allMarkers),
              onMapCreated: mapCreated,
            ),
          ),
        ]),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItem() {
    List<String> maps = ['KMUTT Map', 'Exhibition Map'];
    return maps
        .map((value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            ))
        .toList();
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }
}
