import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gentlestudent/src/models/assertion.dart';

class AssertionApi {
  Future<List<Assertion>> getAllAssertionsFromUser(String participantId) async {
    return (await Firestore.instance
            .collection('Assertions')
            .where("recipientId", isEqualTo: participantId)
            .getDocuments())
        .documents
        .map((snapshot) => Assertion.fromDocumentSnapshot(snapshot))
        .toList();
  }

  Future<void> claimBadge(FirebaseUser user, String badgeId) async {
    Map<String, dynamic> data = <String, dynamic>{
      "badgeId": badgeId,
      "issuedOn": "2000-01-01",
      "recipientId": user.uid,
    };
    final CollectionReference collection =
        Firestore.instance.collection("Assertions");
    collection.add(data).whenComplete(() {
      print("Assertion added");
    }).catchError((e) => print(e));
  }
}
