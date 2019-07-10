import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gentlestudent/src/models/address.dart';

class AddressApi {
  Future<List<Address>> getAllAddresses() async {
    return (await Firestore.instance.collection('Addresses').getDocuments())
        .documents
        .map((snapshot) => Address.fromDocumentSnapshot(snapshot))
        .toList();
  }

  Future<Address> getAddressById(String addressId) async {
    return Address.fromDocumentSnapshot(await Firestore.instance
        .collection("Addresses")
        .document(addressId)
        .get());
  }
}
