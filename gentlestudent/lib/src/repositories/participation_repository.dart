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

  void clearParticipations() => _participations = [];
}
