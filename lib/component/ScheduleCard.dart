import 'package:aboutlx/models/JoinedEvent.dart';
import 'package:aboutlx/screen/eventPage.dart';
import 'package:aboutlx/models/exhibition.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class ScheduleCard extends StatelessWidget {

  Exhibition exhibition;

  ScheduleCard({this.exhibition});

  @override
  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context);
    final joinedEvent = Provider.of<List<JoinedEvent>>(context);
    return ListView.builder(
      itemCount: exhibition.events.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder:(context, index) => Container(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ListTile(
                  onTap: (){
                    MaterialPageRoute eventPageRoute = MaterialPageRoute(
                        builder: (BuildContext context) => eventPage(exhibition.events[index],deviceData,exhibition.events[index].getUserJoin(joinedEvent),exhibition.name,false)
                    );
                    Navigator.of(context).push(eventPageRoute);
                  },
//                    leading: GFAvatar(
//                      backgroundImage: NetworkImage(
//                          "https://lh3.googleusercontent.com/proxy/AY_3pA38hgpd8QTPlP0Z3c6dn1Erv355lmiKv7LczIGokhs88SjnbTjZtV8KDqfQsHg8P8KZ_zedxUdYb-lcSxRs1OBgSqYCw_hZdPCyLKs2qbN9aOhoPKhupSeoq4oG0mVhUKT3x4AB"),
//                      shape: GFAvatarShape.square,
//                      size: 50.0,
//                    ),
                  title: Text(exhibition.events[index].name),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(DateFormat.Hm().format(exhibition.events[index].start) + " to " + DateFormat.Hm().format(exhibition.events[index].end))
                    ],
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}
