import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/opportunity_bloc.dart';
import 'package:gentlestudent/src/blocs/participant_bloc.dart';
import 'package:gentlestudent/src/models/address.dart';
import 'package:gentlestudent/src/models/badge.dart';
import 'package:gentlestudent/src/models/issuer.dart';
import 'package:gentlestudent/src/models/opportunity.dart';
import 'package:gentlestudent/src/models/participant.dart';
import 'package:gentlestudent/src/utils/date_utils.dart';
import 'package:gentlestudent/src/utils/string_utils.dart';
import 'package:gentlestudent/src/utils/web_launcher_utils.dart';
import 'package:gentlestudent/src/widgets/loading_spinner.dart';
import 'package:provider/provider.dart';

class OpportunityDetailPage extends StatelessWidget {
  final Opportunity opportunity;

  OpportunityDetailPage({this.opportunity});

  @override
  Widget build(BuildContext context) {
    final _opportunityBloc = Provider.of<OpportunityBloc>(context);
    final _participantBloc = Provider.of<ParticipantBloc>(context);
    final imageWidth = MediaQuery.of(context).size.width / 5;

    return Scaffold(
      appBar: opportunityAppBar(),
      body: ListView(
        children: <Widget>[
          opportunityHeader(
            _opportunityBloc,
            imageWidth,
            _participantBloc,
            context,
          ),
          opportunityBigImage(),
          opportunityInfoBox(_opportunityBloc),
          opportunityShortDescription(),
          opportunityLongDescription(),

          //Button
          //_showButton(),
        ],
      ),
    );
  }

  Widget opportunityAppBar() => AppBar(
        title: Text(
          "Registreren",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      );

  Widget opportunityHeader(OpportunityBloc opportunityBloc, double imageWidth,
          ParticipantBloc participantBloc, BuildContext context) =>
      Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            opportunityLogo(opportunityBloc, imageWidth),
            opportunityTitle(context),
            opportunityStars(),
            opportunityHeart(participantBloc),
          ],
        ),
      );

  Widget opportunityStars() => Row(
        children: List.generate(
          opportunity.difficulty.index + 1,
          (index) => Icon(
            Icons.star,
            color: Colors.yellow,
          ),
        ),
      );

  Widget opportunityHeart(ParticipantBloc bloc) => StreamBuilder(
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

  Widget opportunityLogo(OpportunityBloc bloc, double imageWidth) =>
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

  Widget opportunityTitle(BuildContext context) => Expanded(
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

  Widget opportunityBigImage() => CachedNetworkImage(
        imageUrl: opportunity.opportunityImageUrl,
        placeholder: (context, message) => loadingSpinner(),
        errorWidget: (context, message, object) => Icon(Icons.error),
      );

  Widget opportunityInfoBox(OpportunityBloc bloc) => Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Container(
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.lightBlue),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              opportunityCategory(),
              SizedBox(height: 6),
              opportunityPeriod(),
              SizedBox(height: 6),
              opportunityLocation(bloc),
              SizedBox(height: 6),
              opportunityIssuer(bloc),
              SizedBox(height: 6),
              opportunityContact(),
              SizedBox(height: 6),
              opportunityWebsite(),
            ],
          ),
        ),
      );

  Widget opportunityCategory() => Text(
        StringUtils.getCategory(opportunity),
        style: TextStyle(
          fontStyle: FontStyle.italic,
          fontSize: 14,
          color: Colors.lightBlue,
        ),
      );

  Widget opportunityPeriod() => Row(
        children: <Widget>[
          Text(
            "Periode: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.lightBlue,
            ),
          ),
          Expanded(
            child: Text(
              "van ${DateUtils.formatDate(opportunity.beginDate)} tot ${DateUtils.formatDate(opportunity.endDate)}",
              style: TextStyle(
                fontSize: 14,
                color: Colors.lightBlue,
              ),
            ),
          ),
        ],
      );

  Widget opportunityLocation(OpportunityBloc bloc) => Row(
        children: <Widget>[
          Text(
            "Plaats: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.lightBlue,
            ),
          ),
          FutureBuilder(
            future: bloc.getAddressOfOpportunity(opportunity),
            builder: (BuildContext context, AsyncSnapshot<Address> snapshot) {
              return Expanded(
                child: Text(
                  !snapshot.hasData
                      ? ""
                      : "${snapshot.data.street} ${snapshot.data.housenumber} ${snapshot.data.bus}, ${snapshot.data.postalcode} ${snapshot.data.city}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.lightBlue,
                  ),
                ),
              );
            },
          ),
        ],
      );

  Widget opportunityIssuer(OpportunityBloc bloc) => Row(
        children: <Widget>[
          Text(
            "Issuer: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.lightBlue,
            ),
          ),
          FutureBuilder(
            future: bloc.getIssuerOfOpportunity(opportunity),
            builder: (BuildContext context, AsyncSnapshot<Issuer> snapshot) {
              return Expanded(
                child: Text(
                  !snapshot.hasData ? "" : "${snapshot.data.name}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.lightBlue,
                  ),
                ),
              );
            },
          ),
        ],
      );

  Widget opportunityContact() => Row(
        children: <Widget>[
          Text(
            "Contact: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.lightBlue,
            ),
          ),
          Expanded(
            child: Text(
              "${opportunity.contact}",
              style: TextStyle(
                fontSize: 14,
                color: Colors.lightBlue,
              ),
            ),
          ),
        ],
      );

  Widget opportunityWebsite() => Row(
        children: <Widget>[
          Text(
            "Website: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.lightBlue,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => WebLauncherUtils.launchURL(opportunity.website),
              child: Text(
                "${opportunity.website}",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.lightBlue,
                    decoration: TextDecoration.underline),
              ),
            ),
          ),
        ],
      );

  // Widget opportunityShortDescription() => Padding(
  //       padding: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 8),
  //       child: Text(
  //         opportunity.shortDescription,
  //         style: TextStyle(
  //           fontSize: 14,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //     );

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
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      );
}
