import 'package:rxdart/rxdart.dart';

class OpportunityNavigationBloc {
  final _currentIndex = BehaviorSubject<int>();

  Stream<int> get currentIndex => _currentIndex.stream;

  Function(int) get changeCurrentIndex => _currentIndex.sink.add;

  void dispose() {
    _currentIndex.close();
  }
}
