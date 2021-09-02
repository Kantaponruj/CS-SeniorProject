import 'package:cs_senior_project/asset/text_style.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    @required this.text,
    @required this.onClicked,
    Key key,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 250,
        child: RaisedButton(
          padding: EdgeInsets.all(10),
          color: Color(0xFFFAD161),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: 18),
          ),
          onPressed: onClicked,
        ),

      ),
    );
  }
}

class StadiumButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const StadiumButtonWidget({
    @required this.text,
    @required this.onClicked,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: ElevatedButton(
          onPressed: onClicked,
          style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              primary: Theme.of(context).buttonColor),
          child: Text(
            text,
            style: FontCollection.buttonTextStyle,
          ),
        ),
      ),
    );
  }
}

class StadiumConfirmButtonWidget extends StatelessWidget {
  final String text;
  final String price;
  final VoidCallback onClicked;

  const StadiumConfirmButtonWidget({
    @required this.text,
    @required this.price,
    @required this.onClicked,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: ElevatedButton(
          onPressed: onClicked,
          style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              primary: Theme.of(context).buttonColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: FontCollection.buttonTextStyle,
              ),
              Text(
                price,
                style: FontCollection.buttonTextStyle,
              ),
            ],
          )

        ),
      ),
    );
  }
}

class EditButton extends StatelessWidget {
  EditButton({Key key, @required this.onClicked}) : super(key: key);

  final VoidCallback onClicked;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onClicked,
      child: Text(
        'แก้ไข',
        style: FontCollection.underlineButtonTextStyle,
      ),
    );
  }
}
