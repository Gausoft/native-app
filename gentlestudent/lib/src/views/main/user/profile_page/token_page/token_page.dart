import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gentlestudent/src/blocs/quest_bloc.dart';
import 'package:gentlestudent/src/blocs/token_bloc.dart';
import 'package:gentlestudent/src/constants/string_constants.dart';
import 'package:gentlestudent/src/models/quest.dart';
import 'package:gentlestudent/src/models/token.dart';
import 'package:gentlestudent/src/views/authentication/widgets/app_bar.dart';
import 'package:gentlestudent/src/views/main/user/profile_page/token_page/widgets/token_dialog.dart';
import 'package:gentlestudent/src/widgets/loading_spinner.dart';
import 'package:provider/provider.dart';

class TokenPage extends StatelessWidget {
  Future<List<Widget>> _buildTokens(
    List<Token> tokens,
    double tokenWidth,
    QuestBloc bloc,
    BuildContext context,
  ) async {
    List<Widget> tokenWidgets = [];

    for (int i = 0; i < tokens.length; i++) {
      Quest quest = await bloc.fetchQuestById(tokens[i].questId);

      tokenWidgets.add(
        gridToken(
          context,
          tokens[i],
          quest,
          tokenWidth,
        ),
      );
    }

    return tokenWidgets;
  }

  @override
  Widget build(BuildContext context) {
    final _tokenBloc = Provider.of<TokenBloc>(context);
    final _questBloc = Provider.of<QuestBloc>(context);
    final _badgeWidth = MediaQuery.of(context).size.width / 5;

    return Scaffold(
      appBar: appBar("Tokens"),
      body: StreamBuilder(
        stream: _tokenBloc.tokens,
        builder: (BuildContext context, AsyncSnapshot<List<Token>> snapshot) {
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
                  "Je hebt nog geen tokens verdiend. Voltooi een quest om je eerste token te verdienen!",
                ),
              ),
            );
          }

          return FutureBuilder(
            future: _buildTokens(
              snapshot.data,
              _badgeWidth,
              _questBloc,
              context,
            ),
            builder: (BuildContext context, AsyncSnapshot<List<Widget>> tokensSnapshot) {
              if (!tokensSnapshot.hasData) {
                return Container(
                  child: loadingSpinner(),
                );
              }

              return GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 0.7,
                children: <Widget>[
                  ...tokensSnapshot.data,
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget gridToken(
    BuildContext context,
    Token token,
    Quest quest,
    double tokenWidth,
  ) =>
      InkWell(
        onTap: () => displayTokenDialog(context, token, quest),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: tokenWidth,
                height: tokenWidth,
                child: CachedNetworkImage(
                  imageUrl: tokenGenericImageUrl,
                  placeholder: (context, message) => loadingSpinner(),
                  errorWidget: (context, message, object) =>
                      Center(child: Icon(Icons.error)),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Text(
                  quest.title,
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
}
