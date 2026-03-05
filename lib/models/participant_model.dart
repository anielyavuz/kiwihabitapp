import 'package:cloud_firestore/cloud_firestore.dart';

class ParticipantModel {
  final String uid;
  final String userName;
  final String photoUrl;
  final Timestamp? joinDate;
  final int currentStreak;
  final int longestStreak;
  final int totalCompletedDays;
  final String lastCheckInDate; // "yyyy-MM-dd"
  final Map<String, bool> checkIns; // {"2026-03-01": true, ...}
  final Map<String, int> checkInPoints; // {"2026-03-01": 8, ...} points earned per day
  final Map<String, Map<String, bool>> subTaskCheckIns; // {"2026-03-01": {"0": true, "1": false}}
  final bool isCompleted;

  ParticipantModel({
    required this.uid,
    required this.userName,
    required this.photoUrl,
    this.joinDate,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalCompletedDays,
    required this.lastCheckInDate,
    required this.checkIns,
    this.checkInPoints = const {},
    this.subTaskCheckIns = const {},
    required this.isCompleted,
  });

  factory ParticipantModel.fromMap(Map<String, dynamic> data) {
    final rawCheckIns = data['checkIns'] as Map<String, dynamic>? ?? {};
    final rawCheckInPoints = data['checkInPoints'] as Map<String, dynamic>? ?? {};
    final rawSubTaskCheckIns = data['subTaskCheckIns'] as Map<String, dynamic>? ?? {};
    return ParticipantModel(
      uid: data['uid'] ?? '',
      userName: data['userName'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      joinDate: data['joinDate'] as Timestamp?,
      currentStreak: (data['currentStreak'] ?? 0).toInt(),
      longestStreak: (data['longestStreak'] ?? 0).toInt(),
      totalCompletedDays: (data['totalCompletedDays'] ?? 0).toInt(),
      lastCheckInDate: data['lastCheckInDate'] ?? '',
      checkIns: rawCheckIns.map((k, v) => MapEntry(k, v as bool)),
      checkInPoints: rawCheckInPoints.map((k, v) => MapEntry(k, (v as num).toInt())),
      subTaskCheckIns: rawSubTaskCheckIns.map((day, subMap) {
        final inner = (subMap as Map<String, dynamic>).map((k, v) => MapEntry(k, v as bool));
        return MapEntry(day, inner);
      }),
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userName': userName,
      'photoUrl': photoUrl,
      'joinDate': joinDate ?? FieldValue.serverTimestamp(),
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'totalCompletedDays': totalCompletedDays,
      'lastCheckInDate': lastCheckInDate,
      'checkIns': checkIns,
      'checkInPoints': checkInPoints,
      'subTaskCheckIns': subTaskCheckIns,
      'isCompleted': isCompleted,
    };
  }
}
