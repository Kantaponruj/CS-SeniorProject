import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aboutlx/component/text_style.dart';
import 'package:aboutlx/models/exhibition.dart';
import 'package:aboutlx/screen/exhibitionPage.dart';
import 'package:aboutlx/component/eventListview.dart';

class ExhibitionPageView extends StatelessWidget {
  var deviceData;
  Exhibition exhibition;
  ExhibitionPageView(Exhibition e, var deviceData) {
    exhibition = e;
    this.deviceData = deviceData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {
              MaterialPageRoute exhibitionPageRoute = MaterialPageRoute(
                  builder: (BuildContext context) => exhibitionPage(exhibition,deviceData));
              Navigator.of(context).push(exhibitionPageRoute);
            },
            child: Container(
              margin: EdgeInsets.all(30),
              child: Material(
                  color: Color.fromRGBO(240, 102, 74, 1),
                  borderRadius: BorderRadius.circular(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Container(
                          width: deviceData.size.width,
                          height: deviceData.size.height*0.35-60,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(exhibition.pic),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          height: deviceData.size.height*0.05,
                          child: WhiteTitleText(
                            exhibition.name,
                          )),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
