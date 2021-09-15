import 'package:cs_senior_project/asset/text_style.dart';
import 'package:flutter/material.dart';

class ShowDateTime extends StatelessWidget {
  ShowDateTime({Key key,@required this.icon,@required this.text, @required this.onClicked}) : super(key: key);

  final IconData icon;
  final String text;
  final VoidCallback onClicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Icon(icon),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: ElevatedButton(
              onPressed: onClicked,
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shadowColor: Colors.grey,
              ),
              child: Text(
                text,
                style: FontCollection.bodyTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
