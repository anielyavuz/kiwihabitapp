import 'package:cloud_firestore/cloud_firestore.dart';

class BundleModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final List<String> challengeIds;
  final String creatorUid;
  final String creatorName;
  final bool isAdminCreated;
  final bool isPublic;
  final int participantCount;
  final Timestamp? createTime;
  final String coverColor;
  final String iconName;
  final String preCheckTime;   // "HH:mm" e.g. "09:00"
  final String finalCheckTime; // "HH:mm" e.g. "21:00"
  final List<String> tags;

  const BundleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.challengeIds,
    required this.creatorUid,
    required this.creatorName,
    required this.isAdminCreated,
    required this.isPublic,
    required this.participantCount,
    this.createTime,
    required this.coverColor,
    required this.iconName,
    required this.preCheckTime,
    required this.finalCheckTime,
    required this.tags,
  });

  factory BundleModel.fromMap(String id, Map<String, dynamic> data) {
    return BundleModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? 'Sport',
      challengeIds: List<String>.from(data['challengeIds'] ?? []),
      creatorUid: data['creatorUid'] ?? '',
      creatorName: data['creatorName'] ?? 'KiWi User',
      isAdminCreated: data['isAdminCreated'] ?? false,
      isPublic: data['isPublic'] ?? true,
      participantCount: (data['participantCount'] ?? 0) as int,
      createTime: data['createTime'] as Timestamp?,
      coverColor: data['coverColor'] ?? '#2D1B69',
      iconName: data['iconName'] ?? 'exercise',
      preCheckTime: data['preCheckTime'] ?? '09:00',
      finalCheckTime: data['finalCheckTime'] ?? '21:00',
      tags: List<String>.from(data['tags'] ?? []),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'challengeIds': challengeIds,
    'creatorUid': creatorUid,
    'creatorName': creatorName,
    'isAdminCreated': isAdminCreated,
    'isPublic': isPublic,
    'participantCount': participantCount,
    'createTime': createTime,
    'coverColor': coverColor,
    'iconName': iconName,
    'preCheckTime': preCheckTime,
    'finalCheckTime': finalCheckTime,
    'tags': tags,
  };
}
