import 'package:cloud_firestore/cloud_firestore.dart';

class QuestTaker {
  final String questTakerId;
  final String questId;
  final String participantId;
  final String participantName;
  final bool isDoingQuest;
  final Timestamp participatedOn;

  QuestTaker({
    this.questTakerId,
    this.questId,
    this.participantId,
    this.participantName,
    this.isDoingQuest,
    this.participatedOn,
  });

  factory QuestTaker.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data;

    return QuestTaker(
      questTakerId: snapshot.documentID,
      questId: data['questId'],
      participantId: data['participantId'],
      participantName: data['participantName'],
      isDoingQuest: data['isDoingQuest'],
      participatedOn: data['participatedOn'],
    );
  }
}
