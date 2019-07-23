import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/participant_bloc.dart';
import 'package:gentlestudent/src/blocs/token_bloc.dart';
import 'package:gentlestudent/src/constants/string_constants.dart';
import 'package:gentlestudent/src/models/participant.dart';
import 'package:gentlestudent/src/models/token.dart';
import 'package:gentlestudent/src/views/main/user/profile_page/edit_profile_page/edit_profile_page.dart';
import 'package:gentlestudent/src/views/main/user/profile_page/token_page/token_page.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  void _navigateToTokenPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => TokenPage(),
      ),
    );
  }

  void _navigateToEditProfilePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => EditProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _participantBloc = Provider.of<ParticipantBloc>(context);
    final _tokenBloc = Provider.of<TokenBloc>(context);
    double _headerHeight = MediaQuery.of(context).size.height / 3.5;
    double _tokenImageWidth = MediaQuery.of(context).size.width / 4;
    _tokenBloc.fetchTokens();

    return Scaffold(
      appBar: AppBar(
      centerTitle: true,
      title: Text(
        "Profiel",
        style: TextStyle(color: Colors.white),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () => _navigateToEditProfilePage(context),
          icon: Icon(Icons.edit),
          tooltip: "Klik hier om je profiel te bewerken",
        ),
      ],
    ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: _participantBloc.participant,
            builder:
                (BuildContext context, AsyncSnapshot<Participant> snapshot) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  profileHeader(snapshot.data, _headerHeight, context),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 2,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          width: double.infinity,
                          child: Column(
                            children: <Widget>[
                              profileLabel("E-mailadres:", context),
                              SizedBox(height: 4),
                              profileField(snapshot.data?.email ?? "", context),
                              SizedBox(height: 12),
                              profileLabel("Onderwijsinstelling:", context),
                              SizedBox(height: 4),
                              profileField(
                                  snapshot.data?.institute ?? "", context),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 2,
                      child: InkWell(
                        onTap: () => _navigateToTokenPage(context),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            children: <Widget>[
                              tokenLogo(_tokenImageWidth),
                              SizedBox(width: 20),
                              Expanded(
                                child: tokenText(_tokenBloc),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget profileHeader(
    Participant participant,
    double headerHeight,
    BuildContext context,
  ) =>
      Container(
        width: double.infinity,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black26
            : Colors.lightBlueAccent,
        height: headerHeight,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            profilePicture(participant, headerHeight),
            participantName(participant),
          ],
        ),
      );

  Widget profilePicture(Participant participant, double headerHeight) =>
      Container(
        child: participant != null &&
                participant.profilePicture != null &&
                participant.profilePicture != ""
            ? Container(
                width: headerHeight / 1.35,
                height: headerHeight / 1.35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(360),
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(360),
                  child: Image.network(
                    participant.profilePicture,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Icon(
                Icons.account_circle,
                size: headerHeight / 1.25,
                color: Colors.white,
              ),
      );

  Widget participantName(Participant participant) => Text(
        participant?.name ?? "",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 24,
        ),
      );

  Widget profileLabel(String text, BuildContext context) => Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white70
              : Colors.black45,
        ),
      );

  Widget profileField(String text, BuildContext context) => Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white70
              : Colors.black45,
        ),
      );

  Widget tokenLogo(double width) => SizedBox(
        width: width,
        height: width,
        child: CachedNetworkImage(
          imageUrl: tokenGenericImageUrl,
          placeholder: (context, message) => CircularProgressIndicator(),
          errorWidget: (context, message, object) => Icon(Icons.error),
        ),
      );

  Widget tokenText(TokenBloc bloc) => StreamBuilder(
        stream: bloc.tokens,
        builder: (BuildContext context, AsyncSnapshot<List<Token>> snapshot) {
          if (!snapshot.hasData) {
            return Text("");
          }

          if (snapshot.data.isEmpty) {
            return Text(
              "Je hebt nog geen tokens verdiend. Voltooi een quest om je eerste token te verdienen!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black45,
              ),
              textAlign: TextAlign.center,
            );
          }

          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'NeoSansPro',
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black45,
              ),
              children: <TextSpan>[
                TextSpan(text: "Gefelicitieerd! Je hebt al\n"),
                TextSpan(
                  text:
                      "${snapshot.data.length} ${snapshot.data.length > 1 ? 'tokens' : 'token'}",
                  style: TextStyle(
                    color: Colors.lightBlue,
                  ),
                ),
                TextSpan(text: " verdiend\n\n"),
                TextSpan(
                    text:
                        "Klik hier om je\n${snapshot.data.length > 1 ? 'tokens' : 'token'} te bekijken"),
              ],
            ),
          );
        },
      );
}
