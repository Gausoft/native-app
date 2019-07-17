import 'package:gentlestudent/src/models/enums/category.dart';
import 'package:gentlestudent/src/models/enums/difficulty.dart';
import 'package:gentlestudent/src/models/enums/status.dart';
import 'package:gentlestudent/src/models/opportunity.dart';
import 'package:gentlestudent/src/models/participation.dart';
import 'package:gentlestudent/src/utils/date_utils.dart';

class StringUtils {
  static String getCategory(Opportunity opportunity) {
    switch (opportunity.category) {
      case Category.DIGITALEGELETTERDHEID:
        return "Digitale geletterdheid";
      case Category.DUURZAAMHEID:
        return "Duurzaamheid";
      case Category.ONDERNEMINGSZIN:
        return "Ondernemingszin";
      case Category.ONDERZOEK:
        return "Onderzoek";
      case Category.WERELDBURGERSCHAP:
        return "Wereldburgerschap";
    }
    return "Algemeen";
  }

  static Category getCategoryEnum(String category) {
    Category value;
    switch (category) {
      case "Digitale geletterdheid":
        value = Category.DIGITALEGELETTERDHEID;
        break;
      case "Duurzaamheid":
        value = Category.DUURZAAMHEID;
        break;
      case "Ondernemingszin":
        value = Category.ONDERNEMINGSZIN;
        break;
      case "Onderzoek":
        value = Category.ONDERZOEK;
        break;
      case "Wereldburgerschap":
        value = Category.WERELDBURGERSCHAP;
        break;
    }
    return value;
  }

  static String getDifficulty(Opportunity opportunity) {
    switch (opportunity.difficulty) {
      case Difficulty.BEGINNER:
        return "Niveau 1";
      case Difficulty.INTERMEDIATE:
        return "Niveau 2";
      case Difficulty.EXPERT:
        return "Niveau 3";
    }
    return "Niveau 0";
  }

  static Difficulty getDifficultyEnum(String difficulty) {
    switch (difficulty) {
      case "Beginner":
        return Difficulty.BEGINNER;
      case "Intermediate":
        return Difficulty.INTERMEDIATE;
      case "Expert":
        return Difficulty.EXPERT;
    }
    return Difficulty.EXPERT;
  }

  static String getFormattedCreationDate(
    DateTime issuedOn, [
    bool isBadge = true,
  ]) =>
      isBadge
          ? DateTime.parse("2000-01-01") == issuedOn
              ? "De issuer van deze leerkans heeft de badge nog niet aan jou toegekend."
              : "Je hebt deze badge behaald op ${DateUtils.formatDate(issuedOn)}."
          : "Je hebt deze token behaald op ${DateUtils.formatDate(issuedOn)}.";

  static String getStatus(Participation participation) {
    switch (participation?.status) {
      case Status.PENDING:
        return "In afwachting";
      case Status.APPROVED:
        return "Goedgekeurd";
      case Status.REFUSED:
        return "Geweigerd";
      case Status.ACCOMPLISHED:
        return "Voltooid";
    }
    return "Onbekend";
  }

  static String getReason(Participation participation) =>
      participation == null || participation.status != Status.REFUSED
          ? ""
          : "Reden: ${participation.reason}";
}
