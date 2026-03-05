// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:kiwihabitapp/pages/home/myChallengesTab.dart';
import 'package:kiwihabitapp/pages/home/discoverTab.dart';
import 'package:kiwihabitapp/pages/profile/profilePage.dart';
import 'package:kiwihabitapp/providers/challenge_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  static const _bg = Color.fromRGBO(21, 9, 35, 1);
  static const _cream = Color(0xffE4EBDE);
  static const _purple = Color(0xff6C3FC5);

  late final List<Widget> _tabs;
  bool _initialLoadDone = false;

  @override
  void initState() {
    super.initState();
    _tabs = [
      MyChallengesTab(),
      DiscoverTab(),
      ProfilePage(),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialLoadDone) {
      _tryInitialLoad();
    }
  }

  void _tryInitialLoad() {
    final userDoc = Provider.of<DocumentSnapshot?>(context, listen: false);
    if (userDoc != null && userDoc.exists) {
      _initialLoadDone = true;
      final cp = Provider.of<ChallengeProvider>(context, listen: false);
      final data = userDoc.data() as Map<String, dynamic>;
      final ids = List<String>.from(data['activeChallengeIds'] ?? []);
      cp.fetchMyChallenges(ids);
    }
  }

  void _loadMyChallenges() {
    final userDoc = Provider.of<DocumentSnapshot?>(context, listen: false);
    final cp = Provider.of<ChallengeProvider>(context, listen: false);
    if (userDoc != null && userDoc.exists) {
      final data = userDoc.data() as Map<String, dynamic>;
      final ids = List<String>.from(data['activeChallengeIds'] ?? []);
      cp.fetchMyChallenges(ids);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xff120820),
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.08), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) {
            setState(() => _currentIndex = i);
            if (i == 0) _loadMyChallenges();
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: _purple,
          unselectedItemColor: _cream.withValues(alpha: 0.4),
          selectedLabelStyle: GoogleFonts.publicSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.publicSans(fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_outlined),
              activeIcon: Icon(Icons.emoji_events),
              label: 'My Challenges',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
