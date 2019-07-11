import 'package:flutter/material.dart';

Future<String> showClaimBadgeDialog(BuildContext context) async {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      TextEditingController controller = TextEditingController();
      return AlertDialog(
        title: Text("Badge claimen"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Waarom denk je dat je in aanmerking komt om deze badge te claimen? Laat het ons hieronder weten.'
            ),
            SizedBox(height: 8),
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType: TextInputType.multiline,
              maxLines: 6,
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Claim badge'),
            onPressed: () async {
              Navigator.of(context).pop(controller.text);
            },
          ),
          FlatButton(
            child: Text('Annuleer'),
            onPressed: Navigator.of(context).pop,
          ),
        ],
      );
    },
  );
}
