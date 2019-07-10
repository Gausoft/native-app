import 'package:gentlestudent/src/models/assertion.dart';
import 'package:gentlestudent/src/repositories/assertion_repository.dart';
import 'package:rxdart/subjects.dart';

class AssertionBloc {
  final _assertionRepository = AssertionRepository();
  final _assertions = BehaviorSubject<List<Assertion>>();

  Stream<List<Assertion>> get assertions => _assertions.stream;

  Function(List<Assertion>) get _changeAssertions => _assertions.sink.add;

  Future<void> fetchAssertions() async {
    List<Assertion> assertions = await _assertionRepository.assertions;
    _changeAssertions(assertions);
  }

  void onSignOut() {
    _assertionRepository.clearAssertions();
    _changeAssertions([]);
  }

  void dispose() {
    _assertions.close();
  }
}