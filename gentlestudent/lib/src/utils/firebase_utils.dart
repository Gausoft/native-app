import 'package:gentlestudent/src/models/enums/authority.dart';
import 'package:gentlestudent/src/models/enums/category.dart';
import 'package:gentlestudent/src/models/enums/difficulty.dart';
import 'package:gentlestudent/src/models/enums/quest_status.dart';
import 'package:gentlestudent/src/models/enums/status.dart';

class FirebaseUtils {
  static Difficulty dataToDifficulty(int difficulty) {
    switch (difficulty) {
      case 0:
        return Difficulty.BEGINNER;
      case 1:
        return Difficulty.INTERMEDIATE;
      case 2:
        return Difficulty.EXPERT;
      default:
        return Difficulty.INTERMEDIATE;
    }
  }
  
  static QuestStatus dataToQuestStatus(int questStatus) {
    switch (questStatus) {
      case 0:
        return QuestStatus.AVAILABLE;
      case 1:
        return QuestStatus.INPROGRESS;
      case 2:
        return QuestStatus.FINISHED;
      default:
        return QuestStatus.INPROGRESS;
    }
  }

  static Authority dataToAuthority(int authority) {
    switch (authority) {
      case 0:
        return Authority.BLOCKED;
      case 1:
        return Authority.APPROVED;
      case 2:
        return Authority.DELETED;
    }
    return Authority.APPROVED;
  }

  static Category dataToCategory(int category) {
    switch (category) {
      case 0:
        return Category.DIGITALEGELETTERDHEID;
      case 1:
        return Category.DUURZAAMHEID;
      case 2:
        return Category.ONDERNEMINGSZIN;
      case 3:
        return Category.ONDERZOEK;
      case 4:
        return Category.WERELDBURGERSCHAP;
    }
    return Category.DUURZAAMHEID;
  }

  static Status dataToStatus(int status) {
    switch (status) {
      case 0:
        return Status.PENDING;
      case 1:
        return Status.APPROVED;
      case 2:
        return Status.REFUSED;
      case 3:
        return Status.ACCOMPLISHED;
    }
    return Status.PENDING;
  }
}
