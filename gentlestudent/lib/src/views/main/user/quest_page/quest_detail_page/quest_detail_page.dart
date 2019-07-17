import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gentlestudent/src/blocs/quest_bloc.dart';
import 'package:gentlestudent/src/constants/string_constants.dart';
import 'package:gentlestudent/src/models/quest.dart';
import 'package:gentlestudent/src/views/authentication/widgets/app_bar.dart';
import 'package:gentlestudent/src/views/main/user/quest_page/quest_detail_page/widgets/quest_info_box.dart';
import 'package:gentlestudent/src/views/main/user/quest_page/widgets/quest_logo.dart';
import 'package:gentlestudent/src/views/main/user/quest_page/widgets/quest_title.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

class QuestDetailPage extends StatelessWidget {
  final Quest quest;
  final bool isInProgress;

  QuestDetailPage(this.quest, [this.isInProgress = false]);

  @override
  Widget build(BuildContext context) {
    final _questBloc = Provider.of<QuestBloc>(context);
    final _imageWidth = MediaQuery.of(context).size.width / 8;
    final _mapHeight = MediaQuery.of(context).size.width * 2 / 3;

    return Scaffold(
      appBar: appBar("Quest"),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            questHeader(context, _imageWidth),
            questMap(_mapHeight, context),
            SizedBox(height: 8),
            questInfoBox(quest),
            SizedBox(height: 8),
            questDescription(),
          ],
        ),
      ),
    );
  }

  Widget questHeader(BuildContext context, double imageWidth) => Row(
        children: <Widget>[
          questLogo(imageWidth),
          Padding(
            padding: EdgeInsets.all(10),
            child: questTitle(context, quest),
          )
        ],
      );

  Widget questMap(double mapHeight, BuildContext context) => Container(
        height: mapHeight,
        child: FlutterMap(
          options: MapOptions(
            center: LatLng(quest.latitude, quest.longitude),
            zoom: 14,
            maxZoom: 16,
            minZoom: 12,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://api.tiles.mapbox.com/v4/"
                  "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
              additionalOptions: {
                'accessToken':
                    'pk.eyJ1IjoiZ2VudGxlc3R1ZGVudCIsImEiOiJjampxdGI5cGExMjh2M3FudTVkYnl3aDlzIn0.Z3OSj_o97M8_7L8P5s3xIA',
                'id': Theme.of(context).brightness == Brightness.dark
                    ? 'mapbox.dark'
                    : 'mapbox.streets',
              },
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 45,
                  height: 45,
                  point: LatLng(quest.latitude, quest.longitude),
                  builder: (context) => GestureDetector(
                    onTap: () => {},
                    child: Container(
                      child: CachedNetworkImage(
                        imageUrl: questPinImageUrl,
                        placeholder: (context, message) => CircularProgressIndicator(),
                        errorWidget: (context, message, object) => Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );

  Widget questDescription() => Padding(
        padding: EdgeInsets.only(left: 21, right: 21, top: 12, bottom: 4),
        child: TextField(
          controller: TextEditingController(text: quest.description),
          readOnly: true,
          maxLines: null,
          decoration: null,
          style: TextStyle(fontSize: 14),
        ),
      );
}
