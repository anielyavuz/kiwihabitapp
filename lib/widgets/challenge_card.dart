// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:kiwihabitapp/models/challenge_model.dart';
import 'package:kiwihabitapp/widgets/category_chip.dart';

class ChallengeCard extends StatelessWidget {
  final ChallengeModel challenge;
  final VoidCallback onTap;
  final bool? hasCheckedInToday;
  final int streak;
  final bool showCheckIn;
  final bool isJoined;

  const ChallengeCard({
    super.key,
    required this.challenge,
    required this.onTap,
    this.hasCheckedInToday,
    this.streak = 0,
    this.showCheckIn = false,
    this.isJoined = false,
  });

  Color _parseColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return const Color(0xff2D1B69);
    }
  }

  String _lottieAsset(String iconName) {
    return 'assets/json/$iconName.json';
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = _parseColor(challenge.coverColor);
    final categoryColor = CategoryChip.colorForCategory(challenge.category);

    final cardWidget = GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Color(0xff1C0F30),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.06), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gradient header
                Container(
                  height: 90,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        cardColor,
                        cardColor.withValues(alpha: 0.6),
                        Color(0xff1C0F30),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Lottie.asset(
                          _lottieAsset(challenge.iconName),
                          width: 64,
                          height: 64,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                challenge.title,
                                style: GoogleFonts.publicSans(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${challenge.durationDays} days · ${challenge.category}',
                                  style: GoogleFonts.publicSans(
                                    color:
                                        Colors.white.withValues(alpha: 0.9),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Body
                Padding(
                  padding: EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge.dailyGoalDescription,
                        style: GoogleFonts.publicSans(
                          color: Color(0xffE4EBDE).withValues(alpha: 0.7),
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.people_outline,
                              color: categoryColor, size: 16),
                          SizedBox(width: 4),
                          Text(
                            '${challenge.participantCount} joined',
                            style: GoogleFonts.publicSans(
                              color:
                                  Color(0xffE4EBDE).withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                          ),
                          if (showCheckIn && streak > 0) ...[
                            SizedBox(width: 16),
                            Text('🔥', style: TextStyle(fontSize: 14)),
                            SizedBox(width: 4),
                            Text(
                              '$streak day streak',
                              style: GoogleFonts.publicSans(
                                color: Colors.orange.shade300,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                          if (showCheckIn && hasCheckedInToday == true) ...[
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.shade700
                                    .withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.green.shade500, width: 0.5),
                              ),
                              child: Text(
                                '✓ Done today',
                                style: GoogleFonts.publicSans(
                                  color: Colors.green.shade300,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // "✓ Joined" badge in top-right corner
          if (isJoined)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade700,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '✓ Joined',
                  style: GoogleFonts.publicSans(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (isJoined) {
      return Opacity(opacity: 0.45, child: cardWidget);
    }
    return cardWidget;
  }
}
