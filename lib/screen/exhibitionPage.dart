import 'package:flutter/material.dart';
import 'package:aboutlx/models/exhibition.dart';
import 'package:aboutlx/component/text_style.dart';
import 'package:aboutlx/component/eventListview.dart';

class exhibitionPage extends StatefulWidget {
  Exhibition exhibition;
  var deviceData;
  exhibitionPage(this.exhibition,this.deviceData);
  @override
  _exhibitionPageState createState() => _exhibitionPageState(exhibition,deviceData);
}

class _exhibitionPageState extends State<exhibitionPage> {
  Exhibition exhibition;
  var deviceData;
  _exhibitionPageState(this.exhibition,this.deviceData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
//        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text("Exhibition Info"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TitleText.withSize(exhibition.name,20),
                    SubTitleText(exhibition.monthInName() + " " + exhibition.date.day.toString() + ", " + exhibition.date.year.toString()),
                    SizedBox(height: 10,),
                    Text(exhibition.detail),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: deviceData.size.width,
                    height: deviceData.size.height*0.25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(exhibition.pic),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: deviceData.size.height*0.35,
                child: EventListView(exhibition,deviceData)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
