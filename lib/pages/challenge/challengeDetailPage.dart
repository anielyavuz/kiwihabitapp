// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:kiwihabitapp/models/challenge_model.dart';
import 'package:kiwihabitapp/pages/challenge/checkInPage.dart';
import 'package:kiwihabitapp/pages/challenge/leaderboardPage.dart';
import 'package:kiwihabitapp/providers/challenge_provider.dart';
import 'package:kiwihabitapp/services/local_notification_service.dart';
import 'package:kiwihabitapp/widgets/check_in_button.dart';
import 'package:kiwihabitapp/widgets/streak_badge.dart';
import 'package:kiwihabitapp/widgets/sub_task_check_in_section.dart';

class ChallengeDetailPage extends StatelessWidget {
  final ChallengeModel challenge;

  const ChallengeDetailPage({Key? key, required this.challenge}) : super(key: key);

  static const _bg = Color.fromRGBO(21, 9, 35, 1);
  static const _cream = Color(0xffE4EBDE);
  static const _purple = Color(0xff6C3FC5);

  Color _parseColor(String hex) {
    try {
      return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return const Color(0xff2D1B69);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<ChallengeProvider>(context);
    final user = FirebaseAuth.instance.currentUser;
    final userDoc = Provider.of<DocumentSnapshot?>(context);
    final userData = userDoc?.data() as Map<String, dynamic>?;

    final cardColor = _parseColor(challenge.coverColor);
    final isJoined = cp.isJoined(challenge.id);
    final hasCheckedIn = cp.hasCheckedInToday(challenge.id);
    final streak = cp.getStreak(challenge.id);

    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(
        slivers: [
          // Hero header
          SliverAppBar(
            expandedHeight: 220,
            backgroundColor: _bg,
            pinned: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: _cream),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [cardColor, cardColor.withOpacity(0.5), _bg],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40),
                      Lottie.asset('assets/json/${challenge.iconName}.json', width: 100, height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + streak
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          challenge.title,
                          style: GoogleFonts.publicSans(
                            color: _cream,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (streak > 0) ...[
                        SizedBox(width: 12),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange.withOpacity(0.4)),
                          ),
                          child: StreakBadge(streak: streak, size: 16),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 8),

                  // Meta chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _MetaChip(
                        icon: Icons.calendar_today_outlined,
                        label: '${challenge.durationDays} days',
                        color: cardColor,
                      ),
                      _MetaChip(
                        icon: Icons.category_outlined,
                        label: challenge.category,
                        color: cardColor,
                      ),
                      _MetaChip(
                        icon: Icons.people_outline,
                        label: '${challenge.participantCount} joined',
                        color: cardColor,
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Description
                  Text(
                    'About this challenge',
                    style: GoogleFonts.publicSans(color: _cream, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 8),
                  Text(
                    challenge.description,
                    style: GoogleFonts.publicSans(color: _cream.withOpacity(0.7), fontSize: 14, height: 1.6),
                  ),

                  SizedBox(height: 20),

                  // Daily goal
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: cardColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.flag_outlined, color: cardColor, size: 22),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Daily Goal',
                                style: GoogleFonts.publicSans(color: _cream.withOpacity(0.6), fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 2),
                              Text(
                                challenge.dailyGoalDescription,
                                style: GoogleFonts.publicSans(color: _cream, fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Sub-tasks section (only if challenge has sub-tasks)
                  if (challenge.subTasks.isNotEmpty && isJoined) ...[
                    SubTaskCheckInSection(challenge: challenge),
                    SizedBox(height: 20),
                  ],

                  // Leaderboard button
                  if (isJoined)
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LeaderboardPage(challenge: challenge)),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Color(0xff1C0F30),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: _purple.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.leaderboard_outlined, color: _purple, size: 20),
                            SizedBox(width: 12),
                            Text(
                              'View Leaderboard',
                              style: GoogleFonts.publicSans(color: _cream, fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            Spacer(),
                            Icon(Icons.chevron_right, color: _cream.withOpacity(0.4), size: 20),
                          ],
                        ),
                      ),
                    ),

                  SizedBox(height: 24),

                  // Check in or Join button
                  if (isJoined)
                    CheckInButton(
                      alreadyCheckedIn: hasCheckedIn,
                      onCheckIn: () async {
                        final success = await cp.checkInToday(challenge.id);
                        if (success && context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CheckInPage(
                                challengeTitle: challenge.title,
                                newStreak: cp.getStreak(challenge.id),
                              ),
                            ),
                          );
                        }
                      },
                      onUndo: () async {
                        final success = await cp.undoCheckInToday(challenge.id);
                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Check-in undone. Points returned.', style: GoogleFonts.publicSans()),
                              backgroundColor: Colors.orange.shade800,
                            ),
                          );
                        }
                      },
                    )
                  else
                    ElevatedButton(
                      onPressed: () async {
                        if (user == null) return;
                        final userName = userData?['userName'] ?? 'KiWi User';
                        final photoUrl = userData?['photoUrl'] ?? '';
                        final success = await cp.joinChallenge(
                          challengeId: challenge.id,
                          userName: userName,
                          photoUrl: photoUrl,
                        );
                        if (success) {
                          // Schedule daily notifications if the challenge has check times
                          final notif = NotificationsServices();
                          final notifBase = challenge.id.hashCode.abs() % 100000;
                          if (challenge.preCheckTime.isNotEmpty) {
                            final parts = challenge.preCheckTime.split(':');
                            await notif.scheduleDailyNotification(
                              id: notifBase * 2,
                              title: 'Pre-Check ⏰',
                              body: 'Time to prep for "${challenge.title}"!',
                              time: TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1])),
                            );
                          }
                          if (challenge.finalCheckTime.isNotEmpty) {
                            final parts = challenge.finalCheckTime.split(':');
                            await notif.scheduleDailyNotification(
                              id: notifBase * 2 + 1,
                              title: 'Final Check 🔔',
                              body: 'Last chance to check in for "${challenge.title}" — points decay after this!',
                              time: TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1])),
                            );
                          }
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Joined! Check in daily to build your streak.', style: GoogleFonts.publicSans()),
                                backgroundColor: Colors.green.shade800,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _purple,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: Text(
                        'Join Challenge 🚀',
                        style: GoogleFonts.publicSans(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetaChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.publicSans(color: Color(0xffE4EBDE), fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
