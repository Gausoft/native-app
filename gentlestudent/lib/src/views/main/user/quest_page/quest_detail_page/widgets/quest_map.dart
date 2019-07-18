import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gentlestudent/src/constants/string_constants.dart';
import 'package:gentlestudent/src/models/quest.dart';
import 'package:latlong/latlong.dart';

Widget questMap(double mapHeight, BuildContext context, Quest quest) =>
    Container(
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
                      placeholder: (context, message) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, message, object) =>
                          Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
