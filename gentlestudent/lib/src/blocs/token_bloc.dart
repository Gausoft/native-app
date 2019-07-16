import 'package:gentlestudent/src/models/token.dart';
import 'package:gentlestudent/src/repositories/token_repository.dart';
import 'package:rxdart/rxdart.dart';

class TokenBloc {
  final _tokenRepository = TokenRepository();
  final _tokens = BehaviorSubject<List<Token>>();

  Stream<List<Token>> get tokens => _tokens.stream;

  Function(List<Token>) get _changeTokens => _tokens.sink.add;

  Future<void> fetchTokens() async => _changeTokens(await _tokenRepository.tokens);

  void onSignOut() {
    _tokenRepository.clearTokens();
    _changeTokens([]);
  }

  void dispose() {
    _tokens.close();
  }
}
