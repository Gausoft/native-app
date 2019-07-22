import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/quest_bloc.dart';
import 'package:gentlestudent/src/blocs/token_bloc.dart';
import 'package:gentlestudent/src/models/enums/quest_status.dart';
import 'package:gentlestudent/src/models/quest.dart';
import 'package:gentlestudent/src/models/quest_taker.dart';
import 'package:gentlestudent/src/views/main/user/my_quest_page/create_quest_page/create_quest_page.dart';
import 'package:gentlestudent/src/views/main/user/my_quest_page/widgets/is_quest_completed_dialog.dart';
import 'package:gentlestudent/src/views/main/user/my_quest_page/widgets/quest_taker_list_item.dart';
import 'package:gentlestudent/src/views/main/user/quest_page/quest_detail_page/widgets/quest_description.dart';
import 'package:gentlestudent/src/views/main/user/quest_page/quest_detail_page/widgets/quest_header.dart';
import 'package:gentlestudent/src/views/main/user/quest_page/quest_detail_page/widgets/quest_info_box.dart';
import 'package:gentlestudent/src/views/main/user/quest_page/quest_detail_page/widgets/quest_map.dart';
import 'package:gentlestudent/src/widgets/generic_dialog.dart';
import 'package:gentlestudent/src/widgets/loading_spinner.dart';
import 'package:provider/provider.dart';

class MyQuestPage extends StatelessWidget {
  void _navigateToCreateQuestPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => CreateQuestPage(),
      ),
    );
  }

  Future<void> _finishQuest(QuestBloc questBloc, TokenBloc tokenBloc,
      QuestTaker questTaker, BuildContext context) async {
    bool isCompleted = await showIsQuestCompletedDialog(context);

    if (isCompleted == null || !isCompleted) return;

    bool isSucces = await questBloc.finishQuest();

    if (isSucces) {
      bool didCreateToken = await tokenBloc.createToken(questTaker);
      didCreateToken
          ? await genericDialog(context, "Quest voltooien",
              "De quest is voltooid en ${questTaker.participantName} heeft een token gekregen!")
          : await genericDialog(context, "Quest voltooien",
              "Er ging iets mis tijdens het voltooien van de quest. Gelieve het opnieuw te proberen.");
      await questBloc.fetchCurrentQuestOfUser();
    } else {
      genericDialog(context, "Quest voltooien",
          "Er ging iets mis tijdens het voltooien van de quest. Gelieve het opnieuw te proberen.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final _questBloc = Provider.of<QuestBloc>(context);
    final _tokenBloc = Provider.of<TokenBloc>(context);
    final _imageWidth = MediaQuery.of(context).size.width / 8;
    final _mapHeight = MediaQuery.of(context).size.width * 2 / 3;

    return StreamBuilder(
      stream: _questBloc.currentQuestOfUser,
      builder: (BuildContext context, AsyncSnapshot<Quest> snapshot) {
        return Scaffold(
          appBar: myQuestPageAppbar(snapshot, context),
          body: Container(
            child: !snapshot.hasData
                ? Container(
                    child: loadingSpinner(),
                  )
                : snapshot.data.questId == null || snapshot.data.questId == ""
                    ? noQuestBody()
                    : questBody(
                        _questBloc,
                        _tokenBloc,
                        _imageWidth,
                        _mapHeight,
                        context,
                        snapshot.data,
                      ),
          ),
        );
      },
    );
  }

  Widget myQuestPageAppbar(
    AsyncSnapshot<Quest> snapshot,
    BuildContext context,
  ) =>
      AppBar(
        centerTitle: true,
        title: Text("Mijn quest", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        actions: snapshot.hasData &&
                (snapshot.data.questId == null || snapshot.data.questId == "")
            ? <Widget>[
                IconButton(
                  onPressed: () => _navigateToCreateQuestPage(context),
                  icon: Icon(Icons.add),
                  tooltip: "Maak een quest",
                ),
              ]
            : <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.edit),
                  tooltip: "Bewerk je quest",
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.delete),
                  tooltip: "Verwijder je quest",
                ),
              ],
      );

  Widget noQuestBody() => Container(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Text(
            "Je hebt momenteel geen actieve quest. Als je er een quest wilt aanmaken, kan je op het '+' icoontje rechtsbovenaan klikken",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      );

  Widget questBody(
    QuestBloc questBloc,
    TokenBloc tokenBloc,
    double imageWidth,
    double mapHeight,
    BuildContext context,
    Quest quest,
  ) =>
      SingleChildScrollView(
        child: Column(
          children: <Widget>[
            questHeader(context, imageWidth, quest),
            questMap(mapHeight, context, quest),
            SizedBox(height: 8),
            questInfoBox(quest, true),
            SizedBox(height: 8),
            questDescription(quest),
            SizedBox(height: 16),
            questTakersList(questBloc, tokenBloc, quest),
          ],
        ),
      );

  Widget questTakersList(
          QuestBloc questBloc, TokenBloc tokenBloc, Quest quest) =>
      FutureBuilder(
        future: questBloc.fetchQuestTakersByQuestId(quest.questId),
        builder:
            (BuildContext context, AsyncSnapshot<List<QuestTaker>> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
              child: loadingSpinner(),
            );
          }

          if (snapshot.data.isEmpty) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
              child: Text("Nog niemand heeft zich ingeschreven."),
            );
          }

          if (quest.questStatus == QuestStatus.AVAILABLE) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Gebruikers die de quest willen doen:"),
                  SizedBox(height: 8),
                  ...snapshot.data
                      .map((qt) => QuestTakerListItem(quest, qt))
                      .toList(),
                ],
              ),
            );
          }

          if (quest.questStatus == QuestStatus.INPROGRESS) {
            QuestTaker questTaker =
                snapshot.data?.firstWhere((qt) => qt.isDoingQuest == true) ?? QuestTaker();

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Deze gebruiker koos je om de quest uit te voeren:"),
                  SizedBox(height: 12),
                  QuestTakerListItem(quest, questTaker),
                  SizedBox(height: 8),
                  giveTokenButton(
                    "Voltooi quest",
                    () =>
                        _finishQuest(questBloc, tokenBloc, questTaker, context,),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            );
          }

          return Container(height: 16);
        },
      );

  Widget giveTokenButton(String text, Function onPressed) => Row(
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
      );
}
