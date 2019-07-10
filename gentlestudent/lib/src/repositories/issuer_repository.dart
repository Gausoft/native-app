import 'package:gentlestudent/src/models/issuer.dart';
import 'package:gentlestudent/src/network/issuer_api.dart';

class IssuerRepository {
  final IssuerApi _issuerApi = IssuerApi();

  List<Issuer> _issuers;
  Future<List<Issuer>> get issuers async {
    if (_issuers == null || _issuers.isEmpty) {
      await _fetchIssuers();
    }
    return _issuers;
  }

  IssuerRepository() {
    _fetchIssuers();
  }

  Future _fetchIssuers() async {
    _issuers = await _issuerApi.getAllIssuers();
  }

  Future<Issuer> getIssuerById(String issuerId) async {
    if (_issuers == null || _issuers.isEmpty) {
      await _fetchIssuers();
    }
    
    Issuer issuer = _issuers.singleWhere((b) => b.issuerId == issuerId);

    if (issuer == null) {
      issuer = await _issuerApi.getIssuerById(issuerId);
    }

    return issuer;
  }
}
