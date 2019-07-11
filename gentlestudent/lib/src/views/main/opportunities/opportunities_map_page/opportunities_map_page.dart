import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gentlestudent/src/blocs/opportunity_bloc.dart';
import 'package:gentlestudent/src/models/address.dart';
import 'package:gentlestudent/src/models/badge.dart';
import 'package:gentlestudent/src/models/issuer.dart';
import 'package:gentlestudent/src/models/opportunity.dart';
import 'package:gentlestudent/src/models/user_location.dart';
import 'package:gentlestudent/src/views/main/opportunities/opportunities_map_page/widgets/opportunity_marker_dialog.dart';
import 'package:gentlestudent/src/views/main/opportunities/opportunity_detail_page/opportunity_detail_page.dart';
import 'package:gentlestudent/src/widgets/loading_spinner.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

class OpportunitiesMapPage extends StatelessWidget {
  Future<List<Marker>> generateMarkers(List<Opportunity> opportunities,
      OpportunityBloc bloc, BuildContext context) async {
    List<Marker> markers = [];
    for (int i = 0; i < opportunities.length; i++) {
      Address address = await bloc.getAddressOfOpportunity(opportunities[i]);
      markers.add(
        Marker(
          width: 100,
          height: 100,
          point: LatLng(address.latitude, address.longitude),
          builder: (context) => GestureDetector(
            onTap: () => _onMarkerTap(context, opportunities[i], bloc),
            child: Container(
              child: CachedNetworkImage(
                imageUrl: opportunities[i].pinImageUrl,
                placeholder: (context, message) => CircularProgressIndicator(),
                errorWidget: (context, message, object) => Icon(Icons.error),
              ),
            ),
          ),
        ),
      );
    }
    return markers;
  }

  Future<void> _onMarkerTap(BuildContext context, Opportunity opportunity,
      OpportunityBloc bloc) async {
    Badge badge = await bloc.getBadgeOfOpportunity(opportunity);
    Issuer issuer = await bloc.getIssuerOfOpportunity(opportunity);

    displayOpportunity(
      context,
      opportunity,
      issuer,
      badge,
      () => _navigateToOpportunityDetailPage(context, opportunity),
    );
  }

  void _navigateToOpportunityDetailPage(
      BuildContext context, Opportunity opportunity) {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            OpportunityDetailPage(opportunity: opportunity),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _opportunityBloc = Provider.of<OpportunityBloc>(context);
    final _userLocation = Provider.of<UserLocation>(context);
    print(
        'Location: Lat: ${_userLocation?.latitude}, Long: ${_userLocation?.longitude}');

    return Container(
      child: StreamBuilder(
        stream: _opportunityBloc.filteredOpportunities,
        builder:
            (BuildContext context, AsyncSnapshot<List<Opportunity>> snapshot) {
          if (!snapshot.hasData) {
            return loadingSpinner();
          }

          return FutureBuilder(
            future: generateMarkers(snapshot.data, _opportunityBloc, context),
            builder:
                (BuildContext context, AsyncSnapshot<List<Marker>> snapshot) {
              if (!snapshot.hasData) {
                return loadingSpinner();
              }

              return FlutterMap(
                options: MapOptions(
                  center: LatLng(51.052233, 3.723653),
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
                  MarkerLayerOptions(markers: snapshot.data),
                  _userLocation != null &&
                          _userLocation.latitude != null &&
                          _userLocation.longitude != null
                      ? MarkerLayerOptions(
                          markers: [
                            Marker(
                              point: LatLng(
                                _userLocation.latitude,
                                _userLocation.longitude,
                              ),
                              builder: (context) => Container(
                                child: Stack(
                                  children: <Widget>[
                                    Center(
                                      child: Icon(
                                        FontAwesomeIcons.solidCircle,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    Center(
                                      child: Icon(
                                        FontAwesomeIcons.solidUserCircle,
                                        color: Colors.lightBlue,
                                        size: 26,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : MarkerLayerOptions(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
