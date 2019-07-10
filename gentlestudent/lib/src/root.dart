import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/assertion_bloc.dart';
import 'package:gentlestudent/src/blocs/main_navigation_bloc.dart';
import 'package:gentlestudent/src/blocs/opportunity_bloc.dart';
import 'package:gentlestudent/src/blocs/opportunity_navigation_bloc.dart';
import 'package:gentlestudent/src/blocs/participant_bloc.dart';
import 'package:gentlestudent/src/blocs/participation_bloc.dart';
import 'package:gentlestudent/src/views/authentication/login_page.dart';
import 'package:gentlestudent/src/views/main/main_page.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  final bool isSignedIn;

  MyApp({this.isSignedIn});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(builder: (context) => MainNavigationBloc()),
        Provider(builder: (context) => OpportunityNavigationBloc()),
        Provider(builder: (context) => OpportunityBloc()),
        Provider(builder: (context) => ParticipantBloc()),
        Provider(builder: (context) => AssertionBloc()),
        Provider(builder: (context) => ParticipationBloc()),
      ],
      child: DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
          primarySwatch: Colors.lightBlue,
          accentColor: Colors.lightBlue,
          textSelectionHandleColor: Colors.lightBlue,
          fontFamily: 'NeoSansPro',
          brightness: brightness,
        ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            title: 'Gentlestudent',
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: isSignedIn ? MainPage() : LoginPage(),
          );
        },
      ),
    );
  }
}
