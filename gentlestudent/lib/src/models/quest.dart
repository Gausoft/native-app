import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gentlestudent/src/models/enums/quest_status.dart';
import 'package:gentlestudent/src/utils/firebase_utils.dart';

class Quest {
  final String questId;
  final String title;
  final String description;
  QuestStatus questStatus;
  final String questGiver;
  final String questGiverId;
  final Timestamp created;
  final String phoneNumber;
  final String emailAddress;
  final double latitude;
  final double longitude;

  Quest({
    this.questId,
    this.title,
    this.description,
    this.questStatus,
    this.questGiver,
    this.questGiverId,
    this.created,
    this.phoneNumber,
    this.emailAddress,
    this.latitude,
    this.longitude,
  });

  factory Quest.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data;

    return Quest(
      questId: snapshot.documentID,
      title: data['title'],
      description: data['description'],
      questStatus: FirebaseUtils.dataToQuestStatus(data['questStatus']),
      questGiver: data['questGiver'],
      questGiverId: data['questGiverId'],
      created: data['created'],
      phoneNumber: data['phoneNumber'],
      emailAddress: data['emailAddress'],
      latitude: data['latitude'].runtimeType == double ? data['latitude'] : 0,
      longitude: data['longitude'].runtimeType == double ? data['longitude'] : 0,
    );
  }
}
