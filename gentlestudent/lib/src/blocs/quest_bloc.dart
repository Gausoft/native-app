import 'package:gentlestudent/src/models/quest.dart';
import 'package:gentlestudent/src/models/quest_taker.dart';
import 'package:gentlestudent/src/repositories/quest_repository.dart';
import 'package:rxdart/subjects.dart';

class QuestBloc {
  final _questRepository = QuestRepository();
  final _quests = BehaviorSubject<List<Quest>>();

  Stream<List<Quest>> get quests => _quests.stream;

  Function(List<Quest>) get _changeQuests => _quests.sink.add;

  Future<void> fetchQuests() async => _changeQuests(await _questRepository.quests);

  Future<List<QuestTaker>> fetchQuestTakersByQuestId(String questId) async => await _questRepository.fetchQuestTakersByQuestId(questId);

  Future<Quest> fetchQuestById(String questId) async => await _questRepository.fetchQuestById(questId);

  void dispose() {
    _quests.close();
  }
}
