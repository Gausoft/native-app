import 'package:gentlestudent/src/models/quest_taker.dart';
import 'package:gentlestudent/src/models/token.dart';
import 'package:gentlestudent/src/repositories/token_repository.dart';
import 'package:rxdart/rxdart.dart';

class TokenBloc {
  final _tokenRepository = TokenRepository();
  final _tokens = BehaviorSubject<List<Token>>();

  Stream<List<Token>> get tokens => _tokens.stream;

  Function(List<Token>) get _changeTokens => _tokens.sink.add;

  Future<void> fetchTokens() async => _changeTokens(await _tokenRepository.tokens);

  Future<bool> createToken(QuestTaker questTaker) async {
    bool isSucces = await _tokenRepository.createToken(questTaker.participantId, questTaker.questId);
    return isSucces;
  }

  void onSignOut() {
    _tokenRepository.clearTokens();
    _changeTokens([]);
  }

  void dispose() {
    _tokens.close();
  }
}
