import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/opportunity_bloc.dart';
import 'package:gentlestudent/src/blocs/participant_bloc.dart';
import 'package:gentlestudent/src/blocs/participation_bloc.dart';
import 'package:gentlestudent/src/models/opportunity.dart';
import 'package:gentlestudent/src/views/authentication/widgets/app_bar.dart';
import 'package:gentlestudent/src/views/main/opportunities/opportunity_detail_page/widgets/opportunity_header.dart';
import 'package:gentlestudent/src/views/main/opportunities/opportunity_detail_page/widgets/opportunity_info_box.dart';
import 'package:gentlestudent/src/widgets/loading_spinner.dart';
import 'package:provider/provider.dart';

class OpportunityDetailPage extends StatelessWidget {
  final Opportunity opportunity;

  OpportunityDetailPage({this.opportunity});

  @override
  Widget build(BuildContext context) {
    final _opportunityBloc = Provider.of<OpportunityBloc>(context);
    final _participantBloc = Provider.of<ParticipantBloc>(context);
    final _participationBloc = Provider.of<ParticipationBloc>(context);
    final imageWidth = MediaQuery.of(context).size.width / 5;

    return Scaffold(
      appBar: appBar("Registreren"),
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
          enlistButton(_opportunityBloc),
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

  Widget enlistButton(OpportunityBloc bloc) => Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                child: Text(
                  "Registreer voor deze leerkans",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                color: Colors.lightBlueAccent,
                onPressed: () => {},
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
