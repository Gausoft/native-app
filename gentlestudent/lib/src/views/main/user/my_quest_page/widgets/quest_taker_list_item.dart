import 'package:flutter/material.dart';
import 'package:gentlestudent/src/models/quest_taker.dart';
import 'package:gentlestudent/src/utils/date_utils.dart';
import 'package:gentlestudent/src/views/main/user/quest_page/widgets/quest_logo.dart';

class QuestTakerListItem extends StatelessWidget {
  final QuestTaker questTaker;

  QuestTakerListItem(this.questTaker);

  @override
  Widget build(BuildContext context) {
    final _imageWidth = MediaQuery.of(context).size.width / 5;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(bottom: 8),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => {},
        child: Row(
          children: <Widget>[
            questLogo(_imageWidth),
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
