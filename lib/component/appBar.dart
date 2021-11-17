import 'package:auto_size_text/auto_size_text.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/notifiers/location_notifer.dart';
import 'package:cs_senior_project/notifiers/user_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoundedAppBar extends StatefulWidget implements PreferredSizeWidget {
  RoundedAppBar({
    Key key,
    this.appBarTitle,
  })  : preferredSize = Size.fromHeight(80),
        super(key: key);

  final Size preferredSize;
  final String appBarTitle;

  @override
  _RoundedAppBarState createState() => _RoundedAppBarState();
}

class _RoundedAppBarState extends State<RoundedAppBar> {
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
        child: AppBar(
          title: Text(widget.appBarTitle),
          toolbarHeight: 100,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF2954E), Color(0xFFFAD161)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          elevation: 10,
          titleSpacing: 20,
        ),
      );
// {
//   return
// }
}

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  HomeAppBar({Key key, this.onclicked})
      : preferredSize = Size.fromHeight(100),
        super(key: key);

  final Size preferredSize;
  final VoidCallback onclicked;

  @override
  _HomeAppBarState createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    LocationNotifier location = Provider.of<LocationNotifier>(context);
    UserNotifier user = Provider.of<UserNotifier>(context);

    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(30),
      ),
      child: AppBar(
        title: GestureDetector(
          onTap: widget.onclicked,
          child: Container(
            child: Row(
              children: [
                Icon(Icons.location_on),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    child: user.userModel.selectedAddress['address'] != null
                        ? AutoSizeText(
                            'Deliver to : \n' +
                                (user.userModel.selectedAddress['address'] != ''
                                    ? user.userModel.selectedAddress['address']
                                    : location.currentAddress ?? 'loading...'),
                            style: FontCollection.bodyTextStyle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        : SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: widget.onclicked,
            icon: Icon(Icons.navigate_next_outlined),
          ),
        ],
        toolbarHeight: 100,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF2954E), Color(0xFFFAD161)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 10,
        titleSpacing: 20,
        automaticallyImplyLeading: false,
      ),
    );
  }
}
