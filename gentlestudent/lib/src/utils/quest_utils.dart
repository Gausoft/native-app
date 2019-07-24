import 'package:flutter/material.dart';

class QuestUtils {
  static Image chooseQuestTakerLogo(String questTakerName) {
    if (questTakerName == null || questTakerName == "") return Image.asset("assets/quests/icons/qt_icon_sword.png");
    
    switch (questTakerName.toLowerCase().substring(0, 1) ?? "") {
      case 'a':
      case 'b':
      case 'c':
      case 'd':
      case 'e':
        return Image.asset("assets/quests/icons/qt_icon_sword.png");
      case 'f':
      case 'g':
      case 'h':
      case 'i':
      case 'j':
        return Image.asset("assets/quests/icons/qt_icon_helmet.png");
      case 'k':
      case 'l':
      case 'm':
      case 'n':
      case 'o':
        return Image.asset("assets/quests/icons/qt_icon_shield.png");
      case 'p':
      case 'q':
      case 'r':
      case 's':
      case 't':
        return Image.asset("assets/quests/icons/qt_icon_arrow.png");
      case 'u':
      case 'v':
      case 'w':
      case 'x':
      case 'y':
      case 'z':
        return Image.asset("assets/quests/icons/qt_icon_wizard.png");
      default:
        return Image.asset("assets/quests/icons/qt_icon_sword.png");
    }
  }
}
