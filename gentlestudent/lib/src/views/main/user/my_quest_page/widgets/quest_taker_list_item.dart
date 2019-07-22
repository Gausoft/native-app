import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/quest_bloc.dart';
import 'package:gentlestudent/src/models/enums/quest_status.dart';
import 'package:gentlestudent/src/models/quest.dart';
import 'package:gentlestudent/src/models/quest_taker.dart';
import 'package:gentlestudent/src/utils/date_utils.dart';
import 'package:gentlestudent/src/views/main/user/my_quest_page/widgets/select_quest_taker_dialog.dart';
import 'package:gentlestudent/src/views/main/user/quest_page/widgets/quest_logo.dart';
import 'package:gentlestudent/src/widgets/generic_dialog.dart';
import 'package:provider/provider.dart';

class QuestTakerListItem extends StatelessWidget {
  final Quest quest;
  final QuestTaker questTaker;

  QuestTakerListItem(this.quest, this.questTaker);

  Future<void> appointQuestTakerToQuest(
      QuestBloc bloc, BuildContext context) async {
    bool shouldAppointQuestTaker = await showSelectQuestTakerDialog(context,
        "Ben je zeker dat je ${questTaker.participantName} wilt kiezen om de quest uit te voeren?");

    if (shouldAppointQuestTaker == null || !shouldAppointQuestTaker) return;

    bool isSucces = await bloc.appointQuestTakerToQuest(questTaker);

    isSucces
        ? genericDialog(context, "Kandidaat gekozen",
            "Je hebt succesvol ${questTaker.participantName} gekozen om de quest uit te voeren. Deze persoon werd hiervan via mail op de hoogte gebracht.")
        : genericDialog(context, "Kies een kandidaat",
            "Er is een fout opgetreden bij het kiezen van een kandidaat voor het uitvoeren van de quest. Gelieve het later nog eens te proberen.");
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
        onTap: () => quest.questStatus == QuestStatus.AVAILABLE
            ? appointQuestTakerToQuest(_questBloc, context)
            : {},
        child: Row(
          children: <Widget>[
            questLogo(_imageWidth,
                "https://cdn1.iconfinder.com/data/icons/gaming-3-1/128/102-512.png"),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    questTakerName(context),
                    SizedBox(height: 4),
                    questTakerParticipationDate(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget questTakerName(BuildContext context) => Text(
        questTaker.participantName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black54,
          fontSize: 21,
        ),
        textAlign: TextAlign.start,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );

  Widget questTakerParticipationDate() => Text(
        "Ingeschreven op ${DateUtils.formatDate(questTaker.participatedOn.toDate())}\nom ${DateUtils.formatTime(questTaker.participatedOn.toDate())}",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
      );
}
