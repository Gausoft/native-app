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
          body: StreamBuilder(
            stream: _opportunityBloc.opportunities,
            builder: (BuildContext context,
                AsyncSnapshot<List<Opportunity>> opportunitiesSnapshot) {
              if (!opportunitiesSnapshot.hasData) {
                return Container(
                  child: loadingSpinner(),
                );
              }

              if (opportunitiesSnapshot.data.isEmpty) {
                return Container(
                  child: Text(
                    "Er zijn momenteel geen leerkansen beschikbaar",
                  ),
                );
              }

              return TabBarView(
                children: <Widget>[
                  StreamBuilder(
                    stream: _participationBloc.approvedParticipations,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Participation>>
                            approvedParticipationsSnapshot) {
                      if (!approvedParticipationsSnapshot.hasData) {
                        return Container(
                          child: loadingSpinner(),
                        );
                      }

                      if (approvedParticipationsSnapshot.data.isEmpty) {
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
                        itemCount: approvedParticipationsSnapshot.data.length,
                        itemBuilder: (_, int index) {
                          return OpportunityListItem(
                            opportunitiesSnapshot.data.firstWhere(
                              (o) =>
                                  o.opportunityId ==
                                  approvedParticipationsSnapshot
                                      .data[index].opportunityId,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  StreamBuilder(
                    stream: _participationBloc.requestedParticipations,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Participation>>
                            requestedParticipationsSnapshot) {
                      if (!requestedParticipationsSnapshot.hasData) {
                        return Container(
                          child: loadingSpinner(),
                        );
                      }

                      if (requestedParticipationsSnapshot.data.isEmpty) {
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
                        itemCount: requestedParticipationsSnapshot.data.length,
                        itemBuilder: (_, int index) {
                          return OpportunityListItem(
                            opportunitiesSnapshot.data.firstWhere(
                              (o) =>
                                  o.opportunityId ==
                                  requestedParticipationsSnapshot
                                      .data[index].opportunityId,
                            ),
                            true,
                            requestedParticipationsSnapshot.data[index],
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
