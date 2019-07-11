import 'package:flutter/material.dart';
import 'package:gentlestudent/src/models/opportunity.dart';

Future<void> showRegistrationDialog(
    BuildContext context,
    Opportunity opportunity,
    Function onPressed,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(opportunity.title),
          content: Text(
            'Ben je zeker dat je je voor deze leerkans wilt registreren?',
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ja'),
              onPressed: () {
                onPressed();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Neen'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }