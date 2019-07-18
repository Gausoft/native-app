import 'package:flutter/material.dart';
import 'package:gentlestudent/src/models/quest.dart';

Future<bool> showQuestEnrollDialog(
  BuildContext context,
  Quest quest,
  String text,
) async {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(quest.title),
        content: Text(text),
        actions: <Widget>[
          FlatButton(
            child: Text('Ja'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          FlatButton(
            child: Text('Neen'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      );
    },
  );
}
