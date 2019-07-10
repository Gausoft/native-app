import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gentlestudent/src/models/badge.dart';

class BadgeApi {
  Future<List<Badge>> getAllBadges() async {
    return (await Firestore.instance.collection('Badges').getDocuments())
        .documents
        .map((snapshot) => Badge.fromDocumentSnapshot(snapshot))
        .toList();
  }

  Future<Badge> getBadgeById(String badgeId) async {
    return Badge.fromDocumentSnapshot(
        await Firestore.instance.collection("Badges").document(badgeId).get());
  }
}
