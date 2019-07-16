import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gentlestudent/src/blocs/quest_bloc.dart';
import 'package:gentlestudent/src/models/quest.dart';
import 'package:gentlestudent/src/models/quest_taker.dart';
import 'package:provider/provider.dart';

class QuestListItem extends StatelessWidget {
  final Quest quest;
  final bool isInProgress;

  QuestListItem(this.quest, [this.isInProgress = false]);

  @override
  Widget build(BuildContext context) {
    final _questBloc = Provider.of<QuestBloc>(context);

    return Card(
      margin: EdgeInsets.only(bottom: 8),
      elevation: 3,
      child: InkWell(
        onTap: () {},
        child: Row(
          children: <Widget>[
            Icon(FontAwesomeIcons.questionCircle),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 6, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    questTitle(context),
                    SizedBox(height: 4),
                    questSubtitle(_questBloc),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget questTitle(BuildContext context) => Text(
        quest.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black54,
          fontSize: 21,
        ),
        textAlign: TextAlign.start,
      );

  Widget questSubtitle(QuestBloc bloc) => !isInProgress
      ? Text(
          quest.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        )
      : FutureBuilder(
          future: bloc.fetchQuestTakerByQuestIdAndParticipantId(quest.questId),
          builder: (BuildContext context, AsyncSnapshot<QuestTaker> snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return Text(
                "Status:",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              );
            }

            return Text(
              snapshot.data.isDoingQuest
                  ? "Status: Goedgekeurd"
                  : "Status: In afwachting",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            );
          },
        );
}
