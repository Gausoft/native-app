import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gentlestudent/src/models/quest.dart';
import 'package:gentlestudent/src/models/quest_taker.dart';

class QuestApi {
  Future<List<Quest>> fetchAllQuests() async {
    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));

    return (await Firestore.instance
            .collection('Quests')
            .where("created", isGreaterThan: Timestamp.fromDate(yesterday))
            .getDocuments())
        .documents
        .map((snapshot) => Quest.fromDocumentSnapshot(snapshot))
        .toList();
  }

  Future<Quest> fetchQuestById(String questId) async {
    return Quest.fromDocumentSnapshot(await Firestore.instance
        .collection("Quests")
        .document(questId)
        .get());
  }

  Future<List<QuestTaker>> fetchQuestTakersByQuestId(String questId) async {
    return (await Firestore.instance
            .collection("QuestTakers")
            .where("questId", isEqualTo: questId)
            .getDocuments())
        .documents
        .map((snapshot) => QuestTaker.fromDocumentSnapshot(snapshot))
        .toList();
  }

  Future<List<QuestTaker>> fetchQuestTakersByUserId(String userId) async {
    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));

    return (await Firestore.instance
            .collection("QuestTakers")
            .where("participantId", isEqualTo: userId)
            .where("acceptedOn", isGreaterThan: Timestamp.fromDate(yesterday))
            .getDocuments())
        .documents
        .map((snapshot) => QuestTaker.fromDocumentSnapshot(snapshot))
        .toList();
  }

  Future<QuestTaker> fetchQuestTakerByQuestIdAndParticipantId(String userId, String questId) async {
    List<QuestTaker> questTakers =  (await Firestore.instance
            .collection("QuestTakers")
            .where("participantId", isEqualTo: userId)
            .where("questId", isEqualTo: questId)
            .getDocuments())
        .documents
        .map((snapshot) => QuestTaker.fromDocumentSnapshot(snapshot))
        .toList();
    
    return questTakers != null && questTakers.isNotEmpty ? questTakers.first : null;
  }
}
