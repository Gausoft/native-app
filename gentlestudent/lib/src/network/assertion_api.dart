import 'package:cloud_firestore/cloud_firestore.dart';
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
}
