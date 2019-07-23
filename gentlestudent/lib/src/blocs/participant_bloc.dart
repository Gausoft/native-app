import 'dart:io';

import 'package:gentlestudent/src/models/opportunity.dart';
import 'package:gentlestudent/src/models/participant.dart';
import 'package:gentlestudent/src/repositories/participant_repository.dart';
import 'package:rxdart/rxdart.dart';

class ParticipantBloc {
  final _participantRepository = ParticipantRepository();
  final _participant = BehaviorSubject<Participant>();
  final _isLoading = BehaviorSubject<bool>();

  Stream<Participant> get participant => _participant.stream;
  Stream<bool> get isLoading => _isLoading.stream;

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
    _isLoading.sink.add(true);
    final isSucces = await _participantRepository.changeProfilePicture(image);
    _changeParticipant(_participant.value);
    _isLoading.sink.add(false);
    return isSucces;
  }

  Future<bool> editParticipantProfile(String name, String institute, String email) async {
    if (name == null || name == "" || institute == null || institute == "" || email == null || email == "") return false;

    _isLoading.sink.add(true);

    final isSucces = await _participantRepository.editParticipantProfile(name, institute, email);

    if (isSucces) fetchParticipant();

    _isLoading.sink.add(false);
    
    return isSucces;
  }

  void onSignOut() {
    _participantRepository.clearParticipant();
  }

  void dispose() {
    _participant.close();
    _isLoading.close();
  }
}
