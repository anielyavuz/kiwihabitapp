// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:kiwihabitapp/pages/challenge/challengeDetailPage.dart';
import 'package:kiwihabitapp/providers/challenge_provider.dart';
import 'package:kiwihabitapp/widgets/challenge_card.dart';

class MyChallengesTab extends StatelessWidget {
  const MyChallengesTab({super.key});

  static const _bg = Color.fromRGBO(21, 9, 35, 1);
  static const _cream = Color(0xffE4EBDE);
  static const _purple = Color(0xff6C3FC5);

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<ChallengeProvider>(context);

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'My Challenges',
                          style: GoogleFonts.publicSans(
                            color: _cream,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        if (cp.myChallenges.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _purple.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _purple.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Text(
                              '${cp.myChallenges.length} active',
                              style: GoogleFonts.publicSans(
                                color: _purple,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Track your daily check-ins',
                      style: GoogleFonts.publicSans(
                        color: _cream.withValues(alpha: 0.5),
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            if (cp.isLoading)
              SliverFillRemaining(
                child: Center(
                  child: Lottie.asset('assets/json/loading.json', width: 100),
                ),
              )
            else if (cp.myChallenges.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/json/exercise.json', width: 150),
                      SizedBox(height: 20),
                      Text(
                        'No active challenges yet',
                        style: GoogleFonts.publicSans(
                          color: _cream,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Go to Discover to join your first challenge!',
                          style: GoogleFonts.publicSans(
                            color: _cream.withValues(alpha: 0.5),
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final challenge = cp.myChallenges[index];
                      return ChallengeCard(
                        challenge: challenge,
                        hasCheckedInToday: cp.hasCheckedInToday(challenge.id),
                        streak: cp.getStreak(challenge.id),
                        showCheckIn: true,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ChallengeDetailPage(challenge: challenge),
                          ),
                        ),
                      );
                    },
                    childCount: cp.myChallenges.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
