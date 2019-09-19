import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/assertion_bloc.dart';
import 'package:gentlestudent/src/blocs/opportunity_bloc.dart';
import 'package:gentlestudent/src/models/assertion.dart';
import 'package:gentlestudent/src/models/badge.dart';
import 'package:gentlestudent/src/models/issuer.dart';
import 'package:gentlestudent/src/models/opportunity.dart';
import 'package:gentlestudent/src/views/authentication/widgets/app_bar.dart';
import 'package:gentlestudent/src/views/main/user/backpack_page/widgets/badge_dialog.dart';
import 'package:gentlestudent/src/widgets/loading_spinner.dart';
import 'package:provider/provider.dart';

class BackpackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _assertionBloc = Provider.of<AssertionBloc>(context);
    final _opportunityBloc = Provider.of<OpportunityBloc>(context);
    final _badgeWidth = MediaQuery.of(context).size.width / 5;

    return Scaffold(
      appBar: appBar("Backpack"),
      body: _buildBody(
        _assertionBloc,
        _opportunityBloc,
        _badgeWidth,
      ),
    );
  }

  Widget _buildBody(
    AssertionBloc assertionBloc,
    OpportunityBloc opportunityBloc,
    double badgeWidth,
  ) =>
      Container(
        child: StreamBuilder(
          stream: assertionBloc.assertions,
          builder: (context, AsyncSnapshot<List<Assertion>> snapshot) {
            if (!snapshot.hasData) {
              return loadingSpinner();
            }

            if (snapshot.data.isEmpty) {
              return Center(
                child: Text("Je hebt nog geen badges behaald"),
              );
            }

            return FutureBuilder(
              future: _buildBadges(
                snapshot.data,
                opportunityBloc,
                badgeWidth,
                context,
              ),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Widget>> badgesSnapshot) {
                if (!badgesSnapshot.hasData) {
                  return loadingSpinner();
                }

                return GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: 0.7,
                  children: <Widget>[
                    ...badgesSnapshot.data,
                  ],
                );
              },
            );
          },
        ),
      );

  Future<List<Widget>> _buildBadges(
    List<Assertion> assertions,
    OpportunityBloc bloc,
    double badgeWidth,
    BuildContext context,
  ) async {
    List<Widget> badges = [];

    for (int i = 0; i < assertions.length; i++) {
      final opportunity =
          await bloc.getOpportunityByBadgeId(assertions[i].openBadgeId);
      Badge badge = await bloc.getBadgeOfOpportunity(opportunity);
      Issuer issuer = await bloc.getIssuerOfOpportunity(opportunity);
      badges.add(
        _gridBadge(
          context,
          opportunity,
          badge,
          issuer,
          assertions[i],
          badgeWidth,
        ),
      );
    }

    return badges;
  }

  Widget _gridBadge(
    BuildContext context,
    Opportunity opportunity,
    Badge badge,
    Issuer issuer,
    Assertion assertion,
    double badgeWidth,
  ) =>
      InkWell(
        onTap: () => displayBadgeDialog(
          context,
          assertion,
          badge,
          opportunity,
          issuer,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: badge.image,
                width: badgeWidth,
                height: badgeWidth,
                placeholder: (context, message) => loadingSpinner(),
                errorWidget: (context, message, object) => Center(
                  child: Icon(Icons.error),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Text(
                  opportunity.title,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
}
