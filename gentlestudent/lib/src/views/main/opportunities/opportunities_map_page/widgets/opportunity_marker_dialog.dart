import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gentlestudent/src/models/badge.dart';
import 'package:gentlestudent/src/models/issuer.dart';
import 'package:gentlestudent/src/models/opportunity.dart';
import 'package:gentlestudent/src/utils/string_utils.dart';

Future<Null> displayOpportunity(BuildContext context, Opportunity opportunity,
    Issuer issuer, Badge badge, Function onPressed) async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.all(2),
        content: Padding(
          padding: EdgeInsets.only(top: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.only(left: 14, right: 8),
                leading: CachedNetworkImage(
                  imageUrl: badge.image,
                  fit: BoxFit.fill,
                  placeholder: (context, message) =>
                      CircularProgressIndicator(),
                  errorWidget: (context, message, object) => Icon(Icons.error),
                ),
                title: Text(
                  opportunity.title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black54,
                      fontSize: 16),
                ),
                subtitle: Text(
                  StringUtils.getCategory(opportunity) +
                      "\n" +
                      StringUtils.getDifficulty(opportunity) +
                      "\n" +
                      issuer.name,
                  style: TextStyle(fontSize: 12),
                ),
                isThreeLine: true,
                dense: false,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Text(
                  opportunity.shortDescription,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                child: RaisedButton(
                  child: Text(
                    "Lees meer",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  color: Colors.lightBlueAccent,
                  onPressed: onPressed,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
