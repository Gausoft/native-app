import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gentlestudent/src/models/opportunity.dart';

class OpportunityApi {
  Future<List<Opportunity>> getAllOpportunities() async {
    return (await Firestore.instance
            .collection('Opportunities')
            .where("authority", isEqualTo: 1)
            .getDocuments())
        .documents
        .map((snapshot) => Opportunity.fromDocumentSnapshot(snapshot))
        .toList();
  }

  Future<Opportunity> getOpportunityById(String opportunityId) async {
    return Opportunity.fromDocumentSnapshot(await Firestore.instance
        .collection("Opportunities")
        .document(opportunityId)
        .get());
  }

  Future<Opportunity> getOpportunityByBeaconId(String beaconId) async {
    return Opportunity.fromDocumentSnapshot((await Firestore.instance
            .collection("Opportunities")
            .where("beaconId", isEqualTo: beaconId)
            .getDocuments())
        .documents
        .first);
  }

  Future<Opportunity> getOpportunityByBadgeId(String badgeId) async {
    return Opportunity.fromDocumentSnapshot((await Firestore.instance
            .collection("Opportunities")
            .where("badgeId", isEqualTo: badgeId)
            .getDocuments())
        .documents
        .first);
  }

  Future<void> updateOpportunityAfterParticipationCreation(
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