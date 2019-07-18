import 'package:gentlestudent/src/repositories/user_repository.dart';
import 'package:gentlestudent/src/validators/registration_validators.dart';
import 'package:rxdart/rxdart.dart';

class RegistrationBloc with RegistrationValidators {
  final UserRepository _userRepository = UserRepository();
  final _firstName = BehaviorSubject<String>();
  final _lastName = BehaviorSubject<String>();
  final _education = BehaviorSubject<String>();
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _repeatPassword = BehaviorSubject<String>();
  final _isLoading = BehaviorSubject<bool>();

  Stream<String> get firstName => _firstName.stream.transform(validateFirstName);
  Stream<String> get lastName => _lastName.stream.transform(validateLastName);
  Stream<String> get education => _education.stream.transform(validateEducation);
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);
  Stream<String> get repeatPassword =>
      _repeatPassword.stream.transform(validatePassword).doOnData((String c) {
        if (0 != _password.value.compareTo(c)) {
          _repeatPassword
              .addError("De ingevoerde wachtwoorden komen niet overeen");
        }
      });
  Stream<bool> get isLoading => _isLoading.stream;

  Stream<bool> get isSubmitValid => Observable.combineLatest6(
        firstName,
        lastName,
        education,
        email,
        password,
        repeatPassword,
        (f, l, ed, em, p, rp) => p == rp,
      );

  Function(String) get changeFirstName => _firstName.sink.add;
  Function(String) get changeLastName => _lastName.sink.add;
  Function(String) get changeEducation => _education.sink.add;
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;
  Function(String) get changeRepeatPassword => _repeatPassword.sink.add;

  Future<bool> submit() async {
    _isLoading.sink.add(true);

    final validFirstName = _firstName.value;
    final validLastName = _lastName.value;
    final validEducation = _education.value;
    final validEmail = _email.value;
    final validPassword = _password.value;

    await _userRepository.signUp(validFirstName, validLastName, validEducation,
        validEmail, validPassword);

    _isLoading.sink.add(false);

    return await _userRepository.isSignedIn();
  }

  dispose() {
    _firstName.close();
    _lastName.close();
    _education.close();
    _email.close();
    _password.close();
    _repeatPassword.close();
    _isLoading.close();
  }
}
