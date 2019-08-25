import 'package:cloud_firestore/cloud_firestore.dart';

class Address {
  final String addressId;
  final String street;
  final int housenumber;
  final int postalcode;
  final String city;
  final String bus;
  final double latitude;
  final double longitude;

  Address({
    this.addressId,
    this.street,
    this.city,
    this.postalcode,
    this.housenumber,
    this.bus,
    this.latitude,
    this.longitude,
  });

  factory Address.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data;
    
    return Address(
      addressId: snapshot.documentID,
      bus: data['bus'],
      city: data['city'],
      housenumber:
          data['housenumber'].runtimeType == int ? data['housenumber'] : 0,
      postalcode:
          data['postalcode'].runtimeType == int ? data['postalcode'] : 0,
      street: data['street'],
      latitude: data['latitude'].runtimeType == double
          ? data['latitude']
          : data['latitude'] != null
              ? double.tryParse(data['latitude'])
              : null,
      longitude: data['longitude'].runtimeType == double
          ? data['longitude']
          : data['longitude'] != null
              ? double.tryParse(data['longitude'])
              : null,
    );
  }
}
