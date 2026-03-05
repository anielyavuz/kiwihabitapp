// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class CheckInPage extends StatelessWidget {
  final String challengeTitle;
  final int newStreak;

  const CheckInPage({Key? key, required this.challengeTitle, required this.newStreak}) : super(key: key);

  static const _bg = Color.fromRGBO(21, 9, 35, 1);
  static const _cream = Color(0xffE4EBDE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/json/check.json', width: 200, height: 200, repeat: false),
              SizedBox(height: 24),
              Text(
                '🎉 Check-In Complete!',
                style: GoogleFonts.publicSans(
                  color: _cream,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                challengeTitle,
                style: GoogleFonts.publicSans(color: _cream.withOpacity(0.7), fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              if (newStreak > 1)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Text('🔥', style: TextStyle(fontSize: 48)),
                      SizedBox(height: 8),
                      Text(
                        '$newStreak Day Streak!',
                        style: GoogleFonts.publicSans(
                          color: Colors.orange.shade300,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Keep it up! Come back tomorrow.',
                        style: GoogleFonts.publicSans(color: _cream.withOpacity(0.6), fontSize: 13),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xff1C0F30),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Column(
                    children: [
                      Text('⭐', style: TextStyle(fontSize: 40)),
                      SizedBox(height: 8),
                      Text(
                        'Great start!',
                        style: GoogleFonts.publicSans(color: _cream, fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Come back tomorrow to build your streak.',
                        style: GoogleFonts.publicSans(color: _cream.withOpacity(0.6), fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff6C3FC5),
                  foregroundColor: _cream,
                  minimumSize: Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text('Back to Challenge', style: GoogleFonts.publicSans(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
