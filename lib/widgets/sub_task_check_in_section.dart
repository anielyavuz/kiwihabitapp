// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:kiwihabitapp/models/challenge_model.dart';
import 'package:kiwihabitapp/providers/challenge_provider.dart';

class SubTaskCheckInSection extends StatelessWidget {
  final ChallengeModel challenge;

  const SubTaskCheckInSection({super.key, required this.challenge});

  static const _cream = Color(0xffE4EBDE);
  static const _purple = Color(0xff6C3FC5);

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<ChallengeProvider>(context);
    final subTasks = challenge.subTasks;
    final completedCount = cp.getSubTasksCompletedToday(challenge.id);
    final allDone = completedCount == subTasks.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Today's Tasks",
              style: GoogleFonts.publicSans(color: _cream, fontSize: 16, fontWeight: FontWeight.w700),
            ),
            Spacer(),
            Text(
              '$completedCount / ${subTasks.length}',
              style: GoogleFonts.publicSans(
                color: allDone ? Colors.green.shade400 : _cream.withValues(alpha: 0.5),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        ...subTasks.asMap().entries.map((entry) {
          final index = entry.key;
          final name = entry.value;
          final isDone = cp.isSubTaskDoneToday(challenge.id, index);

          return Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: isDone
                  ? null
                  : () async {
                      await cp.checkInSubTask(challenge.id, index);
                    },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isDone ? Colors.green.withValues(alpha: 0.12) : Color(0xff1C0F30),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDone ? Colors.green.withValues(alpha: 0.4) : _cream.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDone ? Colors.green : Colors.transparent,
                        border: Border.all(
                          color: isDone ? Colors.green : _cream.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: isDone
                          ? Icon(Icons.check, color: Colors.white, size: 14)
                          : null,
                    ),
                    SizedBox(width: 14),
                    Text(
                      name,
                      style: GoogleFonts.publicSans(
                        color: isDone ? _cream.withValues(alpha: 0.6) : _cream,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        decoration: isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    Spacer(),
                    if (!isDone)
                      Text(
                        '+${_pointsHint(context).toStringAsFixed(0)} pts',
                        style: GoogleFonts.publicSans(
                          color: _purple.withValues(alpha: 0.7),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
        if (allDone) ...[
          SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
            ),
            child: Text(
              '🎉 All tasks done for today!',
              textAlign: TextAlign.center,
              style: GoogleFonts.publicSans(
                color: Colors.green.shade400,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );
  }

  double _pointsHint(BuildContext context) {
    // 10 points default, split equally — exact value comes from AppConfig.
    // For display hint only, use 10 as estimate.
    return 10 / challenge.subTasks.length;
  }
}
