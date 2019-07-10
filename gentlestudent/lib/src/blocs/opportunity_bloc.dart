import 'package:gentlestudent/src/models/address.dart';
import 'package:gentlestudent/src/models/badge.dart';
import 'package:gentlestudent/src/models/issuer.dart';
import 'package:gentlestudent/src/models/opportunity.dart';
import 'package:gentlestudent/src/repositories/address_repository.dart';
import 'package:gentlestudent/src/repositories/badge_repository.dart';
import 'package:gentlestudent/src/repositories/issuer_repository.dart';
import 'package:gentlestudent/src/repositories/opportunities_repository.dart';
import 'package:rxdart/rxdart.dart';

class OpportunityBloc {
  final _opportunitiesRepository = OpportunitiesRepository();
  final _addressRepository = AddressRepository();
  final _badgeRepository = BadgeRepository();
  final _issuerRepository = IssuerRepository();
  final _opportunities = BehaviorSubject<List<Opportunity>>();

  Stream<List<Opportunity>> get opportunities => _opportunities.stream;

  Function(List<Opportunity>) get _changeOpportunities =>
      _opportunities.sink.add;

  OpportunityBloc() {
    _fetchOpportunities();
  }

  Future _fetchOpportunities() async {
    List<Opportunity> opportunities = await _opportunitiesRepository.opportunities;
    _changeOpportunities(opportunities);
  }

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

  void dispose() {
    _opportunities.close();
  }
}
