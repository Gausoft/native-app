import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/opportunity_bloc.dart';
import 'package:gentlestudent/src/blocs/participation_bloc.dart';
import 'package:gentlestudent/src/models/opportunity.dart';
import 'package:gentlestudent/src/models/participation.dart';
import 'package:gentlestudent/src/views/main/opportunities/opportunities_list_page/widgets/opportunity_list_item.dart';
import 'package:gentlestudent/src/widgets/loading_spinner.dart';
import 'package:provider/provider.dart';

class ParticipationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _participationBloc = Provider.of<ParticipationBloc>(context);
    final _opportunityBloc = Provider.of<OpportunityBloc>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: Text(
                  'Mijn leerkansen',
                  style: TextStyle(color: Colors.white),
                ),
                iconTheme: IconThemeData(color: Colors.white),
                forceElevated: innerBoxIsScrolled,
                pinned: true,
                floating: true,
                bottom: TabBar(
                  labelColor: Colors.white,
                  tabs: <Tab>[
                    Tab(text: 'Goedgekeurde'),
                    Tab(text: 'Geregistreerde'),
                  ],
                ),
              ),
            ];
          },
          body: _buildBody(
            _opportunityBloc,
            _participationBloc,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    OpportunityBloc opportunityBloc,
    ParticipationBloc participationBloc,
  ) =>
      TabBarView(
        children: <Widget>[
          _buildApprovedParticipations(
            opportunityBloc,
            participationBloc,
          ),
          _buildRequestedParticipations(
            opportunityBloc,
            participationBloc,
          ),
        ],
      );

  Widget _buildApprovedParticipations(
    OpportunityBloc opportunityBloc,
    ParticipationBloc participationBloc,
  ) =>
      StreamBuilder(
        stream: participationBloc.approvedParticipations,
        builder: (context, AsyncSnapshot<List<Participation>> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              child: loadingSpinner(),
            );
          }

          if (snapshot.data.isEmpty) {
            return Container(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  "Er zijn momenteel geen leerkansen waarvoor je goedgekeurd bent",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: snapshot.data.length,
            itemBuilder: (_, int index) {
              return FutureBuilder(
                future: opportunityBloc.getOpportunityById(snapshot.data[index].opportunityId),
                builder: (context, AsyncSnapshot<Opportunity> snapshot) {
                  if (!snapshot.hasData || snapshot.data.title == null || snapshot.data.title.isEmpty) {
                    return _opportunityLoadingContainer(context);
                  }

                  return OpportunityListItem(snapshot.data);
                },
              );
            },
          );
        },
      );

  Widget _buildRequestedParticipations(
    OpportunityBloc opportunityBloc,
    ParticipationBloc participationBloc,
  ) =>
      StreamBuilder(
        stream: participationBloc.requestedParticipations,
        builder: (context, AsyncSnapshot<List<Participation>> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              child: loadingSpinner(),
            );
          }

          if (snapshot.data.isEmpty) {
            return Container(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  "Er zijn momenteel geen leerkansen waarvoor je geregistreerd bent",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: snapshot.data.length,
            itemBuilder: (_, int index) {
              return FutureBuilder(
                future: opportunityBloc.getOpportunityById(snapshot.data[index].opportunityId),
                builder: (context, AsyncSnapshot<Opportunity> snapshot) {
                  if (!snapshot.hasData || snapshot.data.title == null || snapshot.data.title.isEmpty) {
                    return _opportunityLoadingContainer(context);
                  }

                  return OpportunityListItem(snapshot.data);
                },
              );
            },
          );
        },
      );

  Widget _opportunityLoadingContainer(BuildContext context) {
    final height = MediaQuery.of(context).size.width / 5;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(bottom: 8),
      elevation: 3,
      child: Container(
        height: height,
        margin: EdgeInsets.fromLTRB(10, 10, 16, 10),
      ),
    );
  }
}
