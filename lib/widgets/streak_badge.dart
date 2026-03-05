import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StreakBadge extends StatelessWidget {
  final int streak;
  final double size;

  const StreakBadge({Key? key, required this.streak, this.size = 14}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (streak == 0) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('🔥', style: TextStyle(fontSize: size)),
        const SizedBox(width: 3),
        Text(
          '$streak',
          style: GoogleFonts.publicSans(
            color: Colors.orange.shade300,
            fontSize: size,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
