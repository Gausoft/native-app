import 'package:gentlestudent/src/models/address.dart';
import 'package:gentlestudent/src/network/address_api.dart';

class AddressRepository {
  final AddressApi _addressApi = AddressApi();

  List<Address> _addresses;
  Future<List<Address>> get addresses async {
    if (_addresses == null || _addresses.isEmpty) {
      await _fetchAddresses();
    }
    return _addresses;
  }

  AddressRepository() {
    _fetchAddresses();
  }

  Future _fetchAddresses() async {
    _addresses = await _addressApi.getAllAddresses();
  }

  Future<Address> getAddressById(String addressId) async {
    if (_addresses == null || _addresses.isEmpty) {
      await _fetchAddresses();
    }
    
    Address address = _addresses.singleWhere((a) => a.addressId == addressId);

    if (address == null) {
      address = await _addressApi.getAddressById(addressId);
    }

    return address;
  }
}
