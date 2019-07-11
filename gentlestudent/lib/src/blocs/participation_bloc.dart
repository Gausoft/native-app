import 'package:gentlestudent/src/models/enums/status.dart';
import 'package:gentlestudent/src/models/opportunity.dart';
import 'package:gentlestudent/src/models/participation.dart';
import 'package:gentlestudent/src/repositories/participation_repository.dart';
import 'package:rxdart/rxdart.dart';

class ParticipationBloc {
  final _participationRepository = ParticipationRepository();
  final _approvedParticipations = BehaviorSubject<List<Participation>>();
  final _requestedParticipations = BehaviorSubject<List<Participation>>();

  Stream<List<Participation>> get approvedParticipations => _approvedParticipations.stream;
  Stream<List<Participation>> get requestedParticipations => _requestedParticipations.stream;

  Function(List<Participation>) get _changeApprovedParticipations => _approvedParticipations.sink.add;
  Function(List<Participation>) get _changeRequestedParticipations => _requestedParticipations.sink.add;

  Future<void> fetchParticipations() async {
    List<Participation> participations = await _participationRepository.participations;
    _changeApprovedParticipations(participations.where((p) => p.status == Status.APPROVED).toList());
    _changeRequestedParticipations(participations.where((p) => p.status == Status.PENDING || p.status == Status.REFUSED).toList());
  }

  Future<Participation> fetchParticipationByOpportunity(Opportunity opportunity) async {
    Participation participation = await _participationRepository.getParticipationByOpportunityId(opportunity.opportunityId);
    return participation;
  }

  void onSignOut() {
    _participationRepository.clearParticipations();
    _changeApprovedParticipations([]);
    _changeRequestedParticipations([]);
  }

  void dispose() {
    _approvedParticipations.close();
    _requestedParticipations.close();
  }
}
