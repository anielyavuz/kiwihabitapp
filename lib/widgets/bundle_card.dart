// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:kiwihabitapp/models/bundle_model.dart';

class BundleCard extends StatelessWidget {
  final BundleModel bundle;
  final bool isJoined;
  final VoidCallback onTap;

  const BundleCard({
    super.key,
    required this.bundle,
    required this.isJoined,
    required this.onTap,
  });

  static const _cream = Color(0xffE4EBDE);

  Color _parseColor(String hex) {
    try {
      return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return const Color(0xff2D1B69);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = _parseColor(bundle.coverColor);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 180,
        margin: EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              cardColor,
              cardColor.withValues(alpha: 0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Lottie icon
                  Lottie.asset(
                    'assets/json/${bundle.iconName}.json',
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 8),
                  // Title
                  Text(
                    bundle.title,
                    style: GoogleFonts.publicSans(
                      color: _cream,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  // Challenges + participants row
                  Row(
                    children: [
                      Icon(Icons.layers_outlined, color: _cream.withValues(alpha: 0.75), size: 12),
                      SizedBox(width: 4),
                      Text(
                        '${bundle.challengeIds.length}',
                        style: GoogleFonts.publicSans(color: _cream.withValues(alpha: 0.75), fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.people_outline, color: _cream.withValues(alpha: 0.75), size: 12),
                      SizedBox(width: 4),
                      Text(
                        '${bundle.participantCount}',
                        style: GoogleFonts.publicSans(color: _cream.withValues(alpha: 0.75), fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  // Final check time row
                  if (bundle.finalCheckTime.isNotEmpty) ...[
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '\u{1F514}',
                          style: TextStyle(fontSize: 11),
                        ),
                        SizedBox(width: 4),
                        Text(
                          bundle.finalCheckTime,
                          style: GoogleFonts.publicSans(
                            color: Colors.orange,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            // Joined badge
            if (isJoined)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade700,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, color: Colors.white, size: 10),
                      SizedBox(width: 3),
                      Text(
                        'Joined',
                        style: GoogleFonts.publicSans(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
