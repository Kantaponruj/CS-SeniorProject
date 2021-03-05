import 'package:flutter/material.dart';

class TitleText extends StatelessWidget{
  String text;
  double size=18;
  TitleText(String str){
    text=str;
  }
  TitleText.withSize(String str, double size){
    text=str;
    this.size=size;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Color.fromRGBO(240, 102, 74, 1),
        fontSize: size
      ),
    );
  }
}

class WhiteTitleText extends StatelessWidget{
  String text;
  WhiteTitleText(String str){
    text=str;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.white,
          fontSize: 18
      ),
    );
  }
}

class SubTitleText extends StatelessWidget{
  String text;
  SubTitleText(String str){
    text=str;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: Color.fromRGBO(189, 189, 189, 1),
          fontSize: 15
      ),
    );
  }
}