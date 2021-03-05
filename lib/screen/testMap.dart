import 'dart:async';
import 'package:aboutlx/screen/exhibitionMap.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class KMUTTmap extends StatefulWidget {
  @override
  _KMUTTmapState createState() => _KMUTTmapState();
}

class _KMUTTmapState extends State<KMUTTmap> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
  }
    double zoomVal=5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("KMUTT Map"),
        actions: <Widget>[
          IconButton(
            
            icon: Icon(FontAwesomeIcons.search),
            
            onPressed: () {

            }
          ),
          popupMennuButton(),
        ],
      ),
      body: Stack(
        children: <Widget>[
          _googleMap(context),
          _zoomminusfunction(),
          _zoomplusfunction(),
          _buildContainer(),
        ],
      ),
      
    );
  }

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

  List<DropdownMenuItem<String>> _dropDownItem() {
    List<String> maps = ['KMUTT Map', 'Exhibition Map'];
    return maps
        .map((value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            ))
        .toList();
  }

  Widget _zoomminusfunction() {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: Icon(FontAwesomeIcons.searchMinus), 
        onPressed: () {
          zoomVal--;
          _minus(zoomVal);
        }),
    );
  }

  Widget _zoomplusfunction() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: Icon(FontAwesomeIcons.searchPlus), 
        onPressed: () {
          zoomVal++;
          _plus(zoomVal);
        }),
    );
  }

  Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(13.649497, 100.492955), zoom: zoomVal)));
  }

  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(13.649497, 100.492955), zoom: zoomVal)));
  }

  Widget _buildContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 0.0),
        height: 150.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: _boxes(
                13.652557, 100.493620,"School of Information Technology"
              ),
            ),
            SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: _boxes(
                13.652661, 100.493953,"KMUTT Library"
              ),
            ),

          ]
        )
      )
    );
  }

  Widget _boxes(double lat, double long, String buildingName) {
    return GestureDetector(
      onTap: () {
        _gotoLocation(lat,long);
      },
      child: Container(
        child: new FittedBox(
          child: Material(
            color: Colors.white,
            elevation: 14.0,
            borderRadius: BorderRadius.circular(24.0),
            shadowColor: Color(0x802196F3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 0,
                  height: 150,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(24.0),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: myDetailsContainer(buildingName),
                  ),
                ),
              ]
            ),
          ),

        )
      ),
    );
  }

  Widget myDetailsContainer(String buildingName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            child: Text(buildingName,
            
            )
          ),
          ),
          SizedBox(height: 5.0,),
      ],
    );
  }

  Widget _googleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: LatLng(13.649497, 100.492955),zoom: 12),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers:{
          sitMarker,libraryMarker
        },
      )
    );
  }
  Future<void> _gotoLocation(double lat, double long) async{
    final GoogleMapController controller=await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, long), zoom: 15, tilt: 50.0, bearing: 45.0,)));
  }
}

Marker sitMarker=Marker(
  markerId: MarkerId('sit'),
  position: LatLng(13.652557, 100.493620),
  infoWindow: InfoWindow(title: ''),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);

Marker libraryMarker=Marker(
  markerId: MarkerId('library'),
  position: LatLng(13.652661, 100.493953),
  infoWindow: InfoWindow(title: ''),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);