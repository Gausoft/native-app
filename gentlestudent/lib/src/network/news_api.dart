import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gentlestudent/src/models/news.dart';

class NewsApi {
  Future<List<News>> getAllNews() async {
    return (await Firestore.instance.collection('News').getDocuments())
        .documents
        .map((snapshot) => News.fromDocumentSnapshot(snapshot))
        .toList();
  }
}