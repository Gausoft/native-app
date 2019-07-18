import 'package:flutter/material.dart';

Future<bool> showSelectQuestTakerDialog(
  BuildContext context,
  String text,
) async {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Kies een kandidaat"),
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