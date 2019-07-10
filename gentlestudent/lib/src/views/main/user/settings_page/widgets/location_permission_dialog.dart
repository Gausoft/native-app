import 'package:flutter/material.dart';

Future<void> showLocationPermissionDialog(BuildContext context) async {
  return showDialog<Null>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Locatie permissie"),
        content: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'De plugin die gebruikt wordt voor de map heeft (voorlopig) geen gebruiker locatie ondersteuning. Je hoeft de permissie tot je locatie momenteel nog niet te geven.',
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Sluit',
              style: TextStyle(
                color: Colors.lightBlue,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
