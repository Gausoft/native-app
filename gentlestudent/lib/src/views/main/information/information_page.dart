import 'package:flutter/material.dart';
import 'package:gentlestudent/src/constants/color_constants.dart';
import 'package:gentlestudent/src/constants/string_constants.dart';
import 'package:gentlestudent/src/utils/web_launcher_utils.dart';
import 'package:gentlestudent/src/views/authentication/widgets/app_bar.dart';
import 'package:gentlestudent/src/views/main/information/news/news_page.dart';
import 'package:gentlestudent/src/views/main/information/tutorial/tutorial_page.dart';

class InformationPage extends StatelessWidget {
  void _navigateToTutorialPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            TutorialPage(shouldGoToMainScreen: false),
      ),
    );
  }

  void _navigateToNewsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => NewsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("Informatie"),
      body: Column(
        children: <Widget>[
          informationListTile(
            "Website",
            () => WebLauncherUtils.launchURL(linkGentlestudentWebsite),
            context,
          ),
          informationListTile(
            "Over ons",
            () => WebLauncherUtils.launchURL(linkGentlestudentAboutUs),
            context,
          ),
          informationListTile(
            "Tutorial",
            () => _navigateToTutorialPage(context),
            context,
          ),
          informationListTile(
            "Nieuws",
            () => _navigateToNewsPage(context),
            context,
          ),
          informationListTile(
            "Privacybeleid & voorwaarden",
            () => WebLauncherUtils.launchURL(linkGentlestudentPrivacyPolicy),
            context,
          ),
        ],
      ),
    );
  }

  Widget informationListTile(
          String title, Function onPressed, BuildContext context) =>
      Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black38
                  : primaryTextColor,
            ),
          ),
        ),
        child: ListTile(
          trailing: Icon(Icons.arrow_forward_ios),
          title: Text(title),
          onTap: onPressed,
        ),
      );
}
