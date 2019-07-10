import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/participant_bloc.dart';
import 'package:gentlestudent/src/widgets/loading_spinner.dart';

Future<void> showChangingProfilePictureDialog(
  BuildContext context,
  File image,
  ParticipantBloc bloc,
) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Profielfoto wijzigen"),
        content: FutureBuilder(
          future: bloc.changeProfilePicture(image),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return loadingSpinner();
            }

            return Text(
              snapshot.data
                  ? 'Je profielfoto werd succesvol bijgewerkt! Deze is nu zichtbaar op je profielpagina.'
                  : 'Er ging iets mis bij het bijwerken van je profielfoto. Controleer je internetverbinding en probeer het opnieuw.',
            );
          },
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Sluit',
              style: TextStyle(color: Colors.lightBlue),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
