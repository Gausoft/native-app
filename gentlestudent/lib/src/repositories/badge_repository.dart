import 'package:gentlestudent/src/models/badge.dart';
import 'package:gentlestudent/src/network/badge_api.dart';

class BadgeRepository {
  final BadgeApi _badgeApi = BadgeApi();

  List<Badge> _badges;
  Future<List<Badge>> get badges async {
    if (_badges == null || _badges.isEmpty) {
      await _fetchBadges();
    }
    return _badges;
  }

  BadgeRepository() {
    _fetchBadges();
  }

  Future _fetchBadges() async {
    _badges = await _badgeApi.getAllBadges();
  }

  Future<Badge> getBadgeById(String badgeId) async {
    if (_badges == null || _badges.isEmpty) {
      await _fetchBadges();
    }
    
    Badge badge = _badges.singleWhere((b) => b.openBadgeId == badgeId);

    if (badge == null) {
      badge = await _badgeApi.getBadgeById(badgeId);
    }

    return badge;
  }
}
