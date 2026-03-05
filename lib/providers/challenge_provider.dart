// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:kiwihabitapp/models/bundle_model.dart';
import 'package:kiwihabitapp/models/challenge_model.dart';
import 'package:kiwihabitapp/models/participant_model.dart';
import 'package:kiwihabitapp/services/firestoreClass.dart';

class ChallengeProvider extends ChangeNotifier {
  final String uid;
  final ChallengeService _service = ChallengeService();

  List<ChallengeModel> _discoverChallenges = [];
  List<ChallengeModel> _myChallenges = [];
  List<BundleModel> _discoverBundles = [];
  Set<String> _joinedBundleIds = {};
  final Map<String, ParticipantModel> _participantDocs = {};
  bool _isLoading = false;
  String? _error;
  int _pointsPerCheckIn = 10;

  ChallengeProvider({required this.uid}) {
    _init();
  }

  List<ChallengeModel> get discoverChallenges => _discoverChallenges;
  List<ChallengeModel> get myChallenges => _myChallenges;
  List<BundleModel> get discoverBundles => _discoverBundles;
  Map<String, ParticipantModel> get participantDocs => _participantDocs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> _init() async {
    await Future.wait([
      fetchDiscoverChallenges(),
      fetchDiscoverBundles(),
      loadAppConfig(),
    ]);
  }

  /// Called from UI when user doc updates (activeBundleIds field).
  /// Does NOT call notifyListeners() — this is invoked inside build(),
  /// where the DocumentSnapshot stream change already triggers the rebuild.
  void setJoinedBundleIds(List<String> bundleIds) {
    _joinedBundleIds = Set<String>.from(bundleIds);
  }

  bool isJoinedBundle(String bundleId) => _joinedBundleIds.contains(bundleId);

  Future<void> loadAppConfig() async {
    final config = await _service.getAppConfig();
    if (config != null) {
      _pointsPerCheckIn = (config['pointsPerCheckIn'] ?? 10) as int;
    }
  }

