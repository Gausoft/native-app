import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gentlestudent/src/models/issuer.dart';

class IssuerApi {
  Future<List<Issuer>> getAllIssuers() async {
    return (await Firestore.instance.collection('Issuers').getDocuments())
        .documents
        .map((snapshot) => Issuer.fromDocumentSnapshot(snapshot))
        .toList();
  }

  Future<Issuer> getIssuerById(String issuerId) async {
    return Issuer.fromDocumentSnapshot(await Firestore.instance
        .collection("Issuers")
        .document(issuerId)
        .get());
  }
}
