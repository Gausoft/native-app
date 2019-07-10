import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/news_bloc.dart';
import 'package:gentlestudent/src/models/news.dart';
import 'package:gentlestudent/src/views/authentication/widgets/app_bar.dart';
import 'package:gentlestudent/src/views/main/information/news/widgets/news_card.dart';
import 'package:gentlestudent/src/widgets/loading_spinner.dart';

class NewsPage extends StatefulWidget {
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  NewsBloc _newsBloc;

  @override
  void initState() {
    super.initState();
    _newsBloc = NewsBloc();
  }

  @override
  void dispose() {
    _newsBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("Nieuws"),
      body: StreamBuilder(
        stream: _newsBloc.news,
        builder: (BuildContext context, AsyncSnapshot<List<News>> snapshot) {
          if (!snapshot.hasData) {
            return loadingSpinner();
          }
          
          if (snapshot.data.isEmpty) {
            return Container(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text("Er is momenteel geen nieuws beschikbaar"),
              ),
            );
          }

          return Container(
            child: ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: snapshot.data.length,
                itemBuilder: (_, int index) {
                  final newsItem = snapshot.data[index];
                  return NewsCard(news: newsItem);
                },
              ),
          );
        },
      ),
    );
  }
}
