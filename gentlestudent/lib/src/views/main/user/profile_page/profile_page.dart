import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/participant_bloc.dart';
import 'package:gentlestudent/src/models/participant.dart';
import 'package:gentlestudent/src/views/authentication/widgets/app_bar.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _participantBloc = Provider.of<ParticipantBloc>(context);
    double headerHeight = MediaQuery.of(context).size.height / 3.5;

    return Scaffold(
      appBar: appBar("Profiel"),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: _participantBloc.participant,
            builder:
                (BuildContext context, AsyncSnapshot<Participant> snapshot) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  profileHeader(snapshot.data, headerHeight, context),
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(24),
                        width: double.infinity,
                        child: Column(
                          children: <Widget>[
                            profileLabel("E-mailadres:", context),
                            SizedBox(height: 4),
                            profileField(snapshot.data?.email ?? "", context),
                            SizedBox(height: 12),
                            profileLabel("Onderwijsinstelling:", context),
                            SizedBox(height: 4),
                            profileField(snapshot.data?.institute ?? "", context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget profileHeader(Participant participant, double headerHeight, BuildContext context) =>
      Container(
        width: double.infinity,
        color: Theme.of(context).brightness == Brightness.dark ? Colors.black26 : Colors.lightBlueAccent,
        height: headerHeight,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            profilePicture(participant, headerHeight),
            participantName(participant),
          ],
        ),
      );

  Widget profilePicture(Participant participant, double headerHeight) =>
      Container(
        child: participant != null &&
                participant.profilePicture != null &&
                participant.profilePicture != ""
            ? Container(
                width: headerHeight / 1.35,
                height: headerHeight / 1.35,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      participant.profilePicture,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(360),
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                ),
              )
            : Icon(
                Icons.account_circle,
                size: headerHeight / 1.25,
                color: Colors.white,
              ),
      );

  Widget participantName(Participant participant) => Text(
        participant?.name ?? "",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 24,
        ),
      );

  Widget profileLabel(String text, BuildContext context) => Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black45,
        ),
      );

  Widget profileField(String text, BuildContext context) => Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.black38,
        ),
      );
}
