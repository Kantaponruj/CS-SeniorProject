import 'package:cs_senior_project/asset/color.dart';
import 'package:flutter/material.dart';

Widget locateFAB(BuildContext context) => FloatingActionButton(
  backgroundColor: CollectionsColors.orange,
  child: Icon(
    Icons.gps_fixed,
    color: CollectionsColors.white,
  ),
  onPressed: () {},
);