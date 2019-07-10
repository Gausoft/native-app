import 'package:gentlestudent/src/models/news.dart';
import 'package:gentlestudent/src/repositories/news_repository.dart';
import 'package:rxdart/rxdart.dart';

class NewsBloc {
  final NewsRepository _newsRepository = NewsRepository();
  final _news = BehaviorSubject<List<News>>();

  Stream<List<News>> get news => _news.stream;

  Function(List<News>) get _changeNews => _news.sink.add;

  NewsBloc() {
    fetchNews();
  }

  Future<void> fetchNews() async => _changeNews(await _newsRepository.news);

  void dispose() {
    _news.close();
  }
}
