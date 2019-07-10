import 'package:gentlestudent/src/models/news.dart';
import 'package:gentlestudent/src/network/news_api.dart';

class NewsRepository {
  final NewsApi _newsApi = NewsApi();

  List<News> _news;
  Future<List<News>> get news async {
    if (_news == null || _news.isEmpty) {
      await _fetchNews();
    }
    return _news;
  }

  Future _fetchNews() async {
    // From network
    _news = await _newsApi.getAllNews();
  }
}
