import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:gentlestudent/src/models/quest.dart';
import 'package:gentlestudent/src/models/quest_taker.dart';
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

  Future<bool> createToken(QuestTaker questTaker, Quest quest) async {
    Map<String, dynamic> data = <String, dynamic>{
      "imageUrl": "",
      "issuedOn": Timestamp.now(),
      "participantId": questTaker.participantId,
      "questId": questTaker.questId,
    };

    final CollectionReference collection =
        Firestore.instance.collection("Tokens");
    collection.add(data).whenComplete(() async {
      final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
        functionName: 'notifyTokenReceived',
      );
      await callable.call(<String, dynamic>{
        "giverName": quest.questGiver,
        "takerName": questTaker.participantName,
        "takerEmail": questTaker.participantEmail,
        "questTitle": quest.title,
      });
      print("E-mail sent");
    }).catchError((e) => print(e));

    return true;
  }
}
