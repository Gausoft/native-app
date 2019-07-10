import 'package:cloud_firestore/cloud_firestore.dart';

class Participant {
  final String participantId;
  final String email;
  final String name;
  final String institute;
  final String profilePicture;
  final List<String> favorites;

  Participant({
    this.participantId,
    this.institute,
    this.email,
    this.name,
    this.profilePicture,
    this.favorites,
  });

  factory Participant.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data;

    return Participant(
      participantId: snapshot.documentID,
      name: data['name'],
      institute: data['institute'],
      email: data['email'],
      profilePicture: data['profilePicture'],
      favorites: (data['favorites'] as List).map((f) => f.toString()).toList(),
    );
  }
}
