// import 'package:aboutlx/screen/KMUTTmap.dart';
import 'package:aboutlx/screen/Testmap.dart';
import 'package:aboutlx/screen/history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/components/search_bar/gf_search_bar.dart';
import 'package:photo_view/photo_view.dart';

class ControllerPhotoViewPage extends StatefulWidget {
  @override
  _ControllerPhotoViewPageState createState() =>
      _ControllerPhotoViewPageState();
}

class _ControllerPhotoViewPageState extends State<ControllerPhotoViewPage> {
  PhotoViewController photoViewController;
  String _selectedMap = null;

  var selected;
  final GlobalKey<FormState> _formkeyValue = new GlobalKey<FormState>();
  List<String> _rooms = <String>['A01', 'A02', 'A03'];

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
    photoViewController = PhotoViewController();
  }

  @override
  void dispose() {
    super.dispose();
    photoViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exhibition Map'),
        actions: <Widget>[
          popupMennuButton(),
        ],
      ),
      body: Stack(children: <Widget>[
        _buildPhotoView(context),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _buildScaleInfo(),
            _buildResetScaleButton(),
            SizedBox(height: 10.0),
            Text(
              'Select Room',
            ),
            // SizedBox(height:5.0),
            // Icon(FontAwesomeIcons.doorOpen,size: 20.0,
            // color: Color.fromRGBO(240, 102, 74, 1),),
            SizedBox(width: 50.0),
            DropdownButton(
              value: _selectedMap,
              items: _dropDownItem2(),
              onChanged: (value) {
                _selectedMap = value;
                switch (value) {
                  case "A01":
                    style:
                    TextStyle(color: Color.fromRGBO(240, 102, 74, 1));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => KMUTTmap()), //event of that room in each day
                    );
                    break;
                  case "A02": 
                    style:
                    TextStyle(color: Color.fromRGBO(240, 102, 74, 1));
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => KMUTTmap()), //event of that room in each day
                    );
                    break;
                }
              },
              // isExpanded: false,
              hint: Text(
                'Choose Room',
                style: TextStyle(color: Color.fromRGBO(240, 102, 74, 1)),
              ),
            ),
            SizedBox(height: 15.0),
            // StreamBuilder<QuerySnapshot>(
            //   stream: Firestore.instance.collection(""),
            // )
          ],
        )
      ]),
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

  List<DropdownMenuItem<String>> _dropDownItem2() {
    List<String> rooms = ['A01','A02','A03','A04','A05'];
    return rooms.map(
            (value) =>
            DropdownMenuItem(
              value: value,
              child: Text(value),
            )
    ).toList();
  }

  PhotoView _buildPhotoView(BuildContext context) {
    return PhotoView(
      controller: photoViewController,
      imageProvider: AssetImage(
        "images/LXFloorPlanwFn2.png",
      ),
      minScale: PhotoViewComputedScale.contained * 0.8,
      maxScale: PhotoViewComputedScale.covered * 2,
      backgroundDecoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
      ),
      loadingChild: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  StreamBuilder<PhotoViewControllerValue> _buildScaleInfo() {
    return StreamBuilder(
      stream: photoViewController.outputStateStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<PhotoViewControllerValue> snapshot,
      ) {
        if (!snapshot.hasData) return Container();
        return Center(
            // child: Text(
            //   'Scale compared to the original: \n${snapshot.data.scale}',
            //   textAlign: TextAlign.center,
            //   style: TextStyle(fontSize: 20),
            // ),
            );
      },
    );
  }

  RaisedButton _buildResetScaleButton() {
    return RaisedButton(
      child: Text('Reset Scale'),
      onPressed: () {
        photoViewController.scale = photoViewController.initial.scale;
      },
    );
  }
}

class ClippedPhotoViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRect(
            child: PhotoView(
              imageProvider: AssetImage(
                "images/LXFloorPlanwFn2.png",
              ),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2,
              enableRotation: true,
              loadingChild: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
