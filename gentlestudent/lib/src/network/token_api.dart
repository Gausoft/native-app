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

  Future<bool> createToken(String userId, String questId) async {
    Map<String, dynamic> data = <String, dynamic>{
      "imageUrl": "",
      "issuedOn": Timestamp.now(),
      "participantId": userId,
      "questId": questId,
    };

    final CollectionReference collection =
        Firestore.instance.collection("Tokens");
    collection.add(data).catchError((e) => print(e));

    return true;
  }
}
