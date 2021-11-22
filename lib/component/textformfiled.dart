import 'package:cs_senior_project/asset/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// class BuildTextField extends StatefulWidget {
//   BuildTextField({
//     Key key,
//     @required this.labelText,
//     @required this.textEditingController,
//     @required this.hintText,
//     this.errorText,
//     this.validator,
//     this.textInputType,
//     this.obscureText = false,
//     this.maxLength,
//     this.maxLine,
//   }) : super(key: key);
//
//   final String labelText;
//   final TextEditingController textEditingController;
//   final String hintText;
//   final String errorText;
//   final String Function(String) validator;
//   final TextInputType textInputType;
//   final bool obscureText;
//   final int maxLength;
//   final int maxLine;
//
//   @override
//   _BuildTextFieldState createState() => _BuildTextFieldState();
// }
//
// class _BuildTextFieldState extends State<BuildTextField> {
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       decoration: InputDecoration(
//         labelText: widget.labelText,
//         fillColor: CollectionsColors.orange,
//         errorText: widget.errorText,
//         hintText: widget.hintText,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(
//             color: CollectionsColors.orange,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: CollectionsColors.orange, width: 2.0),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: CollectionsColors.red, width: 2.0),
//         ),
//       ),
//       keyboardType: widget.textInputType,
//       validator: widget.validator,
//       obscureText: widget.obscureText,
//       maxLength: widget.maxLength,
//       maxLines: widget.maxLine,
//     );
//   }
// }

class BuildTextField extends StatelessWidget {
  BuildTextField({
    Key key,
    @required this.labelText,
    @required this.hintText,
    this.textEditingController,
    this.initialValue,
    this.errorText,
    this.validator,
    this.textInputType,
    this.obscureText = false,
    this.maxLength,
    this.maxLine,
    this.onChanged,
  }) : super(key: key);

  final String labelText;
  final TextEditingController textEditingController;
  final String hintText;
  final String initialValue;
  final String errorText;
  final String Function(String) validator;
  final TextInputType textInputType;
  final bool obscureText;
  final int maxLength;
  final int maxLine;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        fillColor: CollectionsColors.orange,
        errorText: errorText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: CollectionsColors.orange,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: CollectionsColors.orange, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: CollectionsColors.red, width: 2.0),
        ),
      ),
      keyboardType: textInputType,
      initialValue: initialValue,
      validator: validator,
      obscureText: obscureText,
      maxLength: maxLength,
      maxLines: maxLine,
      onChanged: onChanged,
    );
  }
}

class BuildPasswordField extends StatefulWidget {
  const BuildPasswordField({
    Key key,
    @required this.labelText,
    @required this.textEditingController,
    @required this.hintText,
    this.errorText,
    this.validator,
  }) : super(key: key);

  final String labelText;
  final TextEditingController textEditingController;
  final String hintText;
  final String errorText;
  final String Function(String) validator;

  @override
  _BuildPasswordFieldState createState() => _BuildPasswordFieldState();
}

class _BuildPasswordFieldState extends State<BuildPasswordField> {
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      obscureText: isHidden,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        focusColor: CollectionsColors.orange,
        hoverColor: CollectionsColors.orange,
        fillColor: CollectionsColors.orange,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: CollectionsColors.orange,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: CollectionsColors.orange, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: CollectionsColors.red, width: 2.0),
        ),
        suffixIcon: IconButton(
          icon: isHidden ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
          disabledColor: Colors.grey,
          focusColor: CollectionsColors.orange,
          color: Colors.black.withOpacity(0.6),
          onPressed: togglePasswordVisibility,
        ),
      ),
      keyboardType: TextInputType.visiblePassword,
      autofillHints: [AutofillHints.password],
      onEditingComplete: () => TextInput.finishAutofillContext(),
    );
  }

  void togglePasswordVisibility() => setState(() => isHidden = !isHidden);
}
