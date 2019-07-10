import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gentlestudent/src/models/news.dart';
import 'package:gentlestudent/src/utils/date_utils.dart';
import 'package:gentlestudent/src/widgets/loading_spinner.dart';

class NewsDetailPage extends StatelessWidget {
  final News news;

  NewsDetailPage({this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nieuwsbericht", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: <Widget>[
          newsImage(),
          newsTitle(),
          newsInfoBox(),
          shortDescription(),
          longDescription(),
        ],
      ),
    );
  }

  Widget newsImage() => CachedNetworkImage(
        imageUrl: news.imageUrl,
        placeholder: (context, message) => loadingSpinner(),
        errorWidget: (context, message, object) => Icon(Icons.error),
      );

  Widget newsTitle() => Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 26, bottom: 10),
        child: Text(
          news.title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 21),
        ),
      );

  Widget newsInfoBox() => Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 10),
        child: Container(
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.lightBlue),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              newsAuthor(),
              SizedBox(height: 6),
              newsDate(),
            ],
          ),
        ),
      );

  Widget newsAuthor() => Row(
        children: <Widget>[
          Text(
            "Auteur:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.lightBlue,
            ),
          ),
          Expanded(
            child: Text(
              " ${news.author}",
              style: TextStyle(
                fontSize: 14,
                color: Colors.lightBlue,
              ),
            ),
          ),
        ],
      );

  Widget newsDate() => Row(
        children: <Widget>[
          Text(
            "Gepubliceerd op:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.lightBlue,
            ),
          ),
          Expanded(
            child: Text(
              " ${DateUtils.formatDate(news.published)}",
              style: TextStyle(
                fontSize: 14,
                color: Colors.lightBlue,
              ),
            ),
          ),
        ],
      );

  Widget shortDescription() => Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 10),
        child: Text(
          news.shortText,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget longDescription() => Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 10),
        child: Text(
          news.longText,
          style: TextStyle(fontSize: 14),
        ),
      );
}
