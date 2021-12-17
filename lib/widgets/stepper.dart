import 'package:cs_senior_project/asset/color.dart';
import 'package:flutter/material.dart';

class CustomStepper extends StatefulWidget {
  CustomStepper({
    @required this.iconSize,
    @required this.value,
    this.increaseAmount,
    this.decreaseAmount,
  });

  final double iconSize;
  int value;
  Function increaseAmount;
  Function decreaseAmount;

  @override
  _CustomStepperState createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RoundedIconButton(
          icon: Icons.remove,
          iconSize: widget.iconSize,
          onPress: widget.decreaseAmount,
        ),
        Container(
          width: widget.iconSize,
          child: Text(
            '${widget.value}',
            style: TextStyle(
              fontSize: widget.iconSize * 0.8,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        RoundedIconButton(
          icon: Icons.add,
          iconSize: widget.iconSize,
          onPress: widget.increaseAmount,
        ),
      ],
    );
  }
}

class RoundedIconButton extends StatelessWidget {
  RoundedIconButton(
      {@required this.icon, @required this.onPress, @required this.iconSize});

  final IconData icon;
  final Function onPress;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints.tightFor(width: iconSize, height: iconSize),
      elevation: 2.0,
      onPressed: onPress,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(iconSize * 0.8),
      ),
      fillColor: CollectionsColors.white,
      child: Icon(
        icon,
        color: Colors.black,
        size: iconSize * 0.8,
      ),
    );
  }
}
