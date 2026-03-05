// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:kiwihabitapp/models/bundle_model.dart';
import 'package:kiwihabitapp/providers/challenge_provider.dart';
import 'package:kiwihabitapp/services/local_notification_service.dart';

class BundleDetailPage extends StatelessWidget {
  final BundleModel bundle;

  const BundleDetailPage({super.key, required this.bundle});

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

  Future<void> _joinBundle(
    BuildContext context,
    ChallengeProvider cp,
    Map<String, dynamic>? userData,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final success = await cp.joinBundle(
      bundleId: bundle.id,
      userName: userData?['userName'] ?? 'KiWi User',
      photoUrl: userData?['photoUrl'] ?? '',
      challengeIds: bundle.challengeIds,
      preCheckTime: bundle.preCheckTime,
      finalCheckTime: bundle.finalCheckTime,
    );
    if (success) {
      final notif = NotificationsServices();
      final notifBase = bundle.id.hashCode.abs() % 100000;
      if (bundle.preCheckTime.isNotEmpty) {
        final parts = bundle.preCheckTime.split(':');
        await notif.scheduleDailyNotification(
          id: notifBase * 2,
          title: 'Pre-Check \u23F0',
          body: 'Time to prep for "${bundle.title}" bundle!',
          time: TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1])),
        );
      }
      if (bundle.finalCheckTime.isNotEmpty) {
        final parts = bundle.finalCheckTime.split(':');
        await notif.scheduleDailyNotification(
          id: notifBase * 2 + 1,
          title: 'Final Check \u{1F514}',
          body: 'Last chance to check in for "${bundle.title}" \u2014 points decay after this!',
          time: TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1])),
        );
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Joined bundle! All challenges added to My Challenges.',
            style: GoogleFonts.publicSans(),
          ),
          backgroundColor: Colors.green.shade800,
        ));
      }
    }
  }

  Future<void> _leaveBundle(BuildContext context, ChallengeProvider cp) async {
    final success = await cp.leaveBundle(
      bundleId: bundle.id,
      challengeIds: bundle.challengeIds,
    );
    if (success) {
      final notif = NotificationsServices();
      final notifBase = bundle.id.hashCode.abs() % 100000;
      await notif.cancelNotification(notifBase * 2);
      await notif.cancelNotification(notifBase * 2 + 1);
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Left bundle.', style: GoogleFonts.publicSans()),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<ChallengeProvider>(context);
    final isJoined = cp.isJoinedBundle(bundle.id);
    final userDoc = Provider.of<DocumentSnapshot?>(context);
    final userData = userDoc?.data() as Map<String, dynamic>?;

    final cardColor = _parseColor(bundle.coverColor);

    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(
        slivers: [
          // Hero header
          SliverAppBar(
            expandedHeight: 200,
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
                    colors: [cardColor, cardColor.withValues(alpha: 0.5), _bg],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40),
                      Lottie.asset(
                        'assets/json/${bundle.iconName}.json',
                        width: 90,
                        height: 90,
                      ),
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
                  // Title + joined chip
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          bundle.title,
                          style: GoogleFonts.publicSans(
                            color: _cream,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (isJoined) ...[
                        SizedBox(width: 12),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.green.shade800.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.green.shade600),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check, color: Colors.green.shade400, size: 13),
                              SizedBox(width: 4),
                              Text(
                                'Joined',
                                style: GoogleFonts.publicSans(
                                  color: Colors.green.shade400,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 12),

                  // Meta chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _MetaChip(
                        icon: Icons.layers_outlined,
                        label: '${bundle.challengeIds.length} challenges',
                        color: cardColor,
                      ),
                      _MetaChip(
                        icon: Icons.people_outline,
                        label: '${bundle.participantCount} joined',
                        color: cardColor,
                      ),
                      _MetaChip(
                        icon: Icons.category_outlined,
                        label: bundle.category,
                        color: cardColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Notification times section
                  if (bundle.preCheckTime.isNotEmpty || bundle.finalCheckTime.isNotEmpty) ...[
                    Container(
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _purple.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _purple.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.notifications_outlined, color: _purple, size: 20),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Daily Reminders',
                                  style: GoogleFonts.publicSans(
                                    color: _cream.withValues(alpha: 0.6),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    if (bundle.preCheckTime.isNotEmpty) ...[
                                      Text(
                                        '\u23F0 ${bundle.preCheckTime}',
                                        style: GoogleFonts.publicSans(
                                          color: _cream,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                    ],
                                    if (bundle.finalCheckTime.isNotEmpty)
                                      Text(
                                        '\u{1F514} ${bundle.finalCheckTime}',
                                        style: GoogleFonts.publicSans(
                                          color: Colors.orange,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],

                  // About
                  Text(
                    'About this bundle',
                    style: GoogleFonts.publicSans(
                      color: _cream,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    bundle.description,
                    style: GoogleFonts.publicSans(
                      color: _cream.withValues(alpha: 0.7),
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Challenges list
                  Text(
                    'Challenges in this bundle',
                    style: GoogleFonts.publicSans(
                      color: _cream,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: bundle.challengeIds.length,
                    separatorBuilder: (_, __) => SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final rawId = bundle.challengeIds[i];
                      final displayId = rawId.length > 8
                          ? '${rawId.substring(0, 8)}...'
                          : rawId;
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: _purple.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _purple.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: _cream.withValues(alpha: 0.4),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Challenge ${i + 1}  ($displayId)',
                              style: GoogleFonts.publicSans(
                                color: _cream.withValues(alpha: 0.85),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 24),

                  // Join / Leave button
                  if (isJoined)
                    OutlinedButton(
                      onPressed: () => _leaveBundle(context, cp),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade400,
                        side: BorderSide(color: Colors.red.shade400),
                        minimumSize: Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Leave Bundle',
                        style: GoogleFonts.publicSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.red.shade400,
                        ),
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: () => _joinBundle(context, cp, userData),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _purple,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Join Bundle \u{1F680}',
                        style: GoogleFonts.publicSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
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
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.publicSans(
              color: Color(0xffE4EBDE),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
