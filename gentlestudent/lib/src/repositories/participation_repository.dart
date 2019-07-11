import 'package:firebase_auth/firebase_auth.dart';
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

      if (_participations == null || _participations.isEmpty) {
       participation = _participations.firstWhere((p) => p.opportunityId == opportunityId);
      }

      if (participation == null) {
        participation = await _participationApi.getParticipationByOpportunityId(user, opportunityId);
      }

      return participation;
    }

    return null;
  }

  void clearParticipations() => _participations = [];
}
