import 'dart:async';

import 'package:cs_senior_project/asset/constant.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/notifiers/user_notifier.dart';
import 'package:cs_senior_project/widgets/tap_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../asset/color.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/widgets/maps_widget.dart';

import 'address/address.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  static final String title = 'Home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _mapController = Completer();
  final double tabBarHeight = 30;
  final panelController = PanelController();

  String query = ' ';

  // static const double heightClosed = 200;
  // static const double fabHeightClosed = heightClosed + 20;
  // double fabHeight = fabHeightClosed;

  @override
  void initState() {
    isFromHomePage = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final initialSizeOpen = 0.3
    // // MediaQuery.of(context).size.height * 0.1
    //     ;
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);

    return SafeArea(
      child: SafeArea(
        child: Scaffold(
          // extendBodyBehindAppBar: true,
          appBar: HomeAppBar(onclicked: () {
            setState(() {
              isFromHomePage = true;
            });
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Address(uid: userNotifier.userModel.uid)));
          },),
          body: Stack(
            // fit: StackFit.expand,
            children: [
              SlidingUpPanel(
                color: Theme.of(context).backgroundColor,
                controller: panelController,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                // maxHeight: MediaQuery.of(context).size.height,
                panelBuilder: (scrollController) => ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  child: buildSlidingPanel(
                    scrollController: scrollController,
                    panelController: panelController,
                  ),
                ),
                body: MapWidget(mapController: _mapController),
              ),
            ],
          ),
        ),
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
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: buildDragHandle(),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: CollectionsColors.orange,
              indicatorWeight: 3,
              tabs: [
                Tab(
                  child: Text('ทั้งหมด'),
                ),
                Tab(child: Text('จัดส่ง')),
                Tab(child: Text('รับเอง')),
              ],
            ),
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

}
