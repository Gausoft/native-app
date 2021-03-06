import 'package:flutter/material.dart';
import 'package:gentlestudent/src/models/quest.dart';
import 'package:gentlestudent/src/utils/date_utils.dart';
import 'package:gentlestudent/src/utils/string_utils.dart';
import 'package:gentlestudent/src/utils/web_launcher_utils.dart';

Widget questInfoBox(Quest quest, [bool isQuestTaker = true]) => Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.lightBlue),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: isQuestTaker
              ? <Widget>[
                  questCreated(quest),
                  SizedBox(height: 8),
                  questStatusField(quest),
                ]
              : <Widget>[
                  questGiver(quest),
                  SizedBox(height: 8),
                  questCreated(quest),
                  SizedBox(height: 8),
                  questEmail(quest),
                ],
        ),
      ),
    );

Widget questCreated(Quest quest) => Row(
      children: <Widget>[
        Text(
          "Aangemaakt op: ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.lightBlue,
          ),
        ),
        Expanded(
          child: Text(
            "${DateUtils.formatDate(quest.created.toDate())} om ${DateUtils.formatTime(quest.created.toDate())}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.lightBlue,
            ),
          ),
        ),
      ],
    );

Widget questGiver(Quest quest) => Row(
      children: <Widget>[
        Text(
          "Questgever: ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.lightBlue,
          ),
        ),
        Expanded(
          child: Text(
            "${quest.questGiver}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.lightBlue,
            ),
          ),
        ),
      ],
    );

Widget questEmail(Quest quest) => Row(
      children: <Widget>[
        Text(
          "E-mailadres: ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.lightBlue,
          ),
        ),
        Expanded(
          child: quest.emailAddress == ""
              ? Text(
                  "/",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.lightBlue,
                  ),
                )
              : GestureDetector(
                  onTap: () => WebLauncherUtils.sendEmail(
                      quest.emailAddress, "Vraag over quest: '${quest.title}'"),
                  child: Text(
                    "${quest.emailAddress}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.lightBlue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
        ),
      ],
    );

Widget questStatusField(Quest quest) => Row(
      children: <Widget>[
        Text(
          "Status: ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.lightBlue,
          ),
        ),
        Expanded(
          child: Text(
            StringUtils.getQuestStatus(quest),
            style: TextStyle(
              fontSize: 14,
              color: Colors.lightBlue,
            ),
          ),
        ),
      ],
    );
