import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/opportunity_bloc.dart';
import 'package:gentlestudent/src/models/address.dart';
import 'package:gentlestudent/src/models/issuer.dart';
import 'package:gentlestudent/src/models/opportunity.dart';
import 'package:gentlestudent/src/utils/date_utils.dart';
import 'package:gentlestudent/src/utils/string_utils.dart';
import 'package:gentlestudent/src/utils/web_launcher_utils.dart';

Widget opportunityInfoBox(OpportunityBloc bloc, Opportunity opportunity) =>
    Padding(
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
            opportunityCategory(opportunity),
            SizedBox(height: 6),
            opportunityPeriod(opportunity),
            SizedBox(height: 6),
            opportunityLocation(bloc, opportunity),
            SizedBox(height: 6),
            opportunityIssuer(bloc, opportunity),
            SizedBox(height: 6),
            opportunityContact(opportunity),
            SizedBox(height: 6),
            opportunityWebsite(opportunity),
          ],
        ),
      ),
    );

Widget opportunityCategory(Opportunity opportunity) => Text(
      StringUtils.getCategory(opportunity),
      style: TextStyle(
        fontStyle: FontStyle.italic,
        fontSize: 14,
        color: Colors.lightBlue,
      ),
    );

Widget opportunityPeriod(Opportunity opportunity) => Row(
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

Widget opportunityLocation(OpportunityBloc bloc, Opportunity opportunity) =>
    Row(
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

Widget opportunityIssuer(OpportunityBloc bloc, Opportunity opportunity) => Row(
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

Widget opportunityContact(Opportunity opportunity) => Row(
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

Widget opportunityWebsite(Opportunity opportunity) => Row(
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
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
