import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/assertion_bloc.dart';
import 'package:gentlestudent/src/blocs/main_navigation_bloc.dart';
import 'package:gentlestudent/src/blocs/opportunity_navigation_bloc.dart';
import 'package:gentlestudent/src/blocs/participant_bloc.dart';
import 'package:gentlestudent/src/blocs/participation_bloc.dart';
import 'package:gentlestudent/src/blocs/token_bloc.dart';
import 'package:gentlestudent/src/views/authentication/login_page.dart';

Future<void> showSignOutDialog(
  BuildContext context,
  ParticipantBloc participantBloc,
  MainNavigationBloc mainNavigationBloc,
  OpportunityNavigationBloc opportunityNavigationBloc,
  AssertionBloc assertionBloc,
  ParticipationBloc participationBloc,
  TokenBloc tokenBloc,
) async {
  return showDialog<Null>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Afmelden"),
        content: Row(
          children: <Widget>[
            Expanded(
              child: Text('Bent je zeker dat je je wilt afmelden?'),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Ja',
              style: TextStyle(color: Colors.lightBlue),
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              participantBloc.onSignOut();
              mainNavigationBloc.changeCurrentIndex(1);
              opportunityNavigationBloc.changeCurrentIndex(0);
              assertionBloc.onSignOut();
              participationBloc.onSignOut();
              tokenBloc.onSignOut();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage(),
                ),
                (Route<dynamic> route) => false,
              );
            },
          ),
          FlatButton(
            child: Text(
              'Neen',
              style: TextStyle(color: Colors.lightBlue),
            ),
            onPressed: Navigator.of(context).pop,
          ),
        ],
      );
    },
  );
}
