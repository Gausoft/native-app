import 'dart:io';

import 'package:gentlestudent/src/models/opportunity.dart';
import 'package:gentlestudent/src/models/participant.dart';
import 'package:gentlestudent/src/repositories/participant_repository.dart';
import 'package:rxdart/rxdart.dart';

class ParticipantBloc {
  final _participantRepository = ParticipantRepository();
  final _participant = BehaviorSubject<Participant>();

  Stream<Participant> get participant => _participant.stream;

  Function(Participant) get _changeParticipant => _participant.sink.add;

  Future<void> fetchParticipant() async {
    Participant participant = await _participantRepository.participant;
    _changeParticipant(participant);
  }

  Future<void> changeFavorites(Opportunity opportunity) async {
    await _participantRepository.changeFavorites(opportunity.opportunityId);
    _changeParticipant(_participant.value);
  }

  Future<bool> changeProfilePicture(File image) async {
      final isSucces = await _participantRepository.changeProfilePicture(image);
      _changeParticipant(_participant.value);
      return isSucces;
  }

  void onSignOut() {
    _participantRepository.clearParticipant();
  }

  void dispose() {
    _participant.close();
  }
}
