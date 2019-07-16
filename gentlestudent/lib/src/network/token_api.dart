import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gentlestudent/src/models/token.dart';

class TokenApi {
  Future<List<Token>> fetchTokensOfUser(String userId) async {
    return (await Firestore.instance
            .collection("Tokens")
            .where("participantId", isEqualTo: userId)
            .getDocuments())
        .documents
        .map((snapshot) => Token.fromDocumentSnapshot(snapshot))
        .toList();
  }
}
