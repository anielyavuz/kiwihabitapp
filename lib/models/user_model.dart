class UserModel {
  final String uid;
  final String userName;
  final String email;
  final String photoUrl;
  final String registerType; // "Google", "Apple", "Email"
  final String createTime;
  final int totalPoints;
  final int completedChallengesCount;
  final List<String> activeChallengeIds;
  final List<String> badges;

  UserModel({
    required this.uid,
    required this.userName,
    required this.email,
    required this.photoUrl,
    required this.registerType,
    required this.createTime,
    required this.totalPoints,
    required this.completedChallengesCount,
    required this.activeChallengeIds,
    required this.badges,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['id'] ?? '',
      userName: data['userName'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      registerType: data['registerType'] ?? '',
      createTime: data['createTime'] ?? '',
      totalPoints: (data['totalPoints'] ?? 0).toInt(),
      completedChallengesCount: (data['completedChallengesCount'] ?? 0).toInt(),
      activeChallengeIds: List<String>.from(data['activeChallengeIds'] ?? []),
      badges: List<String>.from(data['badges'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': uid,
      'userName': userName,
      'email': email,
      'photoUrl': photoUrl,
      'registerType': registerType,
      'createTime': createTime,
      'totalPoints': totalPoints,
      'completedChallengesCount': completedChallengesCount,
      'activeChallengeIds': activeChallengeIds,
      'badges': badges,
    };
  }
}
