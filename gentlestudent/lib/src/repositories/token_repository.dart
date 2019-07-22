import 'package:firebase_auth/firebase_auth.dart';
import 'package:gentlestudent/src/models/quest.dart';
import 'package:gentlestudent/src/models/quest_taker.dart';
import 'package:gentlestudent/src/models/token.dart';
import 'package:gentlestudent/src/network/token_api.dart';

class TokenRepository {
  final TokenApi _tokenApi = TokenApi();

  List<Token> _tokens;
  Future<List<Token>> get tokens async {
    if (_tokens == null || _tokens.isEmpty) {
      await _fetchTokens();
    } else {
      _fetchTokens();
    }
    return _tokens;
  }

  Future<void> _fetchTokens() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      _tokens = await _tokenApi.fetchTokensOfUser(user.uid);
    }
  }

  Future<bool> createToken(QuestTaker questTaker, Quest quest) async {
    bool isSucces = await _tokenApi.createToken(questTaker, quest);
    return isSucces;
  }

  void clearTokens() => _tokens = [];
}
