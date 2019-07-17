import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/assertion_bloc.dart';
import 'package:gentlestudent/src/blocs/opportunity_bloc.dart';
import 'package:gentlestudent/src/blocs/participant_bloc.dart';
import 'package:gentlestudent/src/blocs/participation_bloc.dart';
import 'package:gentlestudent/src/models/badge.dart';
import 'package:gentlestudent/src/models/enums/difficulty.dart';
import 'package:gentlestudent/src/models/enums/status.dart';
import 'package:gentlestudent/src/models/issuer.dart';
import 'package:gentlestudent/src/models/opportunity.dart';
import 'package:gentlestudent/src/models/participation.dart';
import 'package:gentlestudent/src/views/authentication/widgets/app_bar.dart';
import 'package:gentlestudent/src/views/main/opportunities/opportunity_detail_page/widgets/generic_registration_dialog.dart';
import 'package:gentlestudent/src/views/main/opportunities/opportunity_detail_page/widgets/opportunity_header.dart';
import 'package:gentlestudent/src/views/main/opportunities/opportunity_detail_page/widgets/opportunity_info_box.dart';
import 'package:gentlestudent/src/views/main/opportunities/opportunity_detail_page/widgets/show_claim_badge_dialog.dart';
import 'package:gentlestudent/src/views/main/opportunities/opportunity_detail_page/widgets/show_registration_dialog.dart';
import 'package:gentlestudent/src/widgets/loading_spinner.dart';
import 'package:provider/provider.dart';

class OpportunityDetailPage extends StatelessWidget {
  final Opportunity opportunity;

  OpportunityDetailPage({this.opportunity});

  Future<void> _enrollInOpportunity(
    ParticipationBloc participationBloc,
    BuildContext context,
    OpportunityBloc opportunityBloc,
  ) async {
    Issuer issuer = await opportunityBloc.getIssuerOfOpportunity(opportunity);
    final isSucces = await participationBloc.enrollInOpportunity(opportunity, issuer);
    isSucces
        ? genericRegistrationDialog(
            context,
            "Doe mee",
            "Je doet nu mee aan deze leerkans!",
          )
        : genericRegistrationDialog(
            context,
            "Doe mee",
            "Er ging iets mis bij het inschrijven voor deze leerkans, probeer het opnieuw.",
          );
  }

  Future<void> _claimBadge(
    BuildContext context,
    OpportunityBloc opportunityBloc,
    AssertionBloc assertionBloc,
    ParticipationBloc participationBloc,
  ) async {
    String message = await showClaimBadgeDialog(context);
    if (message == "") {
      genericRegistrationDialog(
        context,
        "Claim badge",
        "Het veld was leeg. Je moet aantonen waarom je in aanmerking komt voor deze badge.",
      );
    } else if (message != null) {
      Badge badge = await opportunityBloc.getBadgeOfOpportunity(opportunity);
      if (badge != null) {
        bool isAssertionCreationSucces = await assertionBloc.claimBadge(badge);
        bool isUpdateSucces =
            await participationBloc.updateParticipationAfterBadgeClaim(message);

        isAssertionCreationSucces && isUpdateSucces
            ? genericRegistrationDialog(
                context,
                "Claim badge",
                "Je hebt de badge succesvol geclaimd! Deze is nu zichbaar in je backpack.",
              )
            : genericRegistrationDialog(
                context,
                "Claim badge",
                "Er is iets fout gegaan tijdens het claimen van de badge. Controleer je internetverbinding en probeer het opnieuw.",
              );
      } else {
        genericRegistrationDialog(
          context,
          "Claim badge",
          "Er is iets fout gegaan tijdens het claimen van de badge. Controleer je internetverbinding en probeer het opnieuw.",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _opportunityBloc = Provider.of<OpportunityBloc>(context);
    final _participantBloc = Provider.of<ParticipantBloc>(context);
    final _participationBloc = Provider.of<ParticipationBloc>(context);
    final _assertionBloc = Provider.of<AssertionBloc>(context);
    _participationBloc.fetchParticipationByOpportunity(opportunity);
    final imageWidth = MediaQuery.of(context).size.width / 5;

    return Scaffold(
      appBar: appBar("Doe mee"),
      body: ListView(
        children: <Widget>[
          opportunityHeader(
            _opportunityBloc,
            imageWidth,
            _participantBloc,
            context,
            opportunity,
          ),
          opportunityBigImage(),
          opportunityInfoBox(
            _opportunityBloc,
            opportunity,
          ),
          opportunityShortDescription(),
          opportunityLongDescription(),
          enrollButton(_participationBloc, _assertionBloc, _opportunityBloc),
        ],
      ),
    );
  }

  Widget opportunityBigImage() => CachedNetworkImage(
        imageUrl: opportunity.opportunityImageUrl,
        placeholder: (context, message) => loadingSpinner(),
        errorWidget: (context, message, object) => Icon(Icons.error),
      );

  Widget opportunityShortDescription() => Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 4),
        child: TextField(
          controller: TextEditingController(text: opportunity.shortDescription),
          readOnly: true,
          maxLines: null,
          decoration: null,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget opportunityLongDescription() => Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 10),
        child: TextField(
          controller: TextEditingController(text: opportunity.longDescription),
          readOnly: true,
          maxLines: null,
          decoration: null,
          style: TextStyle(fontSize: 14),
        ),
      );

  Widget enrollButton(
    ParticipationBloc participationBloc,
    AssertionBloc assertionBloc,
    OpportunityBloc opportunityBloc,
  ) =>
      StreamBuilder(
        stream: participationBloc.selectedParticipation,
        builder: (BuildContext context, AsyncSnapshot<Participation> snapshot) {
          // The participation is still loading.
          if (!snapshot.hasData) {
            return Container();
          }

          // There isn't a participation yet, so the user can enroll in the learning opportunity.
          if (snapshot.data.opportunityId == null) {
            return opportunityButton(
              "Doe mee aan deze leerkans",
              () => showRegistrationDialog(
                context,
                opportunity,
                () => _enrollInOpportunity(participationBloc, context, opportunityBloc),
              ),
            );
          }

          // If we made it this far, there already is a participation for this learning opportunity.
          // If this is a beginner's badge and the status of the participation is pending, the user can claim the badge.
          if (snapshot.data.status != null &&
              snapshot.data.status == Status.PENDING &&
              opportunity.difficulty == Difficulty.BEGINNER) {
            return opportunityButton(
              "Claim de badge",
              () => _claimBadge(
                  context, opportunityBloc, assertionBloc, participationBloc),
            );
          } else {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Text(
                "Je doet al mee aan deze leerkans",
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      );

  Widget opportunityButton(String text, Function onPressed) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                color: Colors.lightBlueAccent,
                onPressed: onPressed,
                padding: EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      );
}
