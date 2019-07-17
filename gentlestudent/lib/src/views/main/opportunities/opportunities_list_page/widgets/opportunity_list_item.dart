import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/opportunity_bloc.dart';
import 'package:gentlestudent/src/models/badge.dart';
import 'package:gentlestudent/src/models/issuer.dart';
import 'package:gentlestudent/src/models/opportunity.dart';
import 'package:gentlestudent/src/models/participation.dart';
import 'package:gentlestudent/src/utils/string_utils.dart';
import 'package:gentlestudent/src/views/main/opportunities/opportunity_detail_page/opportunity_detail_page.dart';
import 'package:provider/provider.dart';

class OpportunityListItem extends StatelessWidget {
  final Opportunity opportunity;
  final bool isRequested;
  final Participation participation;

  OpportunityListItem(this.opportunity,
      [this.isRequested = false, this.participation]);

  @override
  Widget build(BuildContext context) {
    final _opportunityBloc = Provider.of<OpportunityBloc>(context);
    final imageWidth = MediaQuery.of(context).size.width / 5;

    void _navigateToOpportunityDetailPage() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              OpportunityDetailPage(opportunity: opportunity),
        ),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(bottom: 8),
      elevation: 3,
      child: Container(
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: _navigateToOpportunityDetailPage,
          child: Row(
            children: <Widget>[
              opportunityLogo(opportunity, _opportunityBloc, imageWidth),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 16, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      opportunityTitle(opportunity, context),
                      SizedBox(height: 4),
                      opportunitySubtitle(
                        opportunity,
                        _opportunityBloc,
                        isRequested,
                        participation,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget opportunityLogo(
        Opportunity opportunity, OpportunityBloc bloc, double imageWidth) =>
    Padding(
      padding: EdgeInsets.fromLTRB(12, 8, 4, 8),
      child: FutureBuilder(
        future: bloc.getBadgeOfOpportunity(opportunity),
        builder: (BuildContext context, AsyncSnapshot<Badge> snapshot) {
          return !snapshot.hasData
              ? Container(width: imageWidth, height: imageWidth)
              : SizedBox(
                  width: imageWidth,
                  height: imageWidth,
                  child: CachedNetworkImage(
                    imageUrl: snapshot.data.image,
                    placeholder: (context, message) =>
                        CircularProgressIndicator(),
                    errorWidget: (context, message, object) =>
                        Icon(Icons.error),
                  ),
                );
        },
      ),
    );

Widget opportunityTitle(Opportunity opportunity, BuildContext context) => Text(
      opportunity.title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black54,
        fontSize: 21,
      ),
    );

Widget opportunitySubtitle(
  Opportunity opportunity,
  OpportunityBloc bloc,
  bool isRequested,
  Participation participation,
) =>
    isRequested
        ? Text(
            "Status: ${StringUtils.getStatus(participation)} \n${StringUtils.getReason(participation)}")
        : FutureBuilder(
            future: bloc.getIssuerOfOpportunity(opportunity),
            builder: (BuildContext context, AsyncSnapshot<Issuer> snapshot) {
              return Text(
                !snapshot.hasData
                    ? ""
                    : StringUtils.getCategory(opportunity) +
                        " - " +
                        StringUtils.getDifficulty(opportunity) +
                        "\n" +
                        snapshot.data.name,
              );
            },
          );
