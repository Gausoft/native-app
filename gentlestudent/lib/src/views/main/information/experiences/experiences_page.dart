import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/experiences_bloc.dart';
import 'package:gentlestudent/src/models/experience.dart';
import 'package:gentlestudent/src/views/authentication/widgets/app_bar.dart';
import 'package:gentlestudent/src/views/main/information/experiences/widgets/experience_card.dart';
import 'package:gentlestudent/src/widgets/loading_spinner.dart';

class ExperiencesPage extends StatefulWidget {
  _ExperiencesPageState createState() => _ExperiencesPageState();
}

class _ExperiencesPageState extends State<ExperiencesPage> {
  ExperiencesBloc _experiencesBloc;

  @override
  void initState() {
    super.initState();
    _experiencesBloc = ExperiencesBloc();
  }

  @override
  void dispose() {
    _experiencesBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("Ervaringen"),
      body: StreamBuilder(
        stream: _experiencesBloc.experiences,
        builder:
            (BuildContext context, AsyncSnapshot<List<Experience>> snapshot) {
          if (!snapshot.hasData) {
            return loadingSpinner();
          }

          if (snapshot.data.isEmpty) {
            return Container(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text("Er zijn momenteel geen ervaringen beschikbaar"),
              ),
            );
          }

          return Container(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: snapshot.data.length,
              itemBuilder: (_, int index) {
                final experienceItem = snapshot.data[index];
                return ExperienceCard(experience: experienceItem);
              },
            ),
          );
        },
      ),
    );
  }
}
