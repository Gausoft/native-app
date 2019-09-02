import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gentlestudent/src/models/enums/quest_status.dart';
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
    return Quest.fromDocumentSnapshot(
        await Firestore.instance.collection("Quests").document(questId).get());
  }

  Future<Quest> fetchCurrentQuestOfUser(String userId) async {
    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));

    List<Quest> quests = (await Firestore.instance
            .collection('Quests')
            .where("created", isGreaterThan: Timestamp.fromDate(yesterday))
            .where("questGiverId", isEqualTo: userId)
            .getDocuments())
        .documents
        .map((snapshot) => Quest.fromDocumentSnapshot(snapshot))
        .toList();

    Quest quest;

    if (quests
            .where((q) => q.questStatus != QuestStatus.FINISHED)
            .toList()
            .length >
        0) {
      quest = quests.firstWhere((q) => q.questStatus != QuestStatus.FINISHED);
    }

    return quests == null || quests.isEmpty ? null : quest;
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
            .where("participatedOn",
                isGreaterThan: Timestamp.fromDate(yesterday))
            .getDocuments())
        .documents
        .map((snapshot) => QuestTaker.fromDocumentSnapshot(snapshot))
        .toList();
  }

  Future<QuestTaker> fetchQuestTakerByQuestIdAndParticipantId(
      String userId, String questId) async {
    List<QuestTaker> questTakers = (await Firestore.instance
            .collection("QuestTakers")
            .where("participantId", isEqualTo: userId)
            .where("questId", isEqualTo: questId)
            .getDocuments())
        .documents
        .map((snapshot) => QuestTaker.fromDocumentSnapshot(snapshot))
        .toList();

    return questTakers != null && questTakers.isNotEmpty
        ? questTakers.first
        : null;
  }

  Future<void> enrollInQuest(FirebaseUser user, Quest quest) async {
    Map<String, dynamic> data = <String, dynamic>{
      "isDoingQuest": false,
      "questId": quest.questId,
      "participantId": user.uid,
      "participatedOn": Timestamp.now(),
      "participantName": user.displayName,
      "participantEmail": user.email,
    };

    final CollectionReference collection =
        Firestore.instance.collection("QuestTakers");
    collection.add(data).whenComplete(() async {
      final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
        functionName: 'notifyQuestGiver',
      );
      await callable.call(<String, dynamic>{
        "takerName": user.displayName,
        "giverEmail": quest.emailAddress,
        "questTitle": quest.title,
        "giverName": quest.questGiver,
        "questId": quest.questId,
      });
      print("E-mail sent");
    }).catchError((e) => print(e));
  }

  Future<bool> disenrollInQuest(String questTakerId) async {
    QuestTaker questTaker = QuestTaker.fromDocumentSnapshot(await Firestore
        .instance
        .collection("QuestTakers")
        .document(questTakerId)
        .get());

    if (questTaker.isDoingQuest) {
      return false;
    }

    try {
      final CollectionReference collection =
          Firestore.instance.collection("QuestTakers");
      await collection.document(questTakerId).delete();
    } catch (error) {
      return false;
    }

    return true;
  }

  Future<void> createQuest(FirebaseUser user, String title, String description,
      String email, double latitude, double longitude) async {
    Map<String, dynamic> data = <String, dynamic>{
      "created": Timestamp.now(),
      "description": description,
      "emailAddress": email,
      "latitude": latitude,
      "longitude": longitude,
      "questGiver": user.displayName,
      "questGiverId": user.uid,
      "questStatus": 0,
      "title": title,
    };

    final CollectionReference collection =
        Firestore.instance.collection("Quests");
    collection.add(data).catchError((e) => print(e));
  }

  Future<bool> appointQuestTakerToQuest(
      Quest quest, QuestTaker questTaker) async {
    Map<String, dynamic> questData = <String, dynamic>{
      "questStatus": 1,
    };

    Map<String, dynamic> questTakerData = <String, dynamic>{
      "isDoingQuest": true,
    };

    try {
      await Firestore.instance
          .collection("QuestTakers")
          .document(questTaker.questTakerId)
          .updateData(questTakerData);
    } catch (error) {
      return false;
    }

    try {
      await Firestore.instance
          .collection("Quests")
          .document(quest.questId)
          .updateData(questData)
          .whenComplete(() {});
    } catch (error) {
      return false;
    }

    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'notifyQuestTaker',
    );
    await callable.call(<String, dynamic>{
      "giverName": quest.questGiver,
      "giverEmail": quest.emailAddress,
      "takerName": questTaker.participantName,
      "takerEmail": questTaker.participantEmail,
      "questTitle": quest.title,
      "questId": quest.questId,
    });
    print("E-mail sent");

    print(
      "${questTaker.participantName} was selected to do quest with id ${quest.questId}",
    );

    return true;
  }

  Future<void> finishQuest(String questId) async {
    Map<String, dynamic> questData = <String, dynamic>{
      "questStatus": 2,
    };

    await Firestore.instance
        .collection("Quests")
        .document(questId)
        .updateData(questData)
        .catchError((e) => print(e));
  }
}
