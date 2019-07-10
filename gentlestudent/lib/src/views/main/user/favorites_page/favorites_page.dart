import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/opportunity_bloc.dart';
import 'package:gentlestudent/src/blocs/participant_bloc.dart';
import 'package:gentlestudent/src/models/opportunity.dart';
import 'package:gentlestudent/src/models/participant.dart';
import 'package:gentlestudent/src/views/authentication/widgets/app_bar.dart';
import 'package:gentlestudent/src/views/main/opportunities/opportunities_list_page/widgets/opportunity_list_item.dart';
import 'package:gentlestudent/src/widgets/loading_spinner.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _opportunityBloc = Provider.of<OpportunityBloc>(context);
    final _participantBloc = Provider.of<ParticipantBloc>(context);

    return Scaffold(
      appBar: appBar("Favorieten"),
      body: Container(
        child: StreamBuilder(
          stream: _opportunityBloc.opportunities,
          builder: (BuildContext context,
              AsyncSnapshot<List<Opportunity>> snapshotOpportunities) {
            if (!snapshotOpportunities.hasData) {
              return loadingSpinner();
            }

            return StreamBuilder(
              stream: _participantBloc.participant,
              builder: (BuildContext context,
                  AsyncSnapshot<Participant> snapshotParticipant) {
                if (!snapshotParticipant.hasData) {
                  _participantBloc.fetchParticipant();
                  return loadingSpinner();
                }

                List<Opportunity> favorites = snapshotOpportunities.data
                    .where((o) => snapshotParticipant.data.favorites
                        .contains(o.opportunityId))
                    .toList();

                if (favorites.isEmpty) {
                  return Center(
                    child: Text("Je hebt nog geen favorieten"),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: favorites.length,
                  itemBuilder: (_, int index) {
                    return OpportunityListItem(favorites[index]);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
