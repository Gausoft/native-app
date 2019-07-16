import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gentlestudent/src/models/enums/quest_status.dart';

class Quest {
  final String questId;
  final String title;
  final String description;
  QuestStatus questStatus;
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
      questStatus: data['questStatus'],
      questGiverId: data['questGiverId'],
      created: data['createdTimeStamp'],
      phoneNumber: data['phoneNumber'],
      emailAddress: data['emailAddress'],
      latitude: data['latitude'],
      longitude: data['longitude'],
    );
  }
}
