import 'package:cloud_firestore/cloud_firestore.dart';

class Token {
  final String tokenId;
  final String questId;
  final String participantId;
  final Timestamp issuedOn;

  Token({
    this.tokenId,
    this.questId,
    this.participantId,
    this.issuedOn,
  });

  factory Token.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data;

    return Token(
      tokenId: snapshot.documentID,
      questId: data['questId'],
      participantId: data['participantId'],
      issuedOn: data['issuedOn'],
    );
  }
}
