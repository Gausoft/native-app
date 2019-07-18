import 'package:flutter/material.dart';

Future<void> genericDialog(
  BuildContext context,
  String title,
  String message,
) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Sluit'),
            onPressed: Navigator.of(context).pop,
          ),
        ],
      );
    },
  );
}
