import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/assertion_bloc.dart';
import 'package:gentlestudent/src/blocs/main_navigation_bloc.dart';
import 'package:gentlestudent/src/blocs/participant_bloc.dart';
import 'package:gentlestudent/src/blocs/participation_bloc.dart';
import 'package:gentlestudent/src/views/main/information/information_page.dart';
import 'package:gentlestudent/src/views/main/opportunities/opportunities_page.dart';
import 'package:gentlestudent/src/views/main/user/user_page.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  final List<Widget> _pages = [
    InformationPage(),
    OpportunitiesPage(),
    UserPage()
  ];

  @override
  Widget build(BuildContext context) {
    final _mainNavigationBloc = Provider.of<MainNavigationBloc>(context);
    final _participantBloc = Provider.of<ParticipantBloc>(context);
    final _assertionBloc = Provider.of<AssertionBloc>(context);
    final _participationBloc = Provider.of<ParticipationBloc>(context);
    _participantBloc.fetchParticipant();
    _assertionBloc.fetchAssertions();
    _participationBloc.fetchParticipations();

    return StreamBuilder(
      stream: _mainNavigationBloc.currentIndex,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        int index = snapshot.hasData ? snapshot.data : 1;

        return Scaffold(
          body: _pages[index],
          bottomNavigationBar: mainBottomNavBar(index, _mainNavigationBloc),
        );
      },
    );
  }

  Widget mainBottomNavBar(int index, MainNavigationBloc bloc) =>
      BottomNavigationBar(
        fixedColor: Colors.lightBlue,
        currentIndex: index,
        onTap: (int numTab) => bloc.changeCurrentIndex(numTab),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            title: Text(
              "Informatie",
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            title: Text(
              "Leerkansen",
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text(
              "Gebruiker",
            ),
          )
        ],
      );
}
