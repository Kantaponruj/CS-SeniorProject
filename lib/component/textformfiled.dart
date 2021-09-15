import 'package:cs_senior_project/asset/color.dart';
import 'package:flutter/material.dart';

class BuildTextField extends StatefulWidget {
  BuildTextField({Key key, @required this.textEditingController, @required this.hintText, this.errorText}) : super(key: key);

  final TextEditingController textEditingController;
  final String hintText;
  final String errorText;

  @override
  _BuildTextFieldState createState() => _BuildTextFieldState();
}

class _BuildTextFieldState extends State<BuildTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        fillColor: CollectionsColors.orange,
        errorText: widget.errorText,
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: CollectionsColors.orange, ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: CollectionsColors.orange, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: CollectionsColors.red, width: 2.0),
        ),
        // suffixIcon: Icon(
        //   Icons.error,
        // ),
      ),
    );
  }
}
