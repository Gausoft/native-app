import 'package:gentlestudent/src/repositories/quest_repository.dart';
import 'package:gentlestudent/src/validators/create_quest_validators.dart';
import 'package:rxdart/rxdart.dart';

class CreateQuestBloc with CreateQuestValidators {
  final _questRepository = QuestRepository();
  final _title = BehaviorSubject<String>();
  final _description = BehaviorSubject<String>();
  final _email = BehaviorSubject<String>();
  final _latitude = BehaviorSubject<double>();
  final _longitude = BehaviorSubject<double>();
  final _isLoading = BehaviorSubject<bool>();

  Stream<String> get title => _title.stream.transform(validateTitle);
  Stream<String> get description => _description.stream.transform(validateDescription);
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<double> get latitude => _latitude.stream.transform(validateLatitude);
  Stream<double> get longitude => _longitude.stream.transform(validateLongitude);
  Stream<bool> get isLoading => _isLoading.stream;

  Stream<bool> get isSubmitValid => Observable.combineLatest5(
        title,
        description,
        email,
        latitude,
        longitude,
        (t, d, e, la, lo) => true,
      );

  Function(String) get changeTitle => _title.sink.add;
  Function(String) get changeDescription => _description.sink.add;
  Function(String) get changeEmail => _email.sink.add;
  Function(double) get changeLatitude => _latitude.sink.add;
  Function(double) get changeLongitude => _longitude.sink.add;

  Future<bool> submit() async {
    _isLoading.sink.add(true);

    final validTitle = _title.value;
    final validDescription = _description.value;
    final validEmail = _email.value;
    final validLatitude = _latitude.value;
    final validLongitude = _longitude.value;

    bool isSucces = await _questRepository.createQuest(
      validTitle,
      validDescription,
      validEmail,
      validLatitude,
      validLongitude,
    );

    _isLoading.sink.add(false);

    return isSucces;
  }

  void dispose() {
    _title.close();
    _description.close();
    _email.close();
    _latitude.close();
    _longitude.close();
    _isLoading.close();
  }
}
