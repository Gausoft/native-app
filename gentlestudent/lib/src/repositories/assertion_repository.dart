import 'package:firebase_auth/firebase_auth.dart';
import 'package:gentlestudent/src/models/assertion.dart';
import 'package:gentlestudent/src/network/assertion_api.dart';

class AssertionRepository {
  final AssertionApi _assertionApi = AssertionApi();

  List<Assertion> _assertions;
  Future<List<Assertion>> get assertions async {
    if (_assertions == null || _assertions.isEmpty) {
      await _fetchAssertions();
    }
    return _assertions;
  }

  Future _fetchAssertions() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      _assertions = await _assertionApi.getAllAssertionsFromUser(user.uid);
    }
  }

  void clearAssertions() => _assertions = [];
}
