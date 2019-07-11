import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gentlestudent/src/models/opportunity.dart';
import 'package:gentlestudent/src/models/participation.dart';

class ParticipationApi {
  Future<List<Participation>> getAllParticipationsFromUser(
      String userId) async {
    return (await Firestore.instance
            .collection('Participations')
            .where("participantId", isEqualTo: userId)
            .getDocuments())
        .documents
        .map((snapshot) => Participation.fromDocumentSnapshot(snapshot))
        .toList();
  }

  Future<void> updateParticipationAfterBadgeClaim(
      String participationId, String message) async {
    Map<String, dynamic> data = <String, dynamic>{
      "status": 1,
      "message": message,
    };
    await Firestore.instance
        .collection("Participations")
        .document(participationId)
        .updateData(data)
        .whenComplete(() {
      print("Participation updated");
    }).catchError((e) => print(e));
  }

  Future<Participation> getParticipationByOpportunityId(
    FirebaseUser firebaseUser,
    String opportunityId,
  ) async {
    List<DocumentSnapshot> documents = (await Firestore.instance
            .collection('Participations')
            .where("participantId", isEqualTo: firebaseUser.uid)
            .where("opportunityId", isEqualTo: opportunityId)
            .getDocuments())
        .documents;

    return documents == null || documents.isEmpty
        ? Participation()
        : Participation.fromDocumentSnapshot(documents.first);
  }

  Future<void> enrollInOpportunity(
    FirebaseUser user,
    Opportunity opportunity,
  ) async {
    Map<String, dynamic> data = <String, dynamic>{
      "participantId": user.uid,
      "opportunityId": opportunity.opportunityId,
      "status": 0,
      "reason": "",
      "message": "",
    };
    final CollectionReference collection =
        Firestore.instance.collection("Participations");
    collection.add(data).whenComplete(() async {
      await _updateOpportunityAfterParticipationCreation(
          opportunity, opportunity.participations);
      print("Participation added");
    }).catchError((e) => print(e));
  }

  Future<void> _updateOpportunityAfterParticipationCreation(
      Opportunity opportunity, int participations) async {
    Map<String, int> data = <String, int>{
      "participations": participations + 1,
    };
    await Firestore.instance
        .collection("Opportunities")
        .document(opportunity.opportunityId)
        .updateData(data)
        .whenComplete(() {
      print("Opportunity updated");
    }).catchError((e) => print(e));
  }
}
