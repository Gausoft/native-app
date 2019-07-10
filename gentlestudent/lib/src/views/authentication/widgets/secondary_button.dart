import 'package:flutter/material.dart';

Widget secondaryButton(String text, Function onPressed, BuildContext context) =>
    FlatButton(
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white54
              : Colors.black54,
        ),
      ),
      onPressed: onPressed,
    );
