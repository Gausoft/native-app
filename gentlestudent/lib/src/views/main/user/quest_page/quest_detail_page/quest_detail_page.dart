import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/quest_bloc.dart';
import 'package:gentlestudent/src/models/enums/quest_status.dart';
import 'package:gentlestudent/src/models/quest.dart';
import 'package:gentlestudent/src/models/quest_taker.dart';
import 'package:gentlestudent/src/views/authentication/widgets/app_bar.dart';
import 'package:gentlestudent/src/views/main/user/quest_page/quest_detail_page/widgets/quest_description.dart';
import 'package:gentlestudent/src/views/main/user/quest_page/quest_detail_page/widgets/quest_enroll_dialog.dart';
import 'package:gentlestudent/src/views/main/user/quest_page/quest_detail_page/widgets/quest_header.dart';
import 'package:gentlestudent/src/views/main/user/quest_page/quest_detail_page/widgets/quest_info_box.dart';
import 'package:gentlestudent/src/views/main/user/quest_page/quest_detail_page/widgets/quest_map.dart';
import 'package:gentlestudent/src/widgets/generic_dialog.dart';
import 'package:provider/provider.dart';

class QuestDetailPage extends StatelessWidget {
  final Quest quest;
  final bool isInProgress;

  QuestDetailPage(this.quest, [this.isInProgress = false]);

  Future<void> _showEnrollInQuestDialog(
    BuildContext context,
    QuestBloc bloc,
  ) async {
    bool willEnroll = await showQuestEnrollDialog(
      context,
      quest,
      'Ben je zeker dat je deze quest durft aan te gaan?',
    );

    if (willEnroll == null || !willEnroll) return;

    bool isSucces = await bloc.enrollInQuest(quest);
    isSucces
        ? genericDialog(context, "Quest inschrijving",
            "Je bent succesvol ingeschreven voor deze quest! Als je gekozen wordt door de questgever zal je een e-mail ontvangen.")
        : genericDialog(context, "Quest inschrijving",
            "Er ging iets mis bij het inschrijven voor de quest. Gelieve het opnieuw te proberen.");
  }

  Future<void> _showDisenrollInQuestDialog(
    BuildContext context,
    QuestBloc bloc,
    QuestTaker questTaker,
  ) async {
    bool willDisenroll = await showQuestEnrollDialog(
      context,
      quest,
      'Ben je zeker dat je je wilt uitschrijven voor deze quest?',
    );

    if (willDisenroll == null || !willDisenroll) return;

    bool isSucces = await bloc.disenrollInQuest(questTaker);
    isSucces
        ? genericDialog(context, "Quest uitschrijving",
            "Je bent succesvol uitgeschreven voor deze quest. Als je je bedenkt kan je je nog steeds terug inschrijven.")
        : genericDialog(context, "Quest uitschrijving",
            "Er ging iets mis bij het uitschrijven voor de quest. Gelieve het opnieuw te proberen.");
  }

  @override
  Widget build(BuildContext context) {
    final _questBloc = Provider.of<QuestBloc>(context);
    final _imageWidth = MediaQuery.of(context).size.width / 8;
    final _mapHeight = MediaQuery.of(context).size.width * 2 / 3;

    return Scaffold(
      appBar: appBar("Quest"),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            questHeader(context, _imageWidth, quest),
            questMap(_mapHeight, context, quest),
            SizedBox(height: 8),
            questInfoBox(quest),
            SizedBox(height: 8),
            questDescription(quest),
            SizedBox(height: 16),
            enrollButton(_questBloc),
          ],
        ),
      ),
    );
  }

  Widget enrollButton(QuestBloc bloc) => StreamBuilder(
        stream: bloc.questsUserIsDoing,
        builder:
            (BuildContext context, AsyncSnapshot<List<QuestTaker>> snapshot) {
          // If the quest is still available.
          if (quest.questStatus == QuestStatus.AVAILABLE) {
            // If the quest is still available and the user hasn't participated yet.
            if (snapshot.hasData) {
              if (!snapshot.data
                  .map((qt) => qt.questId)
                  .toList()
                  .contains(quest.questId)) {
                return questButton(
                  "Ik kan helpen",
                  () => _showEnrollInQuestDialog(context, bloc),
                );
              }
              // If the quest is still available and the user has already participated.
              else {
                QuestTaker questTaker = snapshot.data
                    .firstWhere((qt) => qt.questId == quest.questId);
                return questButton(
                  "Ik kan niet meer helpen",
                  () => _showDisenrollInQuestDialog(context, bloc, questTaker),
                );
              }
            } else {
              return Container(height: 16);
            }
          }

          // If the quest is already in progress.
          else if (quest.questStatus == QuestStatus.INPROGRESS) {
            // If the quest is already in progress available and the user has participated.
            if (snapshot.hasData &&
                snapshot.data
                    .map((qt) => qt.questId)
                    .toList()
                    .contains(quest.questId)) {
              QuestTaker questTaker =
                  snapshot.data.firstWhere((qt) => qt.questId == quest.questId);

              // If the quest giver selected the current user to do the quest.
              if (questTaker.isDoingQuest) {
                return questStatusText(
                    "Gefeliciteerd! De questgever heeft jou gekozen om deze quest uit te voeren. Neem contact met hem/haar op om de quest uit te voeren en een token te krijgen.");
              } else {
                return questStatusText(
                    "Jammer! De questgever heeft jou niet gekozen om deze quest uit te voeren. Misschien kan je iemand anders met iets helpen?");
              }
            }
          }

          return Container(height: 16);
        },
      );

  Widget questButton(String text, Function onPressed) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                color: Colors.lightBlueAccent,
                onPressed: onPressed,
                padding: EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      );

  Widget questStatusText(String text) => Container(
        padding: EdgeInsets.fromLTRB(22, 4, 22, 16),
        child: Text(text),
      );
}
