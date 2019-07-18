import 'package:flutter/material.dart';
import 'package:gentlestudent/src/models/quest.dart';
import 'package:gentlestudent/src/views/main/user/quest_page/widgets/quest_logo.dart';
import 'package:gentlestudent/src/views/main/user/quest_page/widgets/quest_title.dart';

Widget questHeader(
  BuildContext context,
  double imageWidth,
  Quest quest,
) =>
    Row(
      children: <Widget>[
        questLogo(imageWidth),
        Padding(
          padding: EdgeInsets.all(10),
          child: questTitle(context, quest),
        )
      ],
    );
