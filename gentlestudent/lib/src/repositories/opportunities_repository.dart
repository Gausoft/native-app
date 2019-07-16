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
    Opportunity opportunity;

    if (_opportunities == null || _opportunities.isEmpty) {
      opportunity = _opportunities.firstWhere((o) => o.opportunityId == id);
    }

    if (opportunity == null) {
      opportunity = await _opportunityApi.getOpportunityById(id);
    }

    return opportunity;
  }
}
