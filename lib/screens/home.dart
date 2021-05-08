import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map_stores/notifiers/store_notifier.dart';
import 'package:google_map_stores/screens/directionPage.dart';
import 'package:google_map_stores/services/store_service.dart';
import 'package:google_map_stores/widgets/mapWidget.dart';
import 'package:google_map_stores/widgets/storeListWidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    super.initState();
    StoreNotifier storeNotifier =
        Provider.of<StoreNotifier>(context, listen: false);
    getStores(storeNotifier);
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DirectionPage()));
            },
            label: Text('Go to Direction !'),
            icon: Icon(Icons.directions_boat),
          )
        ])));
  }
}
