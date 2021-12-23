import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:flutter/material.dart';

class ShowDateTime extends StatelessWidget {
  ShowDateTime(
      {Key key,
      @required this.icon,
      @required this.text,
      @required this.onClicked})
      : super(key: key);

  final IconData icon;
  final String text;
  final VoidCallback onClicked;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClicked,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            border: Border.all(
              color: CollectionsColors.orange,
              width: 2,
            ),
            borderRadius: BorderRadius.all(
                Radius.circular(10.0)
                ),
            boxShadow: [
              BoxShadow(blurRadius: 3, color: Colors.black26, offset: Offset(1, 1))
            ],
          color: CollectionsColors.white,
        ),
        child: Row(
          children: [
            Icon(icon),
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                text,
                style: FontCollection.bodyTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
