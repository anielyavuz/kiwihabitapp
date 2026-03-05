// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiwihabitapp/models/challenge_model.dart';
import 'package:kiwihabitapp/models/participant_model.dart';
import 'package:kiwihabitapp/services/firestoreClass.dart';
import 'package:kiwihabitapp/widgets/streak_badge.dart';

class LeaderboardPage extends StatefulWidget {
  final ChallengeModel challenge;

  const LeaderboardPage({Key? key, required this.challenge}) : super(key: key);

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  static const _bg = Color.fromRGBO(21, 9, 35, 1);
  static const _cream = Color(0xffE4EBDE);

  List<ParticipantModel> _participants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await ChallengeService().fetchLeaderboard(widget.challenge.id);
    if (mounted) setState(() { _participants = result; _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final myUid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: _cream),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Leaderboard', style: GoogleFonts.publicSans(color: _cream, fontWeight: FontWeight.w700, fontSize: 18)),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xff6C3FC5)))
          : _participants.isEmpty
              ? Center(child: Text('No participants yet', style: GoogleFonts.publicSans(color: _cream.withOpacity(0.5))))
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _participants.length,
                  itemBuilder: (context, index) {
                    final p = _participants[index];
                    final rank = index + 1;
                    final isMe = p.uid == myUid;

                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isMe ? Color(0xff6C3FC5).withOpacity(0.15) : Color(0xff1C0F30),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isMe ? Color(0xff6C3FC5).withOpacity(0.5) : Colors.white.withOpacity(0.06),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Rank
                          SizedBox(
                            width: 32,
                            child: Text(
                              rank <= 3 ? ['🥇', '🥈', '🥉'][rank - 1] : '#$rank',
                              style: GoogleFonts.publicSans(
                                color: _cream,
                                fontSize: rank <= 3 ? 20 : 14,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(width: 12),
                          // Avatar
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(0xff6C3FC5),
                            backgroundImage: p.photoUrl.isNotEmpty ? NetworkImage(p.photoUrl) : null,
                            child: p.photoUrl.isEmpty
                                ? Text(
                                    p.userName.isNotEmpty ? p.userName[0].toUpperCase() : '?',
                                    style: GoogleFonts.publicSans(color: Colors.white, fontWeight: FontWeight.w700),
                                  )
                                : null,
                          ),
                          SizedBox(width: 12),
                          // Name + streak
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.userName + (isMe ? ' (you)' : ''),
                                  style: GoogleFonts.publicSans(
                                    color: isMe ? Color(0xff9B6AE8) : _cream,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                StreakBadge(streak: p.currentStreak, size: 12),
                              ],
                            ),
                          ),
                          // Days
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${p.totalCompletedDays}',
                                style: GoogleFonts.publicSans(
                                  color: _cream,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'days',
                                style: GoogleFonts.publicSans(color: _cream.withOpacity(0.5), fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
