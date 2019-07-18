import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gentlestudent/src/constants/string_constants.dart';
import 'package:gentlestudent/src/models/quest.dart';
import 'package:gentlestudent/src/models/token.dart';
import 'package:gentlestudent/src/utils/string_utils.dart';

Future<void> displayTokenDialog(
  BuildContext context,
  Token token,
  Quest quest,
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
            SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.only(left: 14, right: 8),
              leading: CachedNetworkImage(
                imageUrl: tokenGenericImageUrl,
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
            SizedBox(height: 24),
            Text(
              '"${quest.description}"',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic,),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                StringUtils.getFormattedCreationDate(
                    token.issuedOn.toDate(), false, quest,),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      );
    },
  );
}
