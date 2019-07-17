import 'package:gentlestudent/src/models/enums/quest_status.dart';
import 'package:gentlestudent/src/models/quest.dart';
import 'package:gentlestudent/src/models/quest_taker.dart';
import 'package:gentlestudent/src/repositories/quest_repository.dart';
import 'package:rxdart/subjects.dart';

class QuestBloc {
  final _questRepository = QuestRepository();
  final _quests = BehaviorSubject<List<Quest>>();
  final _availableQuests = BehaviorSubject<List<Quest>>();
  final _inProgressQuests = BehaviorSubject<List<Quest>>();

  Stream<List<Quest>> get quests => _quests.stream;
  Stream<List<Quest>> get availableQuests => _availableQuests.stream;
  Stream<List<Quest>> get inProgressQuests => _inProgressQuests.stream;

  Function(List<Quest>) get _changeQuests => _quests.sink.add;
  Function(List<Quest>) get _changeAvailableQuests => _availableQuests.sink.add;
  Function(List<Quest>) get _changeInProgressQuests => _inProgressQuests.sink.add;

  Future<void> fetchQuests() async {
    List<Quest> quests = await _questRepository.quests;

    if (quests != null && quests.isNotEmpty) {
       _changeQuests(quests);

      List<Quest> filteredQuests = [...quests];
      filteredQuests.removeWhere((q) => q.questStatus == QuestStatus.FINISHED);

      List<String> questsTheUserIsDoing = (await _questRepository.fetchQuestTakersByUserId()).map((qt) => qt.questId).toList();

      if (questsTheUserIsDoing == null || questsTheUserIsDoing.isEmpty) {
        _changeAvailableQuests(filteredQuests);
      } else {
        List<Quest> availableQuests = [];
        List<Quest> inProgressQuests = [];

        for (final quest in filteredQuests) {
          if (quest.questStatus == QuestStatus.INPROGRESS && questsTheUserIsDoing.contains(quest.questId)) {
            inProgressQuests.add(quest);
          } else if (quest.questStatus == QuestStatus.AVAILABLE) {
            availableQuests.add(quest);
          }

          _changeAvailableQuests(availableQuests);
          _changeInProgressQuests(inProgressQuests);
        }
      }
    } else {
      _changeQuests([]);
      _changeAvailableQuests([]);
      _changeInProgressQuests([]);
    }
  }

  Future<List<QuestTaker>> fetchQuestTakersByQuestId(String questId) async => await _questRepository.fetchQuestTakersByQuestId(questId);

  Future<QuestTaker> fetchQuestTakerByQuestIdAndParticipantId(String questId) async => await _questRepository.fetchQuestTakerByQuestIdAndParticipantId(questId);

  Future<Quest> fetchQuestById(String questId) async => await _questRepository.fetchQuestById(questId);

  void dispose() {
    _quests.close();
    _availableQuests.close();
    _inProgressQuests.close();
  }
}
