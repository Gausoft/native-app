import 'package:flutter/material.dart';
import 'package:gentlestudent/src/models/quest.dart';

Widget questDescription(Quest quest) => Padding(
      padding: EdgeInsets.only(left: 22, right: 22, top: 12, bottom: 4),
      child: TextField(
        controller: TextEditingController(text: quest.description),
        readOnly: true,
        maxLines: null,
        decoration: null,
        style: TextStyle(fontSize: 14),
      ),
    );
