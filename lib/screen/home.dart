import 'dart:ui';
import 'package:aboutlx/component/DataSearch.dart';
import 'package:aboutlx/component/drawer.dart';
import 'package:aboutlx/models/JoinedEvent.dart';
import 'package:aboutlx/models/event.dart';
import 'package:aboutlx/models/user.dart';
import 'package:aboutlx/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aboutlx/component/text_style.dart';
import 'package:aboutlx/models/exhibition.dart';
import 'package:aboutlx/component/ExhibitionPageView.dart';
import 'package:aboutlx/component/eventListview.dart';
import 'package:aboutlx/services/databaseService.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  User user;
  Home({this.user});
  @override
  _homeState createState() => _homeState(user: user);
}

class _homeState extends State<Home> {
  final AuthService _auth = AuthService();
  User user;

  _homeState({this.user});
  @override
  void initState() {
    super.initState();
    print("Intit state start here");
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Exhibition>>(
          create: (ctx) => DatabaseService().exhibitions,
        ),
        StreamProvider<List<JoinedEvent>>(
          create: (ctx) => DatabaseService(uid: user.uid).joinedEvent,
        ),
        StreamProvider<List<Event>>(
          create: (ctx) => DatabaseService().events,
        )
      ],
      child: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime currentDate;
  Icon searchIcon = Icon(Icons.search);
  Widget searchInput = Text("");
  final controller = PageController(
    initialPage: 0,
  );
  int p = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentDate = DateTime.now();
    currentDate =
        DateTime.parse(currentDate.toString().substring(0, 10) + " 00:00:00");
  }

  @override
  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context);
    final exhibitions = Provider.of<List<Exhibition>>(context);
    final joinedEvents = Provider.of<List<JoinedEvent>>(context);
    final events = Provider.of<List<Event>>(context);
    print(exhibitions.length);
    for (int i = 0; i < exhibitions.length; i++) {
      exhibitions[i].setEvents(events);
    }
    String date = exhibitions[p].monthInName() +
        ", " +
        exhibitions[p].date.year.toString();
    final user = Provider.of<User>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
//          title: searchInput,
          iconTheme: new IconThemeData(color: Color.fromRGBO(189, 189, 189, 1)),

          actions: <Widget>[
            IconButton(
              onPressed: () {
                setState(() {
                  showSearch(
                      context: context,
                      delegate: DataSearch(
                          events: events,
                          exhibitions: exhibitions,
                          currentDate: currentDate,
                          joinedEvent: joinedEvents));
//                  if(this.searchIcon.icon == Icons.search)
//                  {
//                    this.searchIcon = Icon(Icons.cancel);
//                    this.searchInput = TextField(
//                      cursorColor: Color.fromRGBO(240, 102, 74, 1),
//                      style: TextStyle(fontSize: 16),
//
//                    );
//                  }
//                  else
//                  {
//                    this.searchIcon = Icon(Icons.search);
//                    this.searchInput = Text("");
//                  }
                });
              },
              icon: searchIcon,
            ),
          ],
        ),
        drawer: DrawerMenu(user),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SubTitleText(date),
                    TitleText("What exhibition we have?"),
                  ],
                ),
                margin: EdgeInsets.fromLTRB(30, 10, 0, 0),
              ),
              SizedBox(
                height: deviceData.size.height * 0.40,
                child: PageView.builder(
                  onPageChanged: (index) {
                    setState(() {
                      p = index;
                      print(exhibitions[index].date);
                    });
                  },
                  controller: controller,
                  itemCount: exhibitions.length,
                  itemBuilder: (context, index) {
                    return ExhibitionPageView(exhibitions[index], deviceData);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SubTitleText("Event of this exhibition"),
                    TitleText(exhibitions[p].monthInName() +
                        " " +
                        exhibitions[p].date.day.toString() +
                        ", " +
                        exhibitions[p].date.year.toString()),
                  ],
                ),
              ),
              Expanded(child: EventListView(exhibitions[p], deviceData)),
            ],
          ),
        ));
  }
}
