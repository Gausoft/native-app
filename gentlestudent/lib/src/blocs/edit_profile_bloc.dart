import 'package:gentlestudent/src/repositories/user_repository.dart';
import 'package:gentlestudent/src/validators/registration_validators.dart';
import 'package:rxdart/rxdart.dart';

class EditProfileBloc with RegistrationValidators {
  final UserRepository _userRepository = UserRepository();
  final _firstName = BehaviorSubject<String>();
  final _lastName = BehaviorSubject<String>();
  final _education = BehaviorSubject<String>();
  final _email = BehaviorSubject<String>();
  final _isLoading = BehaviorSubject<bool>();

  Stream<String> get firstName => _firstName.stream.transform(validateFirstName);
  Stream<String> get lastName => _lastName.stream.transform(validateLastName);
  Stream<String> get education => _education.stream.transform(validateEducation);
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<bool> get isLoading => _isLoading.stream;

  Stream<bool> get isSubmitValid => Observable.combineLatest4(
        firstName,
        lastName,
        education,
        email,
        (f, l, ed, em) =>
            f == _firstName.value &&
            l == _lastName.value &&
            ed == _education.value &&
            em == _email.value,
      );

  Function(String) get changeFirstName => _firstName.sink.add;
  Function(String) get changeLastName => _lastName.sink.add;
  Function(String) get changeEducation => _education.sink.add;
  Function(String) get changeEmail => _email.sink.add;

  Future<bool> submit() async {
    _isLoading.sink.add(true);

    final validName = "${_firstName.value} ${_lastName.value}";
    final validEmail = _email.value;

    bool isSucces = await _userRepository.editFirebaseUser(validName, validEmail);

    _isLoading.sink.add(false);

    return isSucces;
  }

  void dispose() {
    _firstName.close();
    _lastName.close();
    _education.close();
    _email.close();
    _isLoading.close();
  }
}
