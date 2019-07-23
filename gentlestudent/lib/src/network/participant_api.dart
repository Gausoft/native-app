import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gentlestudent/src/models/participant.dart';

class ParticipantApi {
  Future<Participant> getParticipantById(String participantId) async {
    return Participant.fromDocumentSnapshot(await Firestore.instance
        .collection("Participants")
        .document(participantId)
        .get());
  }

  Future<void> changeProfilePicture(
      String participantId, String profilePicture) async {
    Map<String, String> data = <String, String>{
      "profilePicture": profilePicture,
    };
    await Firestore.instance
        .collection("Participants")
        .document(participantId)
        .updateData(data)
        .whenComplete(() {
      print("Profile picture changed");
    }).catchError((e) => print(e));
  }

  Future<void> changeFavorites(String participantId, List<String> likes) async {
    Map<String, List<String>> data = <String, List<String>>{
      "favorites": likes,
    };
    await Firestore.instance
        .collection("Participants")
        .document(participantId)
        .updateData(data)
        .catchError((e) => print(e));
  }

  Future<bool> editParticipantProfile(String participantId, String name, String institute, String email) async {
    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "institute": institute,
      "email": email,
    };

    try {
      await Firestore.instance
        .collection("Participants")
        .document(participantId)
        .updateData(data);
    } catch(error) {
      print("An error occurred while editing the profile of the participant: $error");
      return false;
    }

    return true;
  }
}
