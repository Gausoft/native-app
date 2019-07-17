import 'package:gentlestudent/src/models/address.dart';
import 'package:gentlestudent/src/models/badge.dart';
import 'package:gentlestudent/src/models/enums/category.dart';
import 'package:gentlestudent/src/models/enums/difficulty.dart';
import 'package:gentlestudent/src/models/issuer.dart';
import 'package:gentlestudent/src/models/opportunity.dart';
import 'package:gentlestudent/src/models/user_location.dart';
import 'package:gentlestudent/src/repositories/address_repository.dart';
import 'package:gentlestudent/src/repositories/badge_repository.dart';
import 'package:gentlestudent/src/repositories/issuer_repository.dart';
import 'package:gentlestudent/src/repositories/opportunities_repository.dart';
import 'package:latlong/latlong.dart';
import 'package:rxdart/rxdart.dart';

final double _notificationRange = 10.0;
final Distance _distance = Distance();

class OpportunityBloc {
  final _opportunitiesRepository = OpportunitiesRepository();
  final _addressRepository = AddressRepository();
  final _badgeRepository = BadgeRepository();
  final _issuerRepository = IssuerRepository();
  final _opportunities = BehaviorSubject<List<Opportunity>>();
  final _filteredOpportunities = BehaviorSubject<List<Opportunity>>();
  final _opportunityNameFilter = BehaviorSubject<String>();
  final _categoryFilter = BehaviorSubject<Category>();
  final _difficultyFilter = BehaviorSubject<Difficulty>();
  final _showQuestsFilter = BehaviorSubject<bool>();

  Stream<List<Opportunity>> get opportunities => _opportunities.stream;
  Stream<List<Opportunity>> get filteredOpportunities => _filteredOpportunities.stream;
  Stream<String> get opportunityNameFilter => _opportunityNameFilter.stream;
  Stream<Category> get categoryFilter => _categoryFilter.stream;
  Stream<Difficulty> get difficultyFilter => _difficultyFilter.stream;
  Stream<bool> get showQuestsFilter => _showQuestsFilter.stream;

  Function(List<Opportunity>) get _changeOpportunities => _opportunities.sink.add;
  Function(List<Opportunity>) get _changeFilteredOpportunities => _filteredOpportunities.sink.add;
  Function(bool) get changeShowQuestsFilter => _showQuestsFilter.sink.add;

  String get opportunityNameFilterValue => _opportunityNameFilter.value;

  OpportunityBloc() {
    _fetchOpportunities();
    changeShowQuestsFilter(true);
  }

  Future _fetchOpportunities() async {
    List<Opportunity> opportunities = await _opportunitiesRepository.opportunities;
    List<Opportunity> filteredOpportunities = opportunities;

    _changeOpportunities(opportunities);
    _changeFilteredOpportunities(filteredOpportunities);
  }

  Future<Opportunity> getOpportunityById(String id) async => _opportunitiesRepository.fetchOpportunityById(id);

  Future<Address> getAddressOfOpportunity(Opportunity opportunity) async {
    Address address = await _addressRepository.getAddressById(opportunity.addressId);
    return address;
  }

  Future<Issuer> getIssuerOfOpportunity(Opportunity opportunity) async {
    Issuer issuer = await _issuerRepository.getIssuerById(opportunity.issuerId);
    return issuer;
  }

  Future<Badge> getBadgeOfOpportunity(Opportunity opportunity) async {
    Badge badge = await _badgeRepository.getBadgeById(opportunity.badgeId);
    return badge;
  }

  Future<Opportunity> getOpportunityByBadgeId(String badgeId) async {
    if (_opportunities.value == null || _opportunities.value.isEmpty) {
      await _fetchOpportunities();
    }

    Opportunity opportunity = _opportunities.value.firstWhere((o) => o.badgeId == badgeId);
    return opportunity;
  }

  void filterOpportunities() {
    List<Opportunity> opportunities = _opportunities.value;
    String opportunityName = _opportunityNameFilter.value;
    Category category = _categoryFilter.value;
    Difficulty difficulty = _difficultyFilter.value;

    List<Opportunity> filteredOpportunities = [...opportunities];

    if (opportunityName != null && opportunityName != "")
      filteredOpportunities = filteredOpportunities
          .where((o) => o.title.toLowerCase().contains(opportunityName.toLowerCase()))
          .toList();

    if (category != null)
      filteredOpportunities = filteredOpportunities.where((o) => o.category == category).toList();

    if (difficulty != null)
      filteredOpportunities = filteredOpportunities
          .where((o) => o.difficulty == difficulty)
          .toList();

    _changeFilteredOpportunities(filteredOpportunities);
  }

  void changeOpportunityName(String name) {
    _opportunityNameFilter.sink.add(name);
    filterOpportunities();
  }

  void changeCategory(Category category) {
    _categoryFilter.sink.add(category);
    filterOpportunities();
  }

  void changeDifficulty(Difficulty difficulty) {
    _difficultyFilter.sink.add(difficulty);
    filterOpportunities();
  }

  Future<List<Opportunity>> searchNearbyOpportunities(UserLocation userLocation) async {
    List<Opportunity> opportunities = _opportunities.value;
    List<Opportunity> nearbyOpportunities = [];

    if (opportunities != null && opportunities.isNotEmpty) {
      for (final opportunity in opportunities) {
        Address address = await getAddressOfOpportunity(opportunity);

        if (_calculateDistanceInMeters(userLocation, address) <= _notificationRange) {
          nearbyOpportunities.add(opportunity);
        }
      }
    }

    return nearbyOpportunities;
  }

  double _calculateDistanceInMeters(UserLocation userLocation, Address address) =>
      _distance(
        LatLng(userLocation.latitude, userLocation.longitude),
        LatLng(address.latitude, address.longitude),
      );

  void dispose() {
    _opportunities.close();
    _filteredOpportunities.close();
    _opportunityNameFilter.close();
    _categoryFilter.close();
    _difficultyFilter.close();
    _showQuestsFilter.close();
  }
}
