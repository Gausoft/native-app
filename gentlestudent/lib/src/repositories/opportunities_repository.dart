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
}
