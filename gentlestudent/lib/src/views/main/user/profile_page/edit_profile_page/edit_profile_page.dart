import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/edit_profile_bloc.dart';
import 'package:gentlestudent/src/blocs/participant_bloc.dart';
import 'package:gentlestudent/src/models/participant.dart';
import 'package:gentlestudent/src/views/authentication/widgets/app_bar.dart';
import 'package:gentlestudent/src/widgets/generic_dialog.dart';
import 'package:gentlestudent/src/widgets/loading_spinner.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  EditProfileBloc _editProfileBloc;
  TextEditingController _firstnameController;
  TextEditingController _lastnameController;
  TextEditingController _educationController;
  TextEditingController _emailController;

  Future<void> _onEditProfileButtonClick(ParticipantBloc bloc) async {
    bool isFirebaseUserEditSuccess = await _editProfileBloc.submit();

    if (!isFirebaseUserEditSuccess) {
      genericDialog(context, "Profiel bewerken",
          "Er ging iets mis tijdens het bewerken van je profiel. Gelieve het opnieuw te proberen.",);
      return;
    }

    bool isParticipantEditSucces = await bloc.editParticipantProfile(
      "${_firstnameController.text} ${_lastnameController.text}",
      _educationController.text,
      _emailController.text,
    );

    isParticipantEditSucces
        ? genericDialog(context, "Profiel bewerken",
            "Je profiel werd succesvol bijgewerkt!",)
        : genericDialog(context, "Profiel bewerken",
            "Er ging iets mis tijdens het bewerken van je profiel. Gelieve het opnieuw te proberen.",);
  }

  void initTextControllers(ParticipantBloc bloc, Participant participant) {
    _firstnameController.text =
        participant.name.substring(0, participant.name.indexOf(" "));
    _lastnameController.text =
        participant.name.substring(participant.name.indexOf(" ") + 1);
    _educationController.text = participant.institute;
    _emailController.text = participant.email;

    _editProfileBloc.changeFirstName(_firstnameController.text);
    _editProfileBloc.changeLastName(_lastnameController.text);
    _editProfileBloc.changeEducation(_educationController.text);
    _editProfileBloc.changeEmail(_emailController.text);
  }

  @override
  void initState() {
    super.initState();
    _editProfileBloc = EditProfileBloc();
    _firstnameController = TextEditingController();
    _lastnameController = TextEditingController();
    _educationController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _editProfileBloc?.dispose();
    _firstnameController?.dispose();
    _lastnameController?.dispose();
    _educationController?.dispose();
    _emailController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _participantBloc = Provider.of<ParticipantBloc>(context);

    return Scaffold(
      appBar: appBar("Profiel bewerken"),
      body: StreamBuilder(
        stream: _participantBloc.participant,
        builder: (BuildContext context, AsyncSnapshot<Participant> snapshot) {
          if (snapshot.hasData &&
              _firstnameController.text == "" &&
              _lastnameController.text == "" &&
              _educationController.text == "" &&
              _emailController.text == "") {
            initTextControllers(_participantBloc, snapshot.data);
          }

          if (!snapshot.hasData) {
            return loadingSpinner();
          }

          return Container(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 10),
                    firstNameField(),
                    SizedBox(height: 10),
                    lastNameField(),
                    SizedBox(height: 10),
                    educationField(),
                    SizedBox(height: 10),
                    emailField(),
                    SizedBox(height: 36),
                    editProfileButton(_participantBloc),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget firstNameField() => StreamBuilder(
        stream: _editProfileBloc.firstName,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextField(
            textCapitalization: TextCapitalization.words,
            controller: _firstnameController,
            onChanged: _editProfileBloc.changeFirstName,
            decoration: InputDecoration(
              labelText: 'Voornaam',
              errorText: snapshot.error,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      );

  Widget lastNameField() => StreamBuilder(
        stream: _editProfileBloc.lastName,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextField(
            textCapitalization: TextCapitalization.words,
            controller: _lastnameController,
            onChanged: _editProfileBloc.changeLastName,
            decoration: InputDecoration(
              labelText: 'Achternaam',
              errorText: snapshot.error,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      );

  Widget educationField() => StreamBuilder(
        stream: _editProfileBloc.education,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextField(
            textCapitalization: TextCapitalization.sentences,
            controller: _educationController,
            onChanged: _editProfileBloc.changeEducation,
            decoration: InputDecoration(
              labelText: 'Onderwijsinstelling',
              errorText: snapshot.error,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      );

  Widget emailField() => StreamBuilder(
        stream: _editProfileBloc.email,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return TextField(
            onChanged: _editProfileBloc.changeEmail,
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'E-mailadres',
              hintText: 'naam@student.arteveldehs.be',
              errorText: snapshot.error,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      );

  Widget editProfileButton(ParticipantBloc bloc) => StreamBuilder(
        stream: _editProfileBloc.isSubmitValid,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshotValid) {
          return StreamBuilder(
            stream: _editProfileBloc.isLoading,
            initialData: false,
            builder:
                (BuildContext context, AsyncSnapshot<bool> snapshotLoading) {
              return Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      child: snapshotLoading.data
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              "Bewerk je profiel",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                      color: Colors.lightBlueAccent,
                      onPressed: snapshotValid.hasData && snapshotValid.data
                          ? () => _onEditProfileButtonClick(bloc)
                          : null,
                      padding: EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
}
