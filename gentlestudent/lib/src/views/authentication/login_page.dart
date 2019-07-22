import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/login_bloc.dart';
import 'package:gentlestudent/src/views/authentication/registration_page.dart';
import 'package:gentlestudent/src/views/authentication/widgets/app_bar.dart';
import 'package:gentlestudent/src/views/authentication/widgets/secondary_button.dart';
import 'package:gentlestudent/src/views/main/information/tutorial/tutorial_page.dart';

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc _loginBloc;
  bool _isObscured = true;

  void _toggleIsObscured() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  void _navigateToRegistrationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => RegistrationPage(),
      ),
    );
  }

  void _navigateToTutorialPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            TutorialPage(shouldGoToMainScreen: true),
      ),
      (Route<dynamic> route) => false,
    );
  }

  void _showLoginDialog(String title, String text) {
    _loginBloc.signOut();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
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

  void _showResetPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Wachtwoord vergeten"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                  "Voer hieronder je e-mailadres in en druk op de knop 'Verzend' om je wachtwoord te wijzigen."),
              SizedBox(height: 16),
              resetPasswordEmailField(),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Verzend"),
              onPressed: () {
                _loginBloc.forgotPassword();
                Navigator.of(context).pop();
                _showLoginDialog("Wachtwoord vergeten",
                    "Indien het e-mailadres dat je ingevoerd hebt bestaat, werd er een e-mail naar verzonden waarmee je je wachtwoord kunt wijzigen.");
              },
            ),
            FlatButton(
              child: Text("Sluit"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onLoginButtonClick() async {
    final isSucces = await _loginBloc.submit();
    isSucces
        ? await _loginBloc.hasVerifiedEmail()
            ? _navigateToTutorialPage()
            : _showLoginDialog("Er ging iets mis",
                "Je account is nog niet geverifieerd. Er werd een e-mail naar je e-mailadres verzonden waarmee je dit kan doen.")
        : _showLoginDialog("Er ging iets mis",
            "Er ging iets mis bij het inloggen. Zorg ervoor dat je e-mailadres en wachtwoord juist zijn en dat je met het internet verbonden bent.");
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc();
  }

  @override
  void dispose() {
    _loginBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    final logoWidth = query.size.width / 2.2;

    return Scaffold(
      appBar: loginAppBar(),
      body: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                height: logoWidth,
                width: logoWidth,
                child: Center(
                  child: logo(logoWidth),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      emailField(),
                      SizedBox(height: 10),
                      passwordField(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: forgotPasswordButton(),
                      ),
                      SizedBox(height: 20),
                      loginButton(),
                      SizedBox(height: 18),
                      registrationButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loginAppBar() => appBar("Log in");

  Widget logo(double width) => AspectRatio(
        aspectRatio: 1 / 1,
        child: Image.asset(
          'assets/images/logo/gentlestudent_logo.png',
        ),
      );

  Widget emailField() => StreamBuilder(
        stream: _loginBloc.email,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return TextField(
            onChanged: _loginBloc.changeEmail,
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

  Widget resetPasswordEmailField() => StreamBuilder(
        stream: _loginBloc.forgotEmail,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return TextField(
            onChanged: _loginBloc.changeForgotEmail,
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
        stream: _loginBloc.password,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return TextField(
            obscureText: _isObscured,
            onChanged: _loginBloc.changePassword,
            decoration: InputDecoration(
              fillColor: Colors.lightBlue,
              labelText: 'Wachtwoord',
              hintText: '**********',
              errorText: snapshot.error,
              suffixIcon: IconButton(
                icon: _isObscured ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                onPressed: _toggleIsObscured,
              ),
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

  Widget loginButton() => StreamBuilder(
        stream: _loginBloc.isSubmitValid,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshotValid) {
          return StreamBuilder(
            stream: _loginBloc.isLoading,
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
                              "Log in",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                      color: Colors.lightBlueAccent,
                      onPressed: snapshotValid.hasData && snapshotValid.data
                          ? () => _onLoginButtonClick()
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

  Widget registrationButton() => secondaryButton(
      "Geen account? Klik hier!", _navigateToRegistrationPage, context);

  Widget forgotPasswordButton() => secondaryButton(
      "Wachtwoord vergeten?", _showResetPasswordDialog, context);
}
