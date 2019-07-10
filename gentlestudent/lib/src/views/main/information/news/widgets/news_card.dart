import 'package:flutter/material.dart';
import 'package:gentlestudent/src/models/news.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gentlestudent/src/views/main/information/news/news_detail_page.dart/news_detail_page.dart';
import 'package:gentlestudent/src/widgets/loading_spinner.dart';

class NewsCard extends StatelessWidget {
  final News news;

  NewsCard({this.news});

  void _navigateToNewsDetailPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => NewsDetailPage(news: news),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => _navigateToNewsDetailPage(context),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListBody(
            children: <Widget>[
              newsImage(),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  newsTitle(),
                  newsShortDescription(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget newsImage() => Container(
    height: 200,
    child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        child: CachedNetworkImage(
          imageUrl: news.imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, message) => Container(
            padding: EdgeInsets.all(10),
            child: loadingSpinner(),
          ),
          errorWidget: (context, message, object) => Container(
            padding: EdgeInsets.all(10),
            child: Center(child: Icon(Icons.error)),
          ),
        ),
      ),
  );

  Widget newsTitle() => Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Text(
          news.title,
          style: TextStyle(fontSize: 21),
        ),
      );

  Widget newsShortDescription() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          news.shortText,
          style: TextStyle(fontSize: 14),
        ),
      );
}
