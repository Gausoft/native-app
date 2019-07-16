import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gentlestudent/src/blocs/opportunity_bloc.dart';
import 'package:gentlestudent/src/blocs/quest_bloc.dart';
import 'package:gentlestudent/src/models/address.dart';
import 'package:gentlestudent/src/models/badge.dart';
import 'package:gentlestudent/src/models/issuer.dart';
import 'package:gentlestudent/src/models/opportunity.dart';
import 'package:gentlestudent/src/models/quest.dart';
import 'package:gentlestudent/src/models/user_location.dart';
import 'package:gentlestudent/src/views/main/opportunities/opportunities_map_page/widgets/opportunity_marker_dialog.dart';
import 'package:gentlestudent/src/views/main/opportunities/opportunity_detail_page/opportunity_detail_page.dart';
import 'package:gentlestudent/src/widgets/loading_spinner.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

class OpportunitiesMapPage extends StatefulWidget {
  _OpportunitiesMapPageState createState() => _OpportunitiesMapPageState();
}

class _OpportunitiesMapPageState extends State<OpportunitiesMapPage> {
  static List<String> notifiedOpportunities = [];
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  OpportunityBloc opportunityBloc;

  Future<List<Marker>> generateOpportunityMarkers(
    List<Opportunity> opportunities,
    OpportunityBloc bloc,
    BuildContext context,
  ) async {
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

  Future<List<Marker>> generateQuestMarkers(
    List<Quest> quests,
  ) async {
    List<Marker> markers = [];
    if (quests != null && quests.isNotEmpty) {
      for (int i = 0; i < quests.length; i++) {
        markers.add(
          Marker(
            point: LatLng(quests[i].latitude, quests[i].longitude),
            builder: (context) => Container(
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Icon(
                      FontAwesomeIcons.solidCircle,
                      color: Colors.yellow.shade300,
                      size: 30,
                    ),
                  ),
                  Center(
                    child: Icon(
                      FontAwesomeIcons.questionCircle,
                      color: Colors.black87,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    return markers;
  }

  MarkerLayerOptions userLocationMarker(UserLocation _userLocation) =>
      MarkerLayerOptions(
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
      );

  Future<void> _onMarkerTap(
    BuildContext context,
    Opportunity opportunity,
    OpportunityBloc bloc,
  ) async {
    Badge badge = await bloc.getBadgeOfOpportunity(opportunity);
    Issuer issuer = await bloc.getIssuerOfOpportunity(opportunity);

    displayOpportunity(
      context,
      opportunity,
      issuer,
      badge,
      () => {
        Navigator.of(context).pop(),
        _navigateToOpportunityDetailPage(opportunity)
      },
    );
  }

  void _navigateToOpportunityDetailPage(Opportunity opportunity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            OpportunityDetailPage(opportunity: opportunity),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    final initializationSettingsAndroid =
        AndroidInitializationSettings('gentlestudent_logo');
    final initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  @override
  Widget build(BuildContext context) {
    final _opportunityBloc = Provider.of<OpportunityBloc>(context);
    final _questBloc = Provider.of<QuestBloc>(context);
    final _userLocation = Provider.of<UserLocation>(context);
    print('Lat: ${_userLocation?.latitude}, Long: ${_userLocation?.longitude}');

    return Container(
      child: StreamBuilder(
        stream: _opportunityBloc.filteredOpportunities,
        builder: (BuildContext context,
            AsyncSnapshot<List<Opportunity>> opportunitiesSnapshot) {
          if (!opportunitiesSnapshot.hasData) {
            return loadingSpinner();
          }

          opportunityBloc = _opportunityBloc;
          _searchNearbyOpportunities(_userLocation, _opportunityBloc);

          return StreamBuilder(
            stream: _questBloc.quests,
            builder: (BuildContext context,
                AsyncSnapshot<List<Quest>> questsSnapshot) {
              return FutureBuilder(
                future: generateOpportunityMarkers(
                    opportunitiesSnapshot.data, _opportunityBloc, context),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Marker>> opportunityMarkersSnapshot) {
                  if (!opportunityMarkersSnapshot.hasData) {
                    return loadingSpinner();
                  }

                  return FutureBuilder(
                    future: generateQuestMarkers(questsSnapshot.data),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Marker>> questMarkersSnapshot) {
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
                              'id': Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? 'mapbox.dark'
                                  : 'mapbox.streets',
                            },
                          ),
                          MarkerLayerOptions(
                              markers: opportunityMarkersSnapshot.data),
                          _userLocation != null &&
                                  _userLocation.latitude != null &&
                                  _userLocation.longitude != null
                              ? userLocationMarker(_userLocation)
                              : MarkerLayerOptions(),
                          questMarkersSnapshot.hasData &&
                                  questMarkersSnapshot.data.isNotEmpty
                              ? MarkerLayerOptions(
                                  markers: questMarkersSnapshot.data)
                              : MarkerLayerOptions(),
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _searchNearbyOpportunities(
    UserLocation userLocation,
    OpportunityBloc bloc,
  ) async {
    // FOR TESTING
    UserLocation fakeLocation =
        UserLocation(latitude: 51.03563520797982, longitude: 3.721189648657173);
    List<Opportunity> opportunities =
        await bloc.searchNearbyOpportunities(fakeLocation);

    if (userLocation != null) {
      // FOR REAL
      // List<Opportunity> opportunities = await bloc.searchNearbyOpportunities(userLocation);

      for (final opportunity in opportunities) {
        if (!notifiedOpportunities.contains(opportunity.opportunityId)) {
          notifiedOpportunities.add(opportunity.opportunityId);
          await showNotification(opportunity);
        }
      }
    }
  }

  Future<void> showNotification(Opportunity opportunity) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '0',
      'main_channel',
      'the main channel',
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker',
    );

    final iOSPlatformChannelSpecifics = IOSNotificationDetails();

    final platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      0,
      'Er is een leerkans in de buurt',
      opportunity.title,
      platformChannelSpecifics,
      payload: opportunity.opportunityId,
    );
  }

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      Opportunity opportunity =
          await opportunityBloc.getOpportunityById(payload);
      _navigateToOpportunityDetailPage(opportunity);
    }
  }
}
