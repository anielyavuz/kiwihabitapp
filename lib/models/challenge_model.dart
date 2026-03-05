import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeModel {
  final String id;
  final String title;
  final String description;
  final String category; // "Sport", "Health", "Study", "Art", "Finance", "Social"
  final String iconName; // lottie asset name: "exercise", "yoga", "read", "sleep", "work"
  final int durationDays;
  final String creatorUid;
  final String creatorName;
  final bool isAdminCreated;
  final bool isPublic;
  final int participantCount;
  final Timestamp? createTime;
  final String dailyGoalDescription;
  final String coverColor; // hex string e.g. "#1A6B3C"
  final List<String> tags;
  final String preCheckTime;   // "HH:mm" e.g. "09:00"; empty = no notification
  final String finalCheckTime; // "HH:mm" e.g. "21:00"; empty = no notification
  final List<String> subTasks; // e.g. ["Morning", "Noon", "Evening"]; empty = single check-in mode

  ChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.iconName,
    required this.durationDays,
    required this.creatorUid,
    required this.creatorName,
    required this.isAdminCreated,
    required this.isPublic,
    required this.participantCount,
    this.createTime,
    required this.dailyGoalDescription,
    required this.coverColor,
    required this.tags,
    this.preCheckTime = '',
    this.finalCheckTime = '',
    this.subTasks = const [],
  });

  factory ChallengeModel.fromMap(String id, Map<String, dynamic> data) {
    return ChallengeModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? 'Sport',
      iconName: data['iconName'] ?? 'exercise',
      durationDays: (data['durationDays'] ?? 30).toInt(),
      creatorUid: data['creatorUid'] ?? '',
      creatorName: data['creatorName'] ?? '',
      isAdminCreated: data['isAdminCreated'] ?? false,
      isPublic: data['isPublic'] ?? true,
      participantCount: (data['participantCount'] ?? 0).toInt(),
      createTime: data['createTime'] as Timestamp?,
      dailyGoalDescription: data['dailyGoalDescription'] ?? '',
      coverColor: data['coverColor'] ?? '#2D1B69',
      tags: List<String>.from(data['tags'] ?? []),
      preCheckTime: data['preCheckTime'] as String? ?? '',
      finalCheckTime: data['finalCheckTime'] as String? ?? '',
      subTasks: List<String>.from(data['subTasks'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'iconName': iconName,
      'durationDays': durationDays,
      'creatorUid': creatorUid,
      'creatorName': creatorName,
      'isAdminCreated': isAdminCreated,
      'isPublic': isPublic,
      'participantCount': participantCount,
      'createTime': createTime ?? FieldValue.serverTimestamp(),
      'dailyGoalDescription': dailyGoalDescription,
      'coverColor': coverColor,
      'tags': tags,
      'preCheckTime': preCheckTime,
      'finalCheckTime': finalCheckTime,
      'subTasks': subTasks,
    };
  }
}
