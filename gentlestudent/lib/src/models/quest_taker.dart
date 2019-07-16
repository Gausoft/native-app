import 'package:cloud_firestore/cloud_firestore.dart';

class QuestTaker {
  final String questTakerId;
  final String questId;
  final String participantId;
  bool isDoingQuest;

  QuestTaker({
    this.questTakerId,
    this.questId,
    this.participantId,
    this.isDoingQuest,
  });

  factory QuestTaker.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data;

    return QuestTaker(
      questTakerId: snapshot.documentID,
      questId: data['questId'],
      participantId: data['participantId'],
      isDoingQuest: data['isDoingQuest'],
    );
  }
}
