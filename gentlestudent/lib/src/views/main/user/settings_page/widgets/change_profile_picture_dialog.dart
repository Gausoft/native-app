import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/participant_bloc.dart';
import 'package:image_picker/image_picker.dart';

Future<ImageSource> showChangeProfilePictureDialog(
  BuildContext context,
  ParticipantBloc bloc,
) async {
  return showDialog<ImageSource>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Profielfoto wijzigen"),
        content: Text(
          'Wil je de camera gebruiken om een nieuwe foto maken of wil je een bestaande foto uit je gallerij gebruiken?',
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Camera',
              style: TextStyle(color: Colors.lightBlue),
            ),
            onPressed: () => Navigator.of(context).pop(ImageSource.camera),
          ),
          FlatButton(
            child: Text(
              'Gallerij',
              style: TextStyle(color: Colors.lightBlue),
            ),
            onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
          ),
        ],
      );
    },
  );
}
