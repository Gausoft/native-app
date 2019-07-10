import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gentlestudent/src/models/participant.dart';
import 'package:gentlestudent/src/network/participant_api.dart';

class ParticipantRepository {
  final ParticipantApi _participantApi = ParticipantApi();

  Participant _participant;
  Future<Participant> get participant async {
    if (_participant == null) {
      await _fetchParticipant();
    }

    return _participant;
  }

  Future<void> _fetchParticipant() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      _participant = await _participantApi.getParticipantById(user.uid);
    }
  }

  Future<void> changeFavorites(String opportunityId) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    if (_participant == null || user == null) return;

    if (_participant.favorites.contains(opportunityId)) {
      _participant.favorites.remove(opportunityId);
      await _participantApi.changeFavorites(user.uid, _participant.favorites);
    } else {
      _participant.favorites.add(opportunityId);
      await _participantApi.changeFavorites(user.uid, _participant.favorites);
    }
  }

  Future<bool> changeProfilePicture(File image) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    if (_participant == null || user == null) return false;

    try {
      final StorageReference ref = FirebaseStorage.instance.ref().child(
            "Profilepictures/${user.uid}/profile_picture.jpg",
          );

      final StorageUploadTask task = ref.putFile(image);
      final StorageTaskSnapshot taskSnapshot = await task.onComplete;
      final path = await taskSnapshot.ref.getDownloadURL();

      await _participantApi.changeProfilePicture(user.uid, path);

      return true;
    } catch (error) {
      print("An error occurred while changing the profile picture: $error");
      return false;
    }
  }

  void clearParticipant() => _participant = null;
}
