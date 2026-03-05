// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:kiwihabitapp/auth/authFunctions.dart';
import 'package:kiwihabitapp/providers/challenge_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const _bg = Color.fromRGBO(21, 9, 35, 1);
  static const _cream = Color(0xffE4EBDE);
  static const _purple = Color(0xff6C3FC5);
  static const _cardBg = Color(0xff1C0F30);

  @override
  Widget build(BuildContext context) {
    final userDoc = Provider.of<DocumentSnapshot?>(context);
    final userData = userDoc?.data() as Map<String, dynamic>?;
    final cp = Provider.of<ChallengeProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    final userName = userData?['userName'] ?? user?.displayName ?? 'KiWi User';
    final email = userData?['email'] ?? user?.email ?? '';
    final photoUrl = userData?['photoUrl'] ?? user?.photoURL ?? '';
    final totalPoints = (userData?['totalPoints'] ?? 0) as int;
    final completedCount = (userData?['completedChallengesCount'] ?? 0) as int;
    final activeCount = cp.myChallenges.length;
    final badges = List<String>.from(userData?['badges'] ?? []);

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20, 24, 20, 28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: const [Color(0xff2D1B69), _bg],
                  ),
                ),
                child: Column(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: _purple,
                      backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                      child: photoUrl.isEmpty
                          ? Text(
                              userName.isNotEmpty ? userName[0].toUpperCase() : 'K',
                              style: GoogleFonts.publicSans(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                              ),
                            )
                          : null,
                    ),
                    SizedBox(height: 14),
                    Text(
                      userName,
                      style: GoogleFonts.publicSans(
                        color: _cream,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (email.isNotEmpty)
                      Text(
                        email,
                        style: GoogleFonts.publicSans(
                          color: _cream.withValues(alpha: 0.5),
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              ),

              // ── Stats ────────────────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _StatCard(value: '$totalPoints', label: 'Volt Points', icon: '⭐'),
                    SizedBox(width: 10),
                    _StatCard(value: '$activeCount', label: 'Active', icon: '🏆'),
                    SizedBox(width: 10),
                    _StatCard(value: '$completedCount', label: 'Completed', icon: '✅'),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // ── Badges ──────────────────────────────────────────────────────
              if (badges.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Badges',
                      style: GoogleFonts.publicSans(
                        color: _cream,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: badges
                        .map(
                          (badge) => Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _purple.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: _purple.withValues(alpha: 0.4)),
                            ),
                            child: Text(
                              badge,
                              style: GoogleFonts.publicSans(color: _cream, fontSize: 13),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(height: 20),
              ] else ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    child: Row(
                      children: [
                        Text('🏅', style: TextStyle(fontSize: 24)),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'No badges yet',
                              style: GoogleFonts.publicSans(
                                color: _cream,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Complete challenges to earn badges!',
                              style: GoogleFonts.publicSans(
                                color: _cream.withValues(alpha: 0.5),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],

              // ── Actions ──────────────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _ActionRow(
                      icon: Icons.logout_outlined,
                      label: 'Sign Out',
                      iconColor: Colors.red.shade400,
                      onTap: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: _cardBg,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: Text(
                              'Sign Out',
                              style: GoogleFonts.publicSans(
                                color: _cream,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            content: Text(
                              'Are you sure you want to sign out?',
                              style: GoogleFonts.publicSans(
                                color: _cream.withValues(alpha: 0.7),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.publicSans(
                                    color: _cream.withValues(alpha: 0.6),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(
                                  'Sign Out',
                                  style: GoogleFonts.publicSans(
                                    color: Colors.red.shade400,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          await AuthService().signOut();
                          // CheckAuth will automatically redirect to LoginPage
                        }
                      },
                    ),
                    _ActionRow(
                      icon: Icons.delete_forever_outlined,
                      label: 'Delete Account',
                      iconColor: Colors.red.shade700,
                      onTap: () {
                        final registerType =
                            userData?['registerType'] as String? ?? 'Email';
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) =>
                              _DeleteAccountDialog(registerType: registerType),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // App version
              Text(
                'Volt v2.0',
                style: GoogleFonts.publicSans(
                  color: _cream.withValues(alpha: 0.2),
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final String icon;

  const _StatCard({required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Color(0xff1C0F30),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Column(
          children: [
            Text(icon, style: TextStyle(fontSize: 22)),
            SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.publicSans(
                color: Color(0xffE4EBDE),
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.publicSans(
                color: Color(0xffE4EBDE).withValues(alpha: 0.5),
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final VoidCallback onTap;

  const _ActionRow({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Color(0xff1C0F30),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            SizedBox(width: 14),
            Text(
              label,
              style: GoogleFonts.publicSans(
                color: Color(0xffE4EBDE),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Icon(
              Icons.chevron_right,
              color: Color(0xffE4EBDE).withValues(alpha: 0.3),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _DeleteAccountDialog extends StatefulWidget {
  final String registerType;
  const _DeleteAccountDialog({required this.registerType});

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  static const _bg = Color(0xff1C0F30);
  static const _cream = Color(0xffE4EBDE);

  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  String? _error;

  bool get _isEmailUser => widget.registerType == 'Email';

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onDelete() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final password = _isEmailUser ? _passwordController.text.trim() : null;
    final result = await AuthService().deleteAccount(password: password);

    if (!mounted) return;

    if (result == null) {
      // Success — authStateChanges() navigates to LoginPage automatically
      Navigator.of(context).pop();
    } else if (result == 'cancelled') {
      setState(() {
        _loading = false;
        _error = null;
      });
    } else {
      setState(() {
        _loading = false;
        _error = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _bg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red.shade400, size: 22),
          SizedBox(width: 8),
          Text(
            'Delete Account',
            style: GoogleFonts.publicSans(
              color: _cream,
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This will permanently delete your account and all your progress. This action cannot be undone.',
            style: GoogleFonts.publicSans(
              color: _cream.withValues(alpha: 0.7),
              fontSize: 13,
            ),
          ),
          if (_isEmailUser) ...[
            SizedBox(height: 16),
            Text(
              'Enter your password to confirm:',
              style: GoogleFonts.publicSans(
                color: _cream.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: _obscure,
              style: GoogleFonts.publicSans(color: _cream, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: GoogleFonts.publicSans(
                  color: _cream.withValues(alpha: 0.3),
                  fontSize: 14,
                ),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.red.shade700),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                    color: _cream.withValues(alpha: 0.4),
                    size: 18,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
          ] else ...[
            SizedBox(height: 12),
            Text(
              'You will be asked to sign in with ${widget.registerType} to confirm.',
              style: GoogleFonts.publicSans(
                color: _cream.withValues(alpha: 0.5),
                fontSize: 12,
              ),
            ),
          ],
          if (_error != null) ...[
            SizedBox(height: 12),
            Text(
              _error!,
              style: GoogleFonts.publicSans(
                color: Colors.red.shade400,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: GoogleFonts.publicSans(
              color: _cream.withValues(alpha: 0.6),
            ),
          ),
        ),
        TextButton(
          onPressed: _loading ? null : _onDelete,
          child: _loading
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.red.shade700,
                  ),
                )
              : Text(
                  'Delete Account',
                  style: GoogleFonts.publicSans(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ],
    );
  }
}
