import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/registration_bloc.dart';
import 'package:gentlestudent/src/views/authentication/widgets/app_bar.dart';
import 'package:gentlestudent/src/views/authentication/widgets/secondary_button.dart';
import 'package:gentlestudent/src/views/main/main_page.dart';

class RegistrationPage extends StatefulWidget {
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  RegistrationBloc _registrationBloc;

  void _navigateToLoginPage() {
    Navigator.of(context).pop();
  }

  Future<void> _onRegistrationButtonClick(BuildContext context) async {
    final isSucces = await _registrationBloc.submit();
    isSucces ? _showSuccesDialog() : _showErrorDialog();
  }

  void _navigateToMainPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => MainPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  void _showSuccesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Account aangemaakt"),
          content: Text(
              "Je account werd succesvol aangemaakt. Welkom bij Gentlestudent!"),
          actions: <Widget>[
            FlatButton(
              child: Text("Ga verder"),
              onPressed: () => _navigateToMainPage(),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Er ging iets mis"),
          content: Text(
              "Er ging iets mis bij het aanmaken van je account. Zorg ervoor dat je verbonden bent met het internet en probeer het opnieuw."),
          actions: <Widget>[
            FlatButton(
              child: Text("Sluit"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _registrationBloc = RegistrationBloc();
  }

  @override
  void dispose() {
    _registrationBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: registrationAppBar(),
      body: Container(
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
                SizedBox(height: 10),
                passwordField(),
                SizedBox(height: 10),
                repeatPasswordField(),
                SizedBox(height: 36),
                registerButton(),
                SizedBox(height: 18),
                loginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget registrationAppBar() => appBar("Registreer");

  Widget firstNameField() => StreamBuilder(
        stream: _registrationBloc.firstName,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextField(
            textCapitalization: TextCapitalization.words,
            onChanged: _registrationBloc.changeFirstName,
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
        stream: _registrationBloc.lastName,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextField(
            textCapitalization: TextCapitalization.words,
            onChanged: _registrationBloc.changeLastName,
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
        stream: _registrationBloc.education,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextField(
            textCapitalization: TextCapitalization.sentences,
            onChanged: _registrationBloc.changeEducation,
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
        stream: _registrationBloc.email,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return TextField(
            onChanged: _registrationBloc.changeEmail,
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

  Widget passwordField() => StreamBuilder(
        stream: _registrationBloc.password,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return TextField(
            obscureText: true,
            onChanged: _registrationBloc.changePassword,
            decoration: InputDecoration(
              fillColor: Colors.lightBlue,
              labelText: 'Wachtwoord',
              hintText: '**********',
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

  Widget repeatPasswordField() => StreamBuilder(
        stream: _registrationBloc.repeatPassword,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return TextField(
            obscureText: true,
            onChanged: _registrationBloc.changeRepeatPassword,
            decoration: InputDecoration(
              fillColor: Colors.lightBlue,
              labelText: 'Herhaal wachtwoord',
              hintText: '**********',
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

  Widget registerButton() => StreamBuilder(
        stream: _registrationBloc.isSubmitValid,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshotValid) {
          return StreamBuilder(
            stream: _registrationBloc.isLoading,
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
                              "Maak je account aan",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                      color: Colors.lightBlueAccent,
                      onPressed: snapshotValid.hasData && snapshotValid.data
                          ? () => _onRegistrationButtonClick(context)
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

  Widget loginButton() =>
      secondaryButton("Al een account? Log hier in!", _navigateToLoginPage, context);
}
