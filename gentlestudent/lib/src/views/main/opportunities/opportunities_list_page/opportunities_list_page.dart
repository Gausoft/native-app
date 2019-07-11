import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/opportunity_bloc.dart';
import 'package:gentlestudent/src/models/opportunity.dart';
import 'package:gentlestudent/src/views/main/opportunities/opportunities_list_page/widgets/opportunity_list_item.dart';
import 'package:gentlestudent/src/widgets/loading_spinner.dart';
import 'package:provider/provider.dart';

class OpportunitiesListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _opportunityBloc = Provider.of<OpportunityBloc>(context);

    return Container(
      child: StreamBuilder(
        stream: _opportunityBloc.filteredOpportunities,
        builder:
            (BuildContext context, AsyncSnapshot<List<Opportunity>> snapshot) {
          if (!snapshot.hasData) {
            return loadingSpinner();
          }

          if (snapshot.data.isEmpty) {
            return Container(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text("Er zijn momenteel geen leerkansen beschikbaar"),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: snapshot.data.length,
            itemBuilder: (_, int index) {
              return OpportunityListItem(snapshot.data[index]);
            },
          );
        },
      ),
    );
  }
}
