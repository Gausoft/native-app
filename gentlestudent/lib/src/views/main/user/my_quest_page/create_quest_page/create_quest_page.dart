import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/create_quest_bloc.dart';
import 'package:gentlestudent/src/blocs/quest_bloc.dart';
import 'package:gentlestudent/src/models/user_location.dart';
import 'package:gentlestudent/src/views/authentication/widgets/app_bar.dart';
import 'package:gentlestudent/src/widgets/generic_dialog.dart';
import 'package:provider/provider.dart';

class CreateQuestPage extends StatefulWidget {
  @override
  _CreateQuestPageState createState() => _CreateQuestPageState();
}

class _CreateQuestPageState extends State<CreateQuestPage> {
  CreateQuestBloc _createQuestBloc;
  TextEditingController _latitudeController;
  TextEditingController _longitudeController;

  Future<void> _createQuest(QuestBloc bloc) async {
    bool isSucces = await _createQuestBloc.submit();
    bloc.fetchCurrentQuestOfUser();

    if (isSucces) {
      await genericDialog(
          context, "Maak een quest", "De quest werd succesvol aangemaakt!");
      Navigator.of(context).pop();
    } else {
      genericDialog(context, "Maak een quest",
          "Er ging iets mis tijdens het maken van de quest. Gelieve het opnieuw te proberen.");
    }
  }

  @override
  void initState() {
    super.initState();
    _createQuestBloc = CreateQuestBloc();
    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();
  }

  @override
  void dispose() {
    _createQuestBloc?.dispose();
    _latitudeController?.dispose();
    _longitudeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _questBloc = Provider.of<QuestBloc>(context);
    final _userLocation = Provider.of<UserLocation>(context);
    _createQuestBloc.changeLatitude(_userLocation?.latitude ?? null);
    _createQuestBloc.changeLongitude(_userLocation?.longitude ?? null);
    _latitudeController.text = _userLocation?.latitude?.toString() ?? "";
    _longitudeController.text = _userLocation?.longitude?.toString() ?? "";

    return Scaffold(
      appBar: appBar("Maak een quest"),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 10),
              questTitleField(),
              SizedBox(height: 10),
              questDescriptionField(),
              SizedBox(height: 10),
              questEmailField(),
              SizedBox(height: 10),
              questPhoneNumberField(),
              SizedBox(height: 10),
              questLatitudeField(_userLocation?.latitude ?? null),
              SizedBox(height: 10),
              questLongitudeField(_userLocation?.longitude ?? null),
              SizedBox(height: 36),
              createQuestButton(_questBloc),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget questTitleField() => StreamBuilder(
        stream: _createQuestBloc.title,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextField(
            textCapitalization: TextCapitalization.sentences,
            onChanged: _createQuestBloc.changeTitle,
            maxLength: 30,
            decoration: InputDecoration(
              labelText: 'Titel',
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

  Widget questDescriptionField() => StreamBuilder(
        stream: _createQuestBloc.description,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextField(
            textCapitalization: TextCapitalization.sentences,
            onChanged: _createQuestBloc.changeDescription,
            maxLines: 5,
            maxLength: 140,
            decoration: InputDecoration(
              labelText: 'Beschrijving',
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

  Widget questEmailField() => StreamBuilder(
        stream: _createQuestBloc.email,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return TextField(
            onChanged: _createQuestBloc.changeEmail,
            keyboardType: TextInputType.emailAddress,
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

  Widget questPhoneNumberField() => StreamBuilder(
        stream: _createQuestBloc.phone,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextField(
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.phone,
            onChanged: _createQuestBloc.changePhone,
            maxLength: 10,
            decoration: InputDecoration(
              labelText: 'GSM-nummer (zonder spaties)',
              hintText: '0499999999',
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

  Widget questLatitudeField(double latitude) => StreamBuilder(
        stream: _createQuestBloc.latitude,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextField(
            enabled: latitude == null,
            controller: _latitudeController,
            decoration: InputDecoration(
              labelText: 'Latitude',
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

  Widget questLongitudeField(double longitude) => StreamBuilder(
        stream: _createQuestBloc.longitude,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextField(
            enabled: longitude == null,
            controller: _longitudeController,
            decoration: InputDecoration(
              labelText: 'Longitude',
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

  Widget createQuestButton(QuestBloc bloc) => StreamBuilder(
        stream: _createQuestBloc.isSubmitValid,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshotValid) {
          return StreamBuilder(
            stream: _createQuestBloc.isLoading,
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
                              "Maak de quest aan",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                      color: Colors.lightBlueAccent,
                      onPressed: snapshotValid.hasData
                          ? () => _createQuest(bloc)
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