  Future<void> fetchDiscoverChallenges({String? category}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _discoverChallenges = await _service.fetchDiscoverChallenges(category: category);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMyChallenges(List<String> challengeIds) async {
    if (challengeIds.isEmpty) {
      _myChallenges = [];
      notifyListeners();
      return;
    }
    _myChallenges = await _service.fetchChallengesByIds(challengeIds);
    // Also fetch participant docs for each
    for (final challenge in _myChallenges) {
      final doc = await _service.getMyParticipantDoc(uid, challenge.id);
      if (doc != null) {
        _participantDocs[challenge.id] = doc;
      }
    }
    notifyListeners();
  }

  Future<bool> joinChallenge({
    required String challengeId,
    required String userName,
    required String photoUrl,
  }) async {
    final success = await _service.joinChallenge(
      uid: uid,
      challengeId: challengeId,
      userName: userName,
      photoUrl: photoUrl,
    );
    if (success) {
      // Fetch the joined challenge and add to myChallenges
      final challenges = await _service.fetchChallengesByIds([challengeId]);
      if (challenges.isNotEmpty) {
        _myChallenges = [..._myChallenges, challenges.first];
      }
      // Fetch participant doc
      final doc = await _service.getMyParticipantDoc(uid, challengeId);
      if (doc != null) _participantDocs[challengeId] = doc;
      notifyListeners();
    }
    return success;
  }

  Future<bool> leaveChallenge(String challengeId) async {
    final success = await _service.leaveChallenge(uid: uid, challengeId: challengeId);
    if (success) {
      _myChallenges.removeWhere((c) => c.id == challengeId);
      _participantDocs.remove(challengeId);
      notifyListeners();
    }
    return success;
  }

  Future<bool> checkInToday(String challengeId) async {
    final success = await _service.checkIn(
      uid: uid,
      challengeId: challengeId,
      pointsPerCheckIn: _pointsPerCheckIn,
    );
    if (success) {
      // Refresh participant doc
      final doc = await _service.getMyParticipantDoc(uid, challengeId);
      if (doc != null) {
        _participantDocs[challengeId] = doc;
        notifyListeners();
      }
    }
    return success;
  }

  Future<bool> undoCheckInToday(String challengeId) async {
    final success = await _service.undoCheckIn(
      uid: uid,
      challengeId: challengeId,
    );
    if (success) {
      final doc = await _service.getMyParticipantDoc(uid, challengeId);
      if (doc != null) {
        _participantDocs[challengeId] = doc;
        notifyListeners();
      }
    }
    return success;
  }

  bool hasCheckedInToday(String challengeId) {
    final participant = _participantDocs[challengeId];
    if (participant == null) return false;
    final today = _todayString();
    return participant.checkIns[today] == true;
  }

  /// Returns true if the given sub-task index is done today.
  bool isSubTaskDoneToday(String challengeId, int index) {
    final participant = _participantDocs[challengeId];
    if (participant == null) return false;
    final today = _todayString();
    return participant.subTaskCheckIns[today]?[index.toString()] == true;
  }

  /// Returns count of sub-tasks completed today.
  int getSubTasksCompletedToday(String challengeId) {
    final participant = _participantDocs[challengeId];
    if (participant == null) return 0;
    final today = _todayString();
    final todayMap = participant.subTaskCheckIns[today] ?? {};
    return todayMap.values.where((v) => v == true).length;
  }

  Future<bool> checkInSubTask(String challengeId, int subTaskIndex) async {
    final challenge = _myChallenges.firstWhere(
      (c) => c.id == challengeId,
      orElse: () => _discoverChallenges.firstWhere((c) => c.id == challengeId),
    );
    final success = await _service.checkInSubTask(
      uid: uid,
      challengeId: challengeId,
      subTaskIndex: subTaskIndex,
      subTaskCount: challenge.subTasks.length,
      pointsPerCheckIn: _pointsPerCheckIn,
    );
    if (success) {
      final doc = await _service.getMyParticipantDoc(uid, challengeId);
      if (doc != null) {
        _participantDocs[challengeId] = doc;
        notifyListeners();
      }
    }
    return success;
  }

  int getStreak(String challengeId) {
    return _participantDocs[challengeId]?.currentStreak ?? 0;
  }

  bool isJoined(String challengeId) {
    return _participantDocs.containsKey(challengeId) ||
        _myChallenges.any((c) => c.id == challengeId);
  }

  String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  void setDiscoverChallenges(List<ChallengeModel> challenges) {
    _discoverChallenges = challenges;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? value) {
    _error = value;
    notifyListeners();
  }

  Future<String?> createNewChallenge({
    required String creatorUid,
    required String creatorName,
    required String title,
    required String description,
    required String category,
    required String iconName,
    required int durationDays,
    required String dailyGoalDescription,
    required String coverColor,
    List<String> tags = const [],
    String preCheckTime = '',
    String finalCheckTime = '',
    List<String> subTasks = const [],
  }) async {
    final id = await _service.createChallenge(
      creatorUid: creatorUid,
      creatorName: creatorName,
      title: title,
      description: description,
      category: category,
      iconName: iconName,
      durationDays: durationDays,
      dailyGoalDescription: dailyGoalDescription,
      coverColor: coverColor,
      tags: tags,
      preCheckTime: preCheckTime,
      finalCheckTime: finalCheckTime,
      subTasks: subTasks,
    );
    if (id != null) {
      await fetchDiscoverChallenges();
    }
    return id;
  }

  // ── Bundle methods ───────────────────────────────────────────────────────────

  Future<void> fetchDiscoverBundles({String? category}) async {
    _discoverBundles = await _service.fetchDiscoverBundles(category: category);
    notifyListeners();
  }

  Future<bool> joinBundle({
    required String bundleId,
    required String userName,
    required String photoUrl,
    required List<String> challengeIds,
    required String preCheckTime,
    required String finalCheckTime,
  }) async {
    final success = await _service.joinBundle(
      uid: uid,
      bundleId: bundleId,
      userName: userName,
      photoUrl: photoUrl,
      challengeIds: challengeIds,
      preCheckTime: preCheckTime,
      finalCheckTime: finalCheckTime,
    );
    if (success) {
      _joinedBundleIds.add(bundleId);
      // Add newly joined challenges to myChallenges
      final newChallenges = await _service.fetchChallengesByIds(challengeIds);
      for (final c in newChallenges) {
        if (!_myChallenges.any((e) => e.id == c.id)) {
          _myChallenges = [..._myChallenges, c];
        }
      }
      // Fetch participant docs for these challenges
      for (final cId in challengeIds) {
        final doc = await _service.getMyParticipantDoc(uid, cId);
        if (doc != null) _participantDocs[cId] = doc;
      }
      notifyListeners();
    }
    return success;
  }

  Future<bool> leaveBundle({
    required String bundleId,
    required List<String> challengeIds,
  }) async {
    final success = await _service.leaveBundle(
      uid: uid,
      bundleId: bundleId,
      challengeIds: challengeIds,
    );
    if (success) {
      _joinedBundleIds.remove(bundleId);
      for (final cId in challengeIds) {
        _myChallenges.removeWhere((c) => c.id == cId);
        _participantDocs.remove(cId);
      }
      notifyListeners();
    }
    return success;
  }

  Future<String?> createNewBundle({
    required String creatorUid,
    required String creatorName,
    required String title,
    required String description,
    required String category,
    required String iconName,
    required String coverColor,
    required List<String> challengeIds,
    required String preCheckTime,
    required String finalCheckTime,
    List<String> tags = const [],
  }) async {
    final id = await _service.createBundle(
      creatorUid: creatorUid,
      creatorName: creatorName,
      title: title,
      description: description,
      category: category,
      iconName: iconName,
      coverColor: coverColor,
      challengeIds: challengeIds,
      preCheckTime: preCheckTime,
      finalCheckTime: finalCheckTime,
      tags: tags,
    );
    if (id != null) {
      await fetchDiscoverBundles();
    }
    return id;
  }
}
