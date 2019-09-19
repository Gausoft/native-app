import 'package:gentlestudent/src/models/opportunity.dart';
import 'package:gentlestudent/src/network/opportunity_api.dart';

class OpportunitiesRepository {
  final OpportunityApi _opportunityApi = OpportunityApi();

  List<Opportunity> _opportunities;
  Future<List<Opportunity>> get opportunities async {
    if (_opportunities == null || _opportunities.isEmpty) {
      await _fetchOpportunities();
    }
    return _opportunities;
  }

  Future _fetchOpportunities() async {
    _opportunities = await _opportunityApi.getAllOpportunities();
  }

  Future<Opportunity> fetchOpportunityById(String id) async {
    if (_opportunities == null || _opportunities.isEmpty) {
      await _fetchOpportunities();
    }

    if (_opportunities.map((o) => o.opportunityId).contains(id)) {
      return _opportunities.firstWhere((o) => o.opportunityId == id);
    }

    final opportunity = await _opportunityApi.getOpportunityById(id);

    _opportunities.add(opportunity);
    
    return opportunity;
  }

  Future<Opportunity> fetchOpportunityByBadgeId(String badgeId) async {
    if (_opportunities == null || _opportunities.isEmpty) {
      await _fetchOpportunities();
    }

    if (_opportunities.map((o) => o.badgeId).contains(badgeId)) {
      return _opportunities.firstWhere((o) => o.badgeId == badgeId);
    }

    final opportunity = await _opportunityApi.getOpportunityByBadgeId(badgeId);

    _opportunities.add(opportunity);
    
    return opportunity;
  }
}
