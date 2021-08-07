import 'dart:async';

import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/widgets/button_widget.dart';
import 'package:cs_senior_project/widgets/maps_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectAddress extends StatefulWidget {
  const SelectAddress({Key key}) : super(key: key);

  @override
  _SelectAddressState createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  final Completer<GoogleMapController> _mapController = Completer();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: RoundedAppBar(
          appBarTitle: 'ค้นหาสถานที่',
        ),
        body: MapWidget(mapController: _mapController),
        bottomNavigationBar: Container(
          alignment: Alignment.bottomCenter,
          height: 100,
          margin: EdgeInsets.symmetric(horizontal: 20),
          color: Colors.transparent,
          child: StadiumButtonWidget(
            text: 'เลือกตำแหน่ง',
            onClicked: () {},
          ),
        ),
      ),
    );
  }
}
