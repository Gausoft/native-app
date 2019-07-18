import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/quest_bloc.dart';
import 'package:gentlestudent/src/models/quest.dart';
import 'package:gentlestudent/src/models/quest_taker.dart';
import 'package:gentlestudent/src/views/main/user/my_quest_page/create_quest_page/create_quest_page.dart';
import 'package:gentlestudent/src/views/main/user/my_quest_page/widgets/quest_taker_list_item.dart';
import 'package:gentlestudent/src/views/main/user/quest_page/quest_detail_page/widgets/quest_description.dart';
import 'package:gentlestudent/src/views/main/user/quest_page/quest_detail_page/widgets/quest_header.dart';
import 'package:gentlestudent/src/views/main/user/quest_page/quest_detail_page/widgets/quest_info_box.dart';
import 'package:gentlestudent/src/views/main/user/quest_page/quest_detail_page/widgets/quest_map.dart';
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

  @override
  Widget build(BuildContext context) {
    final _questBloc = Provider.of<QuestBloc>(context);
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
    QuestBloc bloc,
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
            questInfoBox(quest),
            SizedBox(height: 8),
            questDescription(quest),
            SizedBox(height: 16),
            questTakersList(bloc, quest),
          ],
        ),
      );

  Widget questTakersList(QuestBloc bloc, Quest quest) => FutureBuilder(
        future: bloc.fetchQuestTakersByQuestId(quest.questId),
        builder:
            (BuildContext context, AsyncSnapshot<List<QuestTaker>> snapshot) {
          if (!snapshot.hasData) {
            return loadingSpinner();
          }

          if (snapshot.data.isEmpty) {
            return Text("Nog niemand heeft zich ingeschreven.");
          }

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Gebruikers die de quest willen doen:"),
                SizedBox(height: 8),
                ...snapshot.data.map((qt) => QuestTakerListItem(qt)).toList(),
              ],
            ),
          );
        },
      );
}
