import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/quest_bloc.dart';
import 'package:gentlestudent/src/models/quest.dart';
import 'package:gentlestudent/src/views/main/user/quest_page/widgets/quest_list_item.dart';
import 'package:gentlestudent/src/widgets/loading_spinner.dart';
import 'package:provider/provider.dart';

class QuestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _questBloc = Provider.of<QuestBloc>(context);
    _questBloc.fetchQuests();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Quests",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          bottom: TabBar(
            labelColor: Colors.white,
            tabs: <Widget>[
              Tab(text: "Beschikbaar"),
              Tab(text: "Bezig"),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Container(
              child: StreamBuilder(
                stream: _questBloc.availableQuests,
                builder: (BuildContext context, AsyncSnapshot<List<Quest>> snapshot) {
                  if (!snapshot.hasData) {
                    return loadingSpinner();
                  }

                  if (snapshot.data.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child:
                            Text("Er zijn momenteel geen quests beschikbaar"),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, int index) {
                      return QuestListItem(snapshot.data[index]);
                    },
                  );
                },
              ),
            ),

            Container(
              child: StreamBuilder(
                stream: _questBloc.inProgressQuests,
                builder: (BuildContext context, AsyncSnapshot<List<Quest>> snapshot) {
                  if (!snapshot.hasData) {
                    return loadingSpinner();
                  }

                  if (snapshot.data.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child:
                            Text("Er zijn momenteel geen quests bezig"),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, int index) {
                      return QuestListItem(snapshot.data[index], true);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
