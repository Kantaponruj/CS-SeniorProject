import 'dart:async';

import 'package:cs_senior_project/widgets/panel_widget.dart';
import 'package:cs_senior_project/widgets/tap_widget.dart';
import 'package:cs_senior_project/widgets/storeListView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../asset/color.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/component/located_FAB.dart';
import 'package:cs_senior_project/widgets/mapsWidget.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';
  static final String title = 'Home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Completer<GoogleMapController> _mapController = Completer();
  final double tabBarHeight = 80;
  final panelController = PanelController();

  String query = ' ';

  // static const double heightClosed = 200;
  // static const double fabHeightClosed = heightClosed + 20;
  // double fabHeight = fabHeightClosed;

  @override
  Widget build(BuildContext context) {
    // final initialSizeOpen = 0.3
    // // MediaQuery.of(context).size.height * 0.1
    //     ;

    return Scaffold(
      appBar: RoundedAppBar(
        appBarTitle: 'Home',
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SlidingUpPanel(
            controller: panelController,
            // maxHeight: MediaQuery.of(context).size.height,
            panelBuilder: (scrollController) => buildSlidingPanel(
              scrollController: scrollController,
              panelController: panelController,
            ),
            body: MapWidget(mapController: _mapController),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          Positioned(
            right: 20,
            bottom: 600,
            child: locateFAB(context),
          ),
        ],
      ),
    );
  }

  // Widget buildSearch() => SearchWidget(
  //   text:query,
  //   hintText: 'Title or Author Name',
  //   // onChanged: searchBook,
  // );

  Widget buildDragHandle() => GestureDetector(
        child: Center(
          child: Container(
            width: 30,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      );

  Widget buildSlidingPanel({
    @required PanelController panelController,
    @required ScrollController scrollController,
  }) =>
      DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: buildTabBar(
            onClicked: panelController.open,
          ),
          body: TabBarView(
            children: [
              TapWidget(scrollController: scrollController, tapName: "all"),
              TapWidget(
                  scrollController: scrollController, tapName: "delivery"),
              TapWidget(scrollController: scrollController, tapName: "pickup"),
            ],
          ),
        ),
      );

  Widget buildTabBar({VoidCallback(), onClicked}) => PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: GestureDetector(
          onTap: onClicked,
          child: AppBar(
            title: buildDragHandle(),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text('ทั้งหมด'),
                ),
                Tab(child: Text('จัดส่ง')),
                Tab(child: Text('รับเอง')),
              ],
            ),
          ),
        ),
      );
}
