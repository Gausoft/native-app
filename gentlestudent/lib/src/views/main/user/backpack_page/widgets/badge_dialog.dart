import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gentlestudent/src/models/assertion.dart';
import 'package:gentlestudent/src/models/badge.dart';
import 'package:gentlestudent/src/models/issuer.dart';
import 'package:gentlestudent/src/models/opportunity.dart';
import 'package:gentlestudent/src/utils/string_utils.dart';
import 'package:gentlestudent/src/utils/web_launcher_utils.dart';

Future<void> displayBadgeDialog(
  BuildContext context,
  Assertion assertion,
  Badge badge,
  Opportunity opportunity,
  Issuer issuer,
) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: EdgeInsets.all(12),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.only(left: 14, right: 8),
              leading: CachedNetworkImage(
                imageUrl: badge.image,
                fit: BoxFit.fill,
                placeholder: (context, message) => CircularProgressIndicator(),
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
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(
                StringUtils.getFormattedCreationDate(assertion.issuedOn),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
            RaisedButton(
              child: Text(
                "Bekijk op het web",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              color: Colors.lightBlueAccent,
              onPressed: () => WebLauncherUtils.launchBackpack(),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      );
    },
  );
}
