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

  Future<void> fetchNews() async {
    List<News> news = await _newsRepository.news;
    news.sort((n1, n2) => n1.published.compareTo(n2.published));
    _changeNews(news.reversed.toList());
  }

  void dispose() {
    _news.close();
  }
}
