import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gentlestudent/src/views/authentication/widgets/app_bar.dart';
import 'package:gentlestudent/src/views/main/user/backpack_page/backpack_page.dart';
import 'package:gentlestudent/src/views/main/user/favorites_page/favorites_page.dart';
import 'package:gentlestudent/src/views/main/user/participations_page/participations_page.dart';
import 'package:gentlestudent/src/views/main/user/profile_page/profile_page.dart';
import 'package:gentlestudent/src/views/main/user/quest_page/quest_page.dart';
import 'package:gentlestudent/src/views/main/user/settings_page/settings_page.dart';

class UserPage extends StatelessWidget {
  void _navigateToSettingsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => SettingsPage(),
      ),
    );
  }

  void _navigateToFavoritesPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => FavoritesPage(),
      ),
    );
  }

  void _navigateToProfilePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ProfilePage(),
      ),
    );
  }

  void _navigateToBackpackPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => BackpackPage(),
      ),
    );
  }

  void _navigateToQuestPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => QuestPage(),
      ),
    );
  }

  void _navigateToParticipationsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ParticipationsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("Gebruiker"),
      body: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 0.95,
        children: [
          gridIconButton(() => _navigateToProfilePage(context), Icons.account_circle, "Profiel"),
          gridIconButton(() => _navigateToBackpackPage(context), Icons.work, "Backpack"),
          gridIconButton(() => _navigateToParticipationsPage(context), Icons.school, "Leerkansen"),
          gridIconButton(() => _navigateToFavoritesPage(context), Icons.favorite, "Favorieten"),
          gridIconButton(() => _navigateToSettingsPage(context), Icons.settings, "Instellingen"),
          gridIconButton(() => _navigateToQuestPage(context), FontAwesomeIcons.questionCircle, "Quests"),
        ],
      ),
    );
  }

  Widget gridIconButton(Function onPressed, IconData icon, String text) =>
      Center(
        child: InkWell(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                color: Colors.lightBlue,
                size: 56,
              ),
              SizedBox(height: 5),
              Center(
                child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
              ),
            ],
          ),
          ),
        ),
      );
}
