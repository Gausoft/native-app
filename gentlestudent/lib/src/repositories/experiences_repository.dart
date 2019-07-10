import 'package:gentlestudent/src/models/experience.dart';
import 'package:gentlestudent/src/network/experiences_api.dart';

class ExperiencesRepository {
  final ExperiencesApi _experiencesApi = ExperiencesApi();

  List<Experience> _experiences;
  Future<List<Experience>> get experiences async {
    if (_experiences == null || _experiences.isEmpty) {
      await _fetchExperiences();
    }
    return _experiences;
  }

  Future _fetchExperiences() async {
    // From network
    _experiences = await _experiencesApi.getAllExperiences();
  }
}