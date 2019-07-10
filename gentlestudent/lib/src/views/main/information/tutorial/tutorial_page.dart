import 'package:flutter/material.dart';
import 'package:gentlestudent/src/constants/color_constants.dart';
import 'package:gentlestudent/src/views/main/information/tutorial/widgets/tutorial_page_view_model.dart';
import 'package:gentlestudent/src/views/main/main_page.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

class TutorialPage extends StatelessWidget {
  final bool shouldGoToMainScreen;

  TutorialPage({this.shouldGoToMainScreen});

  void _navigateToMainPage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => MainPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  final List<PageViewModel> _pages = [
    tutorialPageViewModel(
      firstTutorialBackgroundColor,
      'assets/images/tutorial/bluetooth.png',
      'assets/images/tutorial/bluetooth.png',
      'Zet je bluetooth aan, het verbruikt niet zoveel energie!',
      'Bluetooth',
      400,
      400,
    ),
    tutorialPageViewModel(
      secondTutorialBackgroundColor,
      'assets/images/tutorial/beacon.png',
      'assets/images/tutorial/beacon.png',
      'Scan om te zien of er beacons in de buurt zijn.',
      'Scannen',
      285,
      285,
    ),
    tutorialPageViewModel(
      thirdTutorialBackgroundColor,
      'assets/images/tutorial/challenge.png',
      'assets/images/tutorial/challenge.png',
      'Ga de uitdaging aan!',
      'Uitdaging',
      285,
      285,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => IntroViewsFlutter(
              _pages,
              onTapDoneButton: shouldGoToMainScreen
                  ? () => _navigateToMainPage(context)
                  : Navigator.of(context).pop,
              showSkipButton: true,
              skipText: Text("Overslaan"),
              doneText: Text("Klaar"),
              pageButtonTextStyles: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
      ),
    );
  }
}
