import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gentlestudent/src/views/authentication/widgets/app_bar.dart';
import 'package:gentlestudent/src/views/main/user/backpack_page/backpack_page.dart';
import 'package:gentlestudent/src/views/main/user/favorites_page/favorites_page.dart';
import 'package:gentlestudent/src/views/main/user/my_quest_page/my_quest_page.dart';
import 'package:gentlestudent/src/views/main/user/participations_page/participations_page.dart';
import 'package:gentlestudent/src/views/main/user/profile_page/profile_page.dart';
import 'package:gentlestudent/src/views/main/user/quest_page/quest_page.dart';
import 'package:gentlestudent/src/views/main/user/settings_page/settings_page.dart';

class UserPage extends StatelessWidget {
  void _navigateToOtherPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => page,
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
          gridIconButton(() => _navigateToOtherPage(context, ProfilePage()),
              Icons.account_circle, "Profiel"),
          gridIconButton(() => _navigateToOtherPage(context, BackpackPage()),
              Icons.work, "Backpack"),
          gridIconButton(() => _navigateToOtherPage(context, ParticipationsPage()),
              Icons.school, "Leerkansen"),
          gridIconButton(() => _navigateToOtherPage(context, FavoritesPage()),
              Icons.favorite, "Favorieten"),
          gridIconButton(() => _navigateToOtherPage(context, SettingsPage()),
              Icons.settings, "Instellingen"),
          gridIconButton(() => _navigateToOtherPage(context, QuestPage()),
              FontAwesomeIcons.questionCircle, "Quests"),
          gridIconButton(() => _navigateToOtherPage(context, MyQuestPage()),
              Icons.live_help, "Mijn quest"),
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
