import 'package:gentlestudent/src/repositories/user_repository.dart';
import 'package:gentlestudent/src/validators/login_validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with LoginValidators {
  final UserRepository _userRepository = UserRepository();
  final _email = BehaviorSubject<String>();
  final _forgotEmail = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _isLoading = BehaviorSubject<bool>();

  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get forgotEmail => _forgotEmail.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);
  Stream<bool> get isLoading => _isLoading.stream;

  Stream<bool> get isSubmitValid => Observable.combineLatest2(
        email,
        password,
        (e, p) => e == _email.value && p == _password.value,
      );

  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changeForgotEmail => _forgotEmail.sink.add;
  Function(String) get changePassword => _password.sink.add;

  Future<bool> submit() async {
    _isLoading.sink.add(true);

    final validEmail = _email.value;
    final validPassword = _password.value;

    await _userRepository.signInWithCredentials(validEmail, validPassword);

    _isLoading.sink.add(false);

    return await _userRepository.isSignedIn();
  }

  Future<bool> hasVerifiedEmail() async {
    if (await _userRepository.isSignedIn()) {
      return await _userRepository.hasVerifiedEmail();
    }
    
    return false;
  }

  Future signOut() async {
    await _userRepository.signOut();
  }

  Future forgotPassword() async {
    final forgotEmail = _forgotEmail.value;
    if (forgotEmail != null && forgotEmail != "") {
      _userRepository.forgotPassword(forgotEmail);
    }
  }

  void dispose() {
    _email.close();
    _forgotEmail.close();
    _password.close();
    _isLoading.close();
  }
}
