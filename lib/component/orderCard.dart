import 'package:cs_senior_project/asset/text_style.dart';
import 'package:flutter/material.dart';

class BuildCard extends StatelessWidget {
  final Widget child;
  final VoidCallback onClicked;
  final String headerText;
  final bool canEdit;

  const BuildCard({
    Key key,
    this.headerText,
    this.onClicked,
    @required this.child,
    @required this.canEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  (canEdit == true)
                      ? Container(
                          margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                  headerText,
                                  style: FontCollection.topicBoldTextStyle,
                                ),
                              ),
                              Container(
                                child: TextButton(
                                    onPressed: onClicked,
                                    child: Text(
                                      'แก้ไข',
                                      style: FontCollection.bodyTextStyle,
                                    )),
                              )
                            ],
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            headerText,
                            style: FontCollection.topicBoldTextStyle,
                            textAlign: TextAlign.left,
                          ),
                        ),
                  Container(
                    child: child,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
