import 'package:flutter/material.dart';
import 'package:gentlestudent/src/models/quest.dart';

Widget questTitle(BuildContext context, Quest quest) => Text(
      quest.title,
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
