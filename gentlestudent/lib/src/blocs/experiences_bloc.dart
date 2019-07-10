import 'package:gentlestudent/src/models/experience.dart';
import 'package:gentlestudent/src/repositories/experiences_repository.dart';
import 'package:rxdart/rxdart.dart';

class ExperiencesBloc {
  final ExperiencesRepository _experiencesRepository = ExperiencesRepository();
  final _experiences = BehaviorSubject<List<Experience>>();

  Stream<List<Experience>> get experiences => _experiences.stream;

  Function(List<Experience>) get _changeExperiences => _experiences.sink.add;

  ExperiencesBloc() {
    fetchExperiences();
  }

  Future<void> fetchExperiences() async => _changeExperiences(await _experiencesRepository.experiences);

  void dispose() {
    _experiences.close();
  }
}
