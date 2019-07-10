import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gentlestudent/src/models/experience.dart';

class ExperiencesApi {
  Future<List<Experience>> getAllExperiences() async {
    return (await Firestore.instance.collection('Experiences').getDocuments())
        .documents
        .map((snapshot) => Experience.fromDocumentSnapshot(snapshot))
        .toList();
  }
}