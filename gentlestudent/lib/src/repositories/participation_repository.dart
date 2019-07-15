import 'package:firebase_auth/firebase_auth.dart';
import 'package:gentlestudent/src/models/enums/status.dart';
import 'package:gentlestudent/src/models/issuer.dart';
import 'package:gentlestudent/src/models/opportunity.dart';
import 'package:gentlestudent/src/models/participation.dart';
import 'package:gentlestudent/src/network/participation_api.dart';

class ParticipationRepository {
final ParticipationApi _participationApi = ParticipationApi();

  List<Participation> _participations;
  Future<List<Participation>> get participations async {
    if (_participations == null || _participations.isEmpty) {
      await _fetchParticipations();
    }
    return _participations;
  }

  Future _fetchParticipations() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      _participations = await _participationApi.getAllParticipationsFromUser(user.uid);
    }
  }

  Future<Participation> getParticipationByOpportunityId(String opportunityId) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      Participation participation;

      if (_participations != null && _participations.isNotEmpty) {
       List<Participation> participations = _participations.where((p) => p.opportunityId == opportunityId).toList();
       participation = participations.length >= 1 ? participations.first : null;
      }

      if (participation == null) {
        participation = await _participationApi.getParticipationByOpportunityId(user, opportunityId);
      }

      return participation;
    }

    return Participation();
  }

  Future<Participation> enrollInOpportunity(Opportunity opportunity, Issuer issuer) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      await _participationApi.enrollInOpportunity(user, opportunity, issuer);
      Participation participation = await _participationApi.getParticipationByOpportunityId(user, opportunity.opportunityId);
      if (participation.opportunityId != null) _participations.add(participation);
      return participation;
    }

    return Participation();
  }

  Future<void> updateParticipationAfterBadgeClaim(Participation participation, String message) async {
    await _participationApi.updateParticipationAfterBadgeClaim(participation.participationId, message);
    participation.status = Status.APPROVED;
    _participations.removeWhere((p) => p.participationId == participation.participationId);
    _participations.add(participation);
  }

  void clearParticipations() => _participations = [];
}
