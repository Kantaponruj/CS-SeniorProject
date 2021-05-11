import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_map_stores/notifiers/store_notifier.dart';
import 'package:google_map_stores/screens/selectMap.dart';
import 'package:google_map_stores/services/store_service.dart';
import 'package:google_map_stores/widgets/mapWidget.dart';
import 'package:google_map_stores/widgets/storeListWidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key key, this.uid}) : super(key: key);
  final String uid;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User currentUser;

  final Completer<GoogleMapController> _mapController = Completer();

  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser;
  }

  @override
  void initState() {
    this.getCurrentUser();
    StoreNotifier storeNotifier =
        Provider.of<StoreNotifier>(context, listen: false);
    getStores(storeNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome"),
        ),
        body: Container(
            child: Column(children: [
          Flexible(flex: 2, child: MapWidget(mapController: _mapController)),
          SizedBox(height: 12),
          Flexible(
              flex: 2, child: StoreListWidget(mapController: _mapController)),
          SizedBox(height: 12),
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectMap(uid: currentUser.uid)));
            },
            label: Text('Get Current Location'),
            icon: Icon(Icons.directions_boat),
          )
        ])));
  }
}
