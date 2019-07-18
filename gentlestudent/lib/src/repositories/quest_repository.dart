import 'package:firebase_auth/firebase_auth.dart';
import 'package:gentlestudent/src/models/enums/quest_status.dart';
import 'package:gentlestudent/src/models/quest.dart';
import 'package:gentlestudent/src/models/quest_taker.dart';
import 'package:gentlestudent/src/network/quest_api.dart';

class QuestRepository {
  final QuestApi _questApi = QuestApi();

  List<Quest> _quests;
  Future<List<Quest>> get quests async {
    if (_quests == null || _quests.isEmpty) {
      await _fetchQuests();
    }
    return _quests;
  }

  List<QuestTaker> _questTakers;
  Future<List<QuestTaker>> get questTakers async {
    if (_questTakers == null || _questTakers.isEmpty) {
      await _fetchQuestTakersByUserId();
    }
    return _questTakers;
  }

  Quest _currentQuest;
  Future<Quest> get currentQuest async {
    if (_currentQuest == null || _currentQuest.questId == null) {
      await _fetchCurrentQuestOfUser();
    }
    return _currentQuest;
  }

  Future<Quest> fetchQuestById(String questId) async {
    Quest quest;

    if (_quests == null || _quests.isEmpty) {
      quest = _quests.firstWhere((q) => q.questId == questId);
    }

    if (quest == null) {
      quest = await _questApi.fetchQuestById(questId);
    }

    return quest;
  }

  Future<List<QuestTaker>> fetchQuestTakersByQuestId(String questId) async {
    List<QuestTaker> questTakers = await _questApi.fetchQuestTakersByQuestId(questId);
    return questTakers;
  }

  Future<QuestTaker> fetchQuestTakerByQuestIdAndParticipantId(String questId) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user == null) return null;

    QuestTaker questTaker = await _questApi.fetchQuestTakerByQuestIdAndParticipantId(user.uid, questId);
    return questTaker;
  }

  Future<void> _fetchQuests() async {
    _quests = await _questApi.fetchAllQuests();
  }

  Future<void> _fetchQuestTakersByUserId() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user == null) return [];

    _questTakers = await _questApi.fetchQuestTakersByUserId(user.uid);
  }

  Future<void> _fetchCurrentQuestOfUser() async {
    _currentQuest = Quest();
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user == null) return;

    _currentQuest = await _questApi.fetchCurrentQuestOfUser(user.uid) ?? Quest();
  }

  Future<bool> enrollInQuest(String questId) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user == null) return false;

    await _questApi.enrollInQuest(user.uid, user.displayName, questId);
    await _fetchQuestTakersByUserId();
    return true;
  }

  Future<bool> disenrollInQuest(String questTakerId) async {
    await _questApi.disenrollInQuest(questTakerId);
    await _fetchQuestTakersByUserId();
    return true;
  }

  Future<bool> createQuest(String title, String description, String email, String phone, double latitude, double longitude) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user == null || (_currentQuest != null && _currentQuest.questId!= null)) return false;

    await _questApi.createQuest(user, title, description, email, phone, latitude, longitude);
    await _fetchCurrentQuestOfUser();
    return _currentQuest != null && _currentQuest.questId!= null;
  }

  Future<bool> appointQuestTakerToQuest(Quest quest, QuestTaker questTaker) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user == null || user.uid != quest.questGiverId) return false;

    await _questApi.appointQuestTakerToQuest(quest, questTaker);
    return true;
  }

  void clearQuests() {
    _currentQuest = null;
  }
}
