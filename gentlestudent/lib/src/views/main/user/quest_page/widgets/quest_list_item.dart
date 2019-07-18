import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/quest_bloc.dart';
import 'package:gentlestudent/src/models/quest.dart';
import 'package:gentlestudent/src/models/quest_taker.dart';
import 'package:gentlestudent/src/views/main/user/quest_page/quest_detail_page/quest_detail_page.dart';
import 'package:gentlestudent/src/views/main/user/quest_page/widgets/quest_logo.dart';
import 'package:gentlestudent/src/views/main/user/quest_page/widgets/quest_title.dart';
import 'package:provider/provider.dart';

class QuestListItem extends StatelessWidget {
  final Quest quest;
  final bool isInProgress;

  QuestListItem(this.quest, [this.isInProgress = false]);

  void _navigateToQuestDetailPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => QuestDetailPage(quest),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _questBloc = Provider.of<QuestBloc>(context);
    final _imageWidth = MediaQuery.of(context).size.width / 5;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(bottom: 8),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _navigateToQuestDetailPage(context),
        child: Row(
          children: <Widget>[
            questLogo(_imageWidth),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    questTitle(context, quest),
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
                "Status: ...",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              );
            }

            return Text(
              snapshot.data.isDoingQuest
                  ? "Status: Gekozen"
                  : "Status: Niet gekozen",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            );
          },
        );
}
