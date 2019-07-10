import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';

PageViewModel tutorialPageViewModel(
  Color color,
  String iconLink,
  String imageLink,
  String text,
  String title,
  double width,
  double height,
) =>
    PageViewModel(
      pageColor: color,
      iconImageAssetPath: iconLink,
      iconColor: null,
      body: Text(text),
      title: Text(title),
      mainImage: Image.asset(
        imageLink,
        height: height,
        width: width,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(color: Colors.white),
    );
