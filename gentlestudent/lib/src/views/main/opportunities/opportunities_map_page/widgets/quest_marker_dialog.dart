import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gentlestudent/src/constants/string_constants.dart';
import 'package:gentlestudent/src/models/quest.dart';

Future<void> displayQuestMarkerDialog(BuildContext context, Quest quest, Function onPressed) async {
  return showDialog<void>(
    context: context,
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
                  imageUrl: questCircleImageUrl,
                  fit: BoxFit.fill,
                  placeholder: (context, message) => CircularProgressIndicator(),
                  errorWidget: (context, message, object) => Icon(Icons.error),
                ),
                title: Text(
                  quest.title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black54,
                      fontSize: 16),
                ),
                dense: false,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Text(
                  quest.description,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 14),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
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
