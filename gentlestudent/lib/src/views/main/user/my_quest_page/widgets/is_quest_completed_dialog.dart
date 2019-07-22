import 'package:flutter/material.dart';

Future<bool> showIsQuestCompletedDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Quest voltooien"),
        content: Text(
            "Ben je zeker dat je goed geholpen bent en dat de quest voltooid is?"),
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
