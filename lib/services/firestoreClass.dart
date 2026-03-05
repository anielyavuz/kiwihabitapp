// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:kiwihabitapp/models/bundle_model.dart';
import 'package:kiwihabitapp/models/challenge_model.dart';
import 'package:kiwihabitapp/models/participant_model.dart';

class ChallengeService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Discover ────────────────────────────────────────────────────────────────

  /// Fetches all public challenges (for Discover tab)
  Future<List<ChallengeModel>> fetchDiscoverChallenges({String? category}) async {
    try {
      // Avoid composite index requirement by not using orderBy on a different
      // field than the where clause — sort client-side instead.
      Query query = _db
          .collection("Challenges")
          .where("isPublic", isEqualTo: true)
          .limit(50);

      if (category != null && category != "All") {
        query = query.where("category", isEqualTo: category);
      }

      final snap = await query.get().timeout(const Duration(seconds: 10));
      final challenges = snap.docs
          .map((doc) => ChallengeModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
      // Sort by participantCount descending (no composite index needed)
      challenges.sort((a, b) => b.participantCount.compareTo(a.participantCount));
      return challenges;
    } catch (e) {
      return [];
    }
  }

  /// Fetches challenges by a list of IDs (for My Challenges tab)
  Future<List<ChallengeModel>> fetchChallengesByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    try {
      // Firestore whereIn max 10 items - chunk if needed
      final List<ChallengeModel> results = [];
      for (int i = 0; i < ids.length; i += 10) {
        final chunk = ids.skip(i).take(10).toList();
        final snap = await _db
            .collection("Challenges")
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        results.addAll(
          snap.docs.map((doc) => ChallengeModel.fromMap(doc.id, doc.data())),
        );
      }
      return results;
    } catch (e) {
      return [];
    }
  }

  // ── Challenge CRUD ──────────────────────────────────────────────────────────

  /// Creates a new challenge and returns its ID
  Future<String?> createChallenge({
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
    try {
      final data = {
        "title": title,
        "description": description,
        "category": category,
        "iconName": iconName,
        "durationDays": durationDays,
        "creatorUid": creatorUid,
        "creatorName": creatorName,
        "isAdminCreated": false,
        "isPublic": true,
        "participantCount": 0,
        "createTime": FieldValue.serverTimestamp(),
        "dailyGoalDescription": dailyGoalDescription,
        "coverColor": coverColor,
        "tags": tags,
        "preCheckTime": preCheckTime,
        "finalCheckTime": finalCheckTime,
        "subTasks": subTasks,
      };
      final docRef = await _db.collection("Challenges").add(data).timeout(const Duration(seconds: 10));
      await docRef.update({"id": docRef.id}).timeout(const Duration(seconds: 10));
      return docRef.id;
    } catch (e) {
      return null;
    }
  }

  // ── Participation ───────────────────────────────────────────────────────────

  /// Joins a challenge: creates participant doc + updates user's activeChallengeIds + increments participantCount
  Future<bool> joinChallenge({
    required String uid,
    required String challengeId,
    required String userName,
    required String photoUrl,
  }) async {
    try {
      final participantRef = _db
          .collection("Challenges")
          .doc(challengeId)
          .collection("Participants")
          .doc(uid);

      final existing = await participantRef.get();
      if (existing.exists) return true; // already joined

      // Read challenge doc to get notification times
      final challengeDoc = await _db.collection("Challenges").doc(challengeId).get();
      final challengeData = challengeDoc.data() ?? {};
      final preCheckTime = challengeData['preCheckTime'] as String? ?? '';
      final finalCheckTime = challengeData['finalCheckTime'] as String? ?? '';

      final batch = _db.batch();

      // Create participant doc
      batch.set(participantRef, {
        "uid": uid,
        "userName": userName,
        "photoUrl": photoUrl,
        "joinDate": FieldValue.serverTimestamp(),
        "currentStreak": 0,
        "longestStreak": 0,
        "totalCompletedDays": 0,
        "lastCheckInDate": "",
        "checkIns": {},
        "isCompleted": false,
        "preCheckTime": preCheckTime,
        "finalCheckTime": finalCheckTime,
      });

      // Update user's activeChallengeIds
      batch.update(_db.collection("Users").doc(uid), {
        "activeChallengeIds": FieldValue.arrayUnion([challengeId]),
      });

      // Increment participant count
      batch.update(_db.collection("Challenges").doc(challengeId), {
        "participantCount": FieldValue.increment(1),
      });

      await batch.commit();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Leaves a challenge
  Future<bool> leaveChallenge({
    required String uid,
    required String challengeId,
  }) async {
    try {
      final batch = _db.batch();

      batch.delete(
        _db.collection("Challenges").doc(challengeId).collection("Participants").doc(uid),
      );
      batch.update(_db.collection("Users").doc(uid), {
        "activeChallengeIds": FieldValue.arrayRemove([challengeId]),
      });
      batch.update(_db.collection("Challenges").doc(challengeId), {
        "participantCount": FieldValue.increment(-1),
      });

      await batch.commit();
      return true;
    } catch (e) {
      return false;
    }
  }

  // ── Check-In ────────────────────────────────────────────────────────────────

  /// Performs today's check-in for a challenge participant
  Future<bool> checkIn({
    required String uid,
    required String challengeId,
    required int pointsPerCheckIn,
  }) async {
    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final yesterday = DateFormat('yyyy-MM-dd').format(
        DateTime.now().subtract(const Duration(days: 1)),
      );

      final participantRef = _db
          .collection("Challenges")
          .doc(challengeId)
          .collection("Participants")
          .doc(uid);

      final snap = await participantRef.get();
      if (!snap.exists) return false;

      final data = snap.data() as Map<String, dynamic>;
      final checkIns = Map<String, bool>.from(
        (data['checkIns'] as Map<String, dynamic>? ?? {}).map((k, v) => MapEntry(k, v as bool)),
      );

      // Prevent double check-in
      if (checkIns[today] == true) return false;

      // Calculate streak
      final lastDate = data['lastCheckInDate'] as String? ?? '';
      final currentStreak = (data['currentStreak'] ?? 0) as int;
      final longestStreak = (data['longestStreak'] ?? 0) as int;
      final totalDays = (data['totalCompletedDays'] ?? 0) as int;

      final newStreak = (lastDate == yesterday) ? currentStreak + 1 : 1;
      final newLongest = newStreak > longestStreak ? newStreak : longestStreak;

      checkIns[today] = true;

      // Award time-aware points to user
      final finalCheckTimeStr = data['finalCheckTime'] as String? ?? '';
      final earnedPoints = _calculateEarnedPoints(pointsPerCheckIn, finalCheckTimeStr);

      await participantRef.update({
        "checkIns": checkIns,
        "checkInPoints.$today": earnedPoints,
        "lastCheckInDate": today,
        "currentStreak": newStreak,
        "longestStreak": newLongest,
        "totalCompletedDays": totalDays + 1,
      });

      await _db.collection("Users").doc(uid).update({
        "totalPoints": FieldValue.increment(earnedPoints),
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Undoes today's check-in, reverting points and recalculating streak.
  /// Returns false if not checked in today.
  Future<bool> undoCheckIn({
    required String uid,
    required String challengeId,
  }) async {
    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final participantRef = _db
          .collection("Challenges")
          .doc(challengeId)
          .collection("Participants")
          .doc(uid);

      final snap = await participantRef.get();
      if (!snap.exists) return false;

      final data = snap.data() as Map<String, dynamic>;
      final checkIns = Map<String, bool>.from(
        (data['checkIns'] as Map<String, dynamic>? ?? {}).map((k, v) => MapEntry(k, v as bool)),
      );

      // Only undo if checked in today
      if (checkIns[today] != true) return false;

      // How many points were earned today?
      final checkInPoints = (data['checkInPoints'] as Map<String, dynamic>? ?? {});
      final pointsToDeduct = (checkInPoints[today] as num?)?.toInt() ?? 0;

      // Remove today's check-in
      checkIns.remove(today);

      // Recompute streak from yesterday backwards
      int newStreak = 0;
      DateTime d = DateTime.now().subtract(const Duration(days: 1));
      for (int i = 0; i < 365; i++) {
        final ds = DateFormat('yyyy-MM-dd').format(d);
        if (checkIns[ds] != true) break;
        newStreak++;
        d = d.subtract(const Duration(days: 1));
      }

      // Find new lastCheckInDate (most recent check-in date before today)
      final sortedDates = checkIns.keys.toList()..sort();
      final newLastDate = sortedDates.isEmpty ? '' : sortedDates.last;

      final totalDays = (data['totalCompletedDays'] ?? 0) as int;

      final batch = _db.batch();
      batch.update(participantRef, {
        "checkIns": checkIns,
        "checkInPoints.$today": FieldValue.delete(),
        "lastCheckInDate": newLastDate,
        "currentStreak": newStreak,
        "totalCompletedDays": totalDays > 0 ? totalDays - 1 : 0,
      });

      if (pointsToDeduct > 0) {
        batch.update(_db.collection("Users").doc(uid), {
          "totalPoints": FieldValue.increment(-pointsToDeduct),
        });
      }

      await batch.commit();
      return true;
    } catch (e) {
      return false;
    }
  }

  // ── Participant Data ────────────────────────────────────────────────────────

  /// Gets the current user's participant doc for a challenge
  Future<ParticipantModel?> getMyParticipantDoc(String uid, String challengeId) async {
    try {
      final snap = await _db
          .collection("Challenges")
          .doc(challengeId)
          .collection("Participants")
          .doc(uid)
          .get();
      if (!snap.exists) return null;
      return ParticipantModel.fromMap(snap.data() as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  /// Gets all participants sorted by totalCompletedDays (for leaderboard)
  Future<List<ParticipantModel>> fetchLeaderboard(String challengeId) async {
    try {
      final snap = await _db
          .collection("Challenges")
          .doc(challengeId)
          .collection("Participants")
          .orderBy("totalCompletedDays", descending: true)
          .limit(100)
          .get();
      return snap.docs
          .map((doc) => ParticipantModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // ── Points Helper ───────────────────────────────────────────────────────────

  /// Returns earned points with time-aware decay after finalCheckTime.
  /// If no finalCheckTime set (standalone challenge), returns full basePoints.
  /// After finalCheckTime: -10% per hour late, minimum 50%.
  int _calculateEarnedPoints(int basePoints, String finalCheckTimeStr) {
    if (finalCheckTimeStr.isEmpty) return basePoints;
    try {
      final parts = finalCheckTimeStr.split(':');
      final finalHour = int.parse(parts[0]);
      final finalMinute = int.parse(parts[1]);
      final now = DateTime.now();
      final finalCheckDt = DateTime(now.year, now.month, now.day, finalHour, finalMinute);
      if (!now.isAfter(finalCheckDt)) return basePoints;
      final hoursLate = now.difference(finalCheckDt).inMinutes / 60.0;
      final reduction = (basePoints * 0.1 * hoursLate).round();
      final minPoints = (basePoints / 2).ceil();
      final earned = basePoints - reduction;
      return earned < minPoints ? minPoints : earned;
    } catch (_) {
      return basePoints;
    }
  }

  // ── Bundles ─────────────────────────────────────────────────────────────────

  /// Fetches all public bundles (for Discover tab)
  Future<List<BundleModel>> fetchDiscoverBundles({String? category}) async {
    try {
      Query query = _db
          .collection("Bundles")
          .where("isPublic", isEqualTo: true)
          .limit(20);
      if (category != null && category != "All") {
        query = query.where("category", isEqualTo: category);
      }
      final snap = await query.get().timeout(const Duration(seconds: 10));
      final bundles = snap.docs
          .map((doc) => BundleModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
      bundles.sort((a, b) => b.participantCount.compareTo(a.participantCount));
      return bundles;
    } catch (e) {
      return [];
    }
  }

  /// Creates a new bundle and returns its ID
  Future<String?> createBundle({
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
    try {
      final data = {
        "title": title,
        "description": description,
        "category": category,
        "iconName": iconName,
        "coverColor": coverColor,
        "challengeIds": challengeIds,
        "creatorUid": creatorUid,
        "creatorName": creatorName,
        "isAdminCreated": false,
        "isPublic": true,
        "participantCount": 0,
        "createTime": FieldValue.serverTimestamp(),
        "preCheckTime": preCheckTime,
        "finalCheckTime": finalCheckTime,
        "tags": tags,
      };
      final docRef = await _db.collection("Bundles").add(data).timeout(const Duration(seconds: 10));
      await docRef.update({"id": docRef.id}).timeout(const Duration(seconds: 10));
      return docRef.id;
    } catch (e) {
      return null;
    }
  }

  /// Joins a bundle: creates bundle participant + joins all challenges + updates user doc
  Future<bool> joinBundle({
    required String uid,
    required String bundleId,
    required String userName,
    required String photoUrl,
    required List<String> challengeIds,
    required String preCheckTime,
    required String finalCheckTime,
  }) async {
    try {
      final bundleParticipantRef = _db
          .collection("Bundles")
          .doc(bundleId)
          .collection("Participants")
          .doc(uid);

      final existing = await bundleParticipantRef.get();
      if (existing.exists) return true; // already joined

      // Check which challenges user hasn't joined yet (parallel reads)
      final challengeSnaps = await Future.wait(
        challengeIds.map((cId) => _db
            .collection("Challenges")
            .doc(cId)
            .collection("Participants")
            .doc(uid)
            .get()),
      );

      final batch = _db.batch();

      // Bundle participant doc
      batch.set(bundleParticipantRef, {
        "uid": uid,
        "userName": userName,
        "photoUrl": photoUrl,
        "joinDate": FieldValue.serverTimestamp(),
        "isCompleted": false,
      });

      // Increment bundle participant count
      batch.update(_db.collection("Bundles").doc(bundleId), {
        "participantCount": FieldValue.increment(1),
      });

      // Handle each challenge
      final newChallengeIds = <String>[];
      for (int i = 0; i < challengeIds.length; i++) {
        final challengeId = challengeIds[i];
        final challengeParticipantRef = _db
            .collection("Challenges")
            .doc(challengeId)
            .collection("Participants")
            .doc(uid);

        if (!challengeSnaps[i].exists) {
          newChallengeIds.add(challengeId);
          batch.set(challengeParticipantRef, {
            "uid": uid,
            "userName": userName,
            "photoUrl": photoUrl,
            "joinDate": FieldValue.serverTimestamp(),
            "currentStreak": 0,
            "longestStreak": 0,
            "totalCompletedDays": 0,
            "lastCheckInDate": "",
            "checkIns": {},
            "isCompleted": false,
            "preCheckTime": preCheckTime,
            "finalCheckTime": finalCheckTime,
          });
          batch.update(_db.collection("Challenges").doc(challengeId), {
            "participantCount": FieldValue.increment(1),
          });
        } else {
          // Already joined standalone — just stamp the check times
          batch.update(challengeParticipantRef, {
            "preCheckTime": preCheckTime,
            "finalCheckTime": finalCheckTime,
          });
        }
      }

      // Single user document update combining both array unions
      final userUpdate = <String, dynamic>{
        "activeBundleIds": FieldValue.arrayUnion([bundleId]),
      };
      if (newChallengeIds.isNotEmpty) {
        userUpdate["activeChallengeIds"] = FieldValue.arrayUnion(newChallengeIds);
      }
      batch.update(_db.collection("Users").doc(uid), userUpdate);

      await batch.commit();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Leaves a bundle: removes bundle participant + leaves all bundle challenges + updates user doc
  Future<bool> leaveBundle({
    required String uid,
    required String bundleId,
    required List<String> challengeIds,
  }) async {
    try {
      final batch = _db.batch();

      // Remove bundle participant doc
      batch.delete(
        _db.collection("Bundles").doc(bundleId).collection("Participants").doc(uid),
      );

      // Decrement bundle participant count
      batch.update(_db.collection("Bundles").doc(bundleId), {
        "participantCount": FieldValue.increment(-1),
      });

      // Leave each challenge
      for (final challengeId in challengeIds) {
        batch.delete(
          _db.collection("Challenges").doc(challengeId).collection("Participants").doc(uid),
        );
        batch.update(_db.collection("Challenges").doc(challengeId), {
          "participantCount": FieldValue.increment(-1),
        });
      }

      // Single user document update combining both array removes
      batch.update(_db.collection("Users").doc(uid), {
        "activeBundleIds": FieldValue.arrayRemove([bundleId]),
        "activeChallengeIds": FieldValue.arrayRemove(challengeIds),
      });

      await batch.commit();
      return true;
    } catch (e) {
      return false;
    }
  }

  // ── Sub-task Check-In ────────────────────────────────────────────────────────

  /// Checks in a specific sub-task for today.
  /// Awards floor(basePoints / subTaskCount) points.
  /// When ALL sub-tasks done: also marks full-day checkIn, updates streak.
  Future<bool> checkInSubTask({
    required String uid,
    required String challengeId,
    required int subTaskIndex,
    required int subTaskCount,
    required int pointsPerCheckIn,
  }) async {
    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final yesterday = DateFormat('yyyy-MM-dd').format(
        DateTime.now().subtract(const Duration(days: 1)),
      );

      final participantRef = _db
          .collection("Challenges")
          .doc(challengeId)
          .collection("Participants")
          .doc(uid);

      final snap = await participantRef.get();
      if (!snap.exists) return false;

      final data = snap.data() as Map<String, dynamic>;

      // Get today's sub-task progress
      final rawSubTaskCheckIns = data['subTaskCheckIns'] as Map<String, dynamic>? ?? {};
      final todaySubTasks = Map<String, bool>.from(
        (rawSubTaskCheckIns[today] as Map<String, dynamic>? ?? {}).map((k, v) => MapEntry(k, v as bool)),
      );

      final key = subTaskIndex.toString();

      // Already done this sub-task
      if (todaySubTasks[key] == true) return false;

      todaySubTasks[key] = true;

      // Points per sub-task
      final pointsPerSubTask = (pointsPerCheckIn / subTaskCount).floor();
      final finalCheckTimeStr = data['finalCheckTime'] as String? ?? '';
      final earnedPoints = _calculateEarnedPoints(pointsPerSubTask, finalCheckTimeStr);

      final Map<String, dynamic> updates = {
        'subTaskCheckIns.$today.$key': true,
      };

      // Check if ALL sub-tasks are now done
      final allDone = List.generate(subTaskCount, (i) => i.toString())
          .every((k) => todaySubTasks[k] == true);

      if (allDone) {
        final checkIns = Map<String, bool>.from(
          (data['checkIns'] as Map<String, dynamic>? ?? {}).map((k, v) => MapEntry(k, v as bool)),
        );
        checkIns[today] = true;

        final lastDate = data['lastCheckInDate'] as String? ?? '';
        final currentStreak = (data['currentStreak'] ?? 0) as int;
        final longestStreak = (data['longestStreak'] ?? 0) as int;
        final totalDays = (data['totalCompletedDays'] ?? 0) as int;

        final newStreak = (lastDate == yesterday) ? currentStreak + 1 : 1;
        final newLongest = newStreak > longestStreak ? newStreak : longestStreak;

        updates['checkIns'] = checkIns;
        updates['lastCheckInDate'] = today;
        updates['currentStreak'] = newStreak;
        updates['longestStreak'] = newLongest;
        updates['totalCompletedDays'] = totalDays + 1;
      }

      await participantRef.update(updates);

      // Award points
      await _db.collection("Users").doc(uid).update({
        "totalPoints": FieldValue.increment(earnedPoints),
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  // ── Delete User Data ─────────────────────────────────────────────────────────

  /// Deletes all Firestore data for a user before account deletion.
  /// Removes participant docs from all active challenges and bundles,
  /// decrements their participant counts, and deletes the user document.
  Future<void> deleteUserAllData(String uid) async {
    final userDoc = await _db.collection("Users").doc(uid).get();
    final data = userDoc.data() ?? {};

    final challengeIds = List<String>.from(data['activeChallengeIds'] ?? []);
    final bundleIds = List<String>.from(data['activeBundleIds'] ?? []);

    final batch = _db.batch();

    for (final cId in challengeIds) {
      batch.delete(
        _db.collection("Challenges").doc(cId).collection("Participants").doc(uid),
      );
      batch.update(_db.collection("Challenges").doc(cId), {
        "participantCount": FieldValue.increment(-1),
      });
    }

    for (final bId in bundleIds) {
      batch.delete(
        _db.collection("Bundles").doc(bId).collection("Participants").doc(uid),
      );
      batch.update(_db.collection("Bundles").doc(bId), {
        "participantCount": FieldValue.increment(-1),
      });
    }

    batch.delete(_db.collection("Users").doc(uid));
    await batch.commit();
  }

  // ── App Config ──────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> getAppConfig() async {
    try {
      final snap = await _db.collection("Configs").doc("AppConfig").get();
      return snap.data();
    } catch (e) {
      return null;
    }
  }
}
