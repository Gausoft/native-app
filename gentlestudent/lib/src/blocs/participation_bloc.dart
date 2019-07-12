import 'package:gentlestudent/src/models/enums/status.dart';
import 'package:gentlestudent/src/models/opportunity.dart';
import 'package:gentlestudent/src/models/participation.dart';
import 'package:gentlestudent/src/repositories/participation_repository.dart';
import 'package:rxdart/rxdart.dart';

class ParticipationBloc {
  final _participationRepository = ParticipationRepository();
  final _approvedParticipations = BehaviorSubject<List<Participation>>();
  final _requestedParticipations = BehaviorSubject<List<Participation>>();
  final _selectedParticipation = BehaviorSubject<Participation>();

  Stream<List<Participation>> get approvedParticipations => _approvedParticipations.stream;
  Stream<List<Participation>> get requestedParticipations => _requestedParticipations.stream;
  Stream<Participation> get selectedParticipation => _selectedParticipation.stream;

  Function(List<Participation>) get _changeApprovedParticipations => _approvedParticipations.sink.add;
  Function(List<Participation>) get _changeRequestedParticipations => _requestedParticipations.sink.add;
  Function(Participation) get _changeSelectedParticipation => _selectedParticipation.sink.add;

  Future<void> fetchParticipations() async {
    List<Participation> participations = await _participationRepository.participations;
    _changeApprovedParticipations(participations.where((p) => p.status == Status.APPROVED).toList());
    _changeRequestedParticipations(participations.where((p) => p.status == Status.PENDING || p.status == Status.REFUSED).toList());
  }

  Future<void> fetchParticipationByOpportunity(Opportunity opportunity) async {
    _changeSelectedParticipation(null);
    Participation participation = await _participationRepository.getParticipationByOpportunityId(opportunity.opportunityId);
    _changeSelectedParticipation(participation);
  }

  Future<bool> enrollInOpportunity(Opportunity opportunity) async {
    Participation participation = await _participationRepository.enrollInOpportunity(opportunity);
    if (participation.opportunityId == null) {
      return false;
    } else {
      _changeSelectedParticipation(participation);
      List<Participation> participations = _requestedParticipations.value;
      if (participations != null) participations.add(participation);
      _changeRequestedParticipations(participations);
      return true;
    }
  }

  Future<bool> updateParticipationAfterBadgeClaim(String message) async {
    Participation participation = _selectedParticipation.value;
    if (participation == null) return false;
    
    await _participationRepository.updateParticipationAfterBadgeClaim(participation, message);

    await fetchParticipations();

    participation.status = Status.APPROVED;
    _changeSelectedParticipation(participation);

    return true;
  }

  void onSignOut() {
    _participationRepository.clearParticipations();
    _changeApprovedParticipations([]);
    _changeRequestedParticipations([]);
  }

  void dispose() {
    _approvedParticipations.close();
    _requestedParticipations.close();
    _selectedParticipation.close();
  }
}
