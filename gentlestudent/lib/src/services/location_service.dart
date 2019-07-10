import 'dart:async';

import 'package:gentlestudent/src/models/user_location.dart';
import 'package:location/location.dart';

class LocationService {
  final Location location = Location();
  UserLocation _currentLocation;

  Future<UserLocation> getLocation() async {
    try {
      LocationData userLocation = await location.getLocation();
      _currentLocation = UserLocation(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }

    return _currentLocation;
  }

  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>();

  Stream<UserLocation> get locationStream => _locationController.stream;

  LocationService() {
    // Request permission to use the location of the user.
    location.requestPermission().then((granted) {
      if (granted) {
        // If granted listen for location changes.
        location.onLocationChanged().listen((locationData) {
          if (locationData != null) {
            _locationController.add(UserLocation(
              latitude: locationData.latitude,
              longitude: locationData.longitude,
            ));
          }
        });
      }
    });
  }
}
