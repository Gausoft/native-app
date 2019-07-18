import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/quest_bloc.dart';
import 'package:gentlestudent/src/models/quest.dart';
import 'package:gentlestudent/src/views/main/user/my_quest_page/create_quest_page/create_quest_page.dart';
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

    return StreamBuilder(
      stream: _questBloc.currentQuestOfUser,
      builder: (BuildContext context, AsyncSnapshot<Quest> snapshot) {
        return Scaffold(
          appBar: myQuestPageAppbar(snapshot, context),
          body: Container(
            padding: EdgeInsets.all(24),
            child: !snapshot.hasData
                ? loadingSpinner()
                : snapshot.data.questId == null || snapshot.data.questId == ""
                    ? noQuestBody()
                    : Center(
                        child: Text("Jeej er is een quest van jou"),
                      ),
          ),
        );
      },
    );
  }

  Widget myQuestPageAppbar(AsyncSnapshot<Quest> snapshot, BuildContext context) => AppBar(
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
                )
              ]
            : <Widget>[],
      );

  Widget noQuestBody() => Center(
        child: Text(
          "Je hebt momenteel geen actieve quest. Als je er een quest wilt aanmaken, kan je op het '+' icoontje rechtsbovenaan klikken",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      );
}
