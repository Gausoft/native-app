import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/opportunity_bloc.dart';
import 'package:gentlestudent/src/blocs/participant_bloc.dart';
import 'package:gentlestudent/src/models/badge.dart';
import 'package:gentlestudent/src/models/opportunity.dart';
import 'package:gentlestudent/src/models/participant.dart';

Widget opportunityHeader(OpportunityBloc opportunityBloc, double imageWidth,
          ParticipantBloc participantBloc, BuildContext context, Opportunity opportunity,) =>
      Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            opportunityLogo(opportunityBloc, imageWidth, opportunity),
            opportunityTitle(context, opportunity),
            opportunityStars(opportunity),
            opportunityHeart(participantBloc, opportunity),
          ],
        ),
      );

  Widget opportunityStars(Opportunity opportunity) => Row(
        children: List.generate(
          opportunity.difficulty.index + 1,
          (index) => Icon(
            Icons.star,
            color: Colors.yellow,
          ),
        ),
      );

  Widget opportunityHeart(ParticipantBloc bloc, Opportunity opportunity) => StreamBuilder(
        stream: bloc.participant,
        builder: (BuildContext context, AsyncSnapshot<Participant> snapshot) {
          if (!snapshot.hasData) {
            return Icon(
              Icons.favorite_border,
              color: Colors.red,
            );
          }

          return IconButton(
            onPressed: () => bloc.changeFavorites(opportunity),
            icon: Icon(
              snapshot.data.favorites.contains(opportunity.opportunityId)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
          );
        },
      );

  Widget opportunityLogo(OpportunityBloc bloc, double imageWidth, Opportunity opportunity) =>
      FutureBuilder(
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
      );

  Widget opportunityTitle(BuildContext context, Opportunity opportunity) => Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            opportunity.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black54,
              fontSize: 20,
            ),
          ),
        ),
      );