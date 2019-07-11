import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/opportunity_bloc.dart';
import 'package:gentlestudent/src/models/enums/category.dart';
import 'package:gentlestudent/src/models/enums/difficulty.dart';
import 'package:gentlestudent/src/views/authentication/widgets/app_bar.dart';
import 'package:provider/provider.dart';

class OpportunityFilterPage extends StatefulWidget {
  _OpportunityFilterPageState createState() => _OpportunityFilterPageState();
}

class _OpportunityFilterPageState extends State<OpportunityFilterPage> {
  TextEditingController opportunityNameController;

  void _clearFilter(OpportunityBloc bloc) {
    opportunityNameController.text = "";
    bloc.changeOpportunityName("");
    bloc.changeCategory(null);
    bloc.changeDifficulty(null);
  }

  @override
  void initState() {
    super.initState();
    opportunityNameController = TextEditingController();
  }

  @override
  void dispose() {
    opportunityNameController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _opportunityBloc = Provider.of<OpportunityBloc>(context);
    opportunityNameController.text =
        _opportunityBloc.opportunityNameFilterValue ?? "";

    return Scaffold(
      appBar: appBar("Filter leerkansen"),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 12),
                opportunityNameField(_opportunityBloc),
                SizedBox(height: 18),
                difficultyPicker(_opportunityBloc),
                SizedBox(height: 12),
                categoryPicker(_opportunityBloc),
                SizedBox(height: 48),
                clearFilterButton(_opportunityBloc),
                SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget opportunityNameField(OpportunityBloc bloc) => StreamBuilder(
        stream: bloc.opportunityNameFilter,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return TextField(
            controller: opportunityNameController,
            onChanged: bloc.changeOpportunityName,
            decoration: InputDecoration(
              labelText: 'Naam van de leerkans',
              errorText: snapshot.error,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      );

  Widget categoryPicker(OpportunityBloc bloc) => StreamBuilder(
        stream: bloc.categoryFilter,
        builder: (context, snapshot) {
          return InputDecorator(
            decoration: InputDecoration(
              labelText: 'Categorie',
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Category>(
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text("Alles"),
                  ),
                  DropdownMenuItem(
                    value: Category.DIGITALEGELETTERDHEID,
                    child: Text("Digitale geletterdheid"),
                  ),
                  DropdownMenuItem(
                    value: Category.DUURZAAMHEID,
                    child: Text("Duurzaamheid"),
                  ),
                  DropdownMenuItem(
                    value: Category.ONDERNEMINGSZIN,
                    child: Text("Ondernemingszin"),
                  ),
                  DropdownMenuItem(
                    value: Category.ONDERZOEK,
                    child: Text("Onderzoek"),
                  ),
                  DropdownMenuItem(
                    value: Category.WERELDBURGERSCHAP,
                    child: Text("Wereldburgerschap"),
                  ),
                ],
                onChanged: bloc.changeCategory,
                value: snapshot.data,
              ),
            ),
          );
        },
      );

  Widget difficultyPicker(OpportunityBloc bloc) => StreamBuilder(
        stream: bloc.difficultyFilter,
        builder: (context, snapshot) {
          return InputDecorator(
            decoration: InputDecoration(
              labelText: 'Niveau',
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Difficulty>(
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text("Alles"),
                  ),
                  DropdownMenuItem(
                    value: Difficulty.BEGINNER,
                    child: Text("Niveau 1"),
                  ),
                  DropdownMenuItem(
                    value: Difficulty.INTERMEDIATE,
                    child: Text("Niveau 2"),
                  ),
                  DropdownMenuItem(
                    value: Difficulty.EXPERT,
                    child: Text("Niveau 3"),
                  ),
                ],
                onChanged: bloc.changeDifficulty,
                value: snapshot.data,
              ),
            ),
          );
        },
      );

  Widget clearFilterButton(OpportunityBloc bloc) => Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              child: Text(
                "Reset de filter",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              color: Colors.lightBlueAccent,
              onPressed: () => _clearFilter(bloc),
              padding: EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      );
}
