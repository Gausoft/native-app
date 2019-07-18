import 'package:firebase_auth/firebase_auth.dart';
import 'package:gentlestudent/src/models/enums/quest_status.dart';
import 'package:gentlestudent/src/models/quest.dart';
import 'package:gentlestudent/src/models/quest_taker.dart';
import 'package:gentlestudent/src/repositories/quest_repository.dart';
import 'package:gentlestudent/src/repositories/user_repository.dart';
import 'package:rxdart/subjects.dart';

class QuestBloc {
  final _questRepository = QuestRepository();
  final _userRepository = UserRepository();
  final _quests = BehaviorSubject<List<Quest>>();
  final _availableQuests = BehaviorSubject<List<Quest>>();
  final _inProgressQuests = BehaviorSubject<List<Quest>>();
  final _questsUserIsDoing = BehaviorSubject<List<QuestTaker>>();
  final _currentQuestOfUser = BehaviorSubject<Quest>();

  Stream<List<Quest>> get quests => _quests.stream;
  Stream<List<Quest>> get availableQuests => _availableQuests.stream;
  Stream<List<Quest>> get inProgressQuests => _inProgressQuests.stream;
  Stream<List<QuestTaker>> get questsUserIsDoing => _questsUserIsDoing.stream;
  Stream<Quest> get currentQuestOfUser => _currentQuestOfUser.stream;

  Function(List<Quest>) get _changeQuests => _quests.sink.add;
  Function(List<Quest>) get _changeAvailableQuests => _availableQuests.sink.add;
  Function(List<Quest>) get _changeInProgressQuests => _inProgressQuests.sink.add;
  Function(List<QuestTaker>) get _changeQuestsUserIsDoing => _questsUserIsDoing.sink.add;
  Function(Quest) get _changeCurrentQuestOfUser => _currentQuestOfUser.sink.add;

  Future<void> fetchQuests() async {
    List<Quest> quests = await _questRepository.quests;

    if (quests != null && quests.isNotEmpty) {
      quests.removeWhere((q) => q.questStatus == QuestStatus.FINISHED);

      FirebaseUser user = await _userRepository.getUser();
      if (user != null) {
        quests.removeWhere((q) => q.questGiverId == user?.uid ?? "");
      }

      _changeQuests(quests);

      List<Quest> filteredQuests = [...quests];
      List<QuestTaker> questTakers = await _questRepository.questTakers ?? [];
      _changeQuestsUserIsDoing(questTakers);
      List<String> questsTheUserIsDoing = questTakers.map((qt) => qt.questId).toList();

      if (questsTheUserIsDoing == null || questsTheUserIsDoing.isEmpty) {
        _changeAvailableQuests(filteredQuests);
        _changeInProgressQuests([]);
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

  Future<void> fetchCurrentQuestOfUser() async {
    Quest quest = await _questRepository.currentQuest;
    _changeCurrentQuestOfUser(quest);
  }

  Future<bool> enrollInQuest(Quest quest) async {
    bool isSucces = await _questRepository.enrollInQuest(quest.questId);
    if (isSucces) fetchQuests();
    return isSucces;
  }

  Future<bool> disenrollInQuest(QuestTaker questTaker) async {
    bool isSucces = await _questRepository.disenrollInQuest(questTaker.questTakerId);
    if (isSucces) fetchQuests();
    return isSucces;
  }

  void onSignOut() {
    _changeCurrentQuestOfUser(null);
    _questRepository.clearQuests();
  }

  void dispose() {
    _quests.close();
    _availableQuests.close();
    _inProgressQuests.close();
    _questsUserIsDoing.close();
    _currentQuestOfUser.close();
  }
}
