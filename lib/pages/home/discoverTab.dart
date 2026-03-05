// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:kiwihabitapp/pages/bundle/bundleDetailPage.dart';
import 'package:kiwihabitapp/pages/bundle/createBundlePage.dart';
import 'package:kiwihabitapp/pages/challenge/challengeDetailPage.dart';
import 'package:kiwihabitapp/pages/challenge/createChallengePage.dart';
import 'package:kiwihabitapp/providers/challenge_provider.dart';
import 'package:kiwihabitapp/widgets/bundle_card.dart';
import 'package:kiwihabitapp/widgets/category_chip.dart';
import 'package:kiwihabitapp/widgets/challenge_card.dart';

class DiscoverTab extends StatefulWidget {
  const DiscoverTab({super.key});

  @override
  State<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab> {
  static const _bg = Color.fromRGBO(21, 9, 35, 1);
  static const _cream = Color(0xffE4EBDE);
  static const _purple = Color(0xff6C3FC5);

  String _selectedCategory = 'All';
  final _categories = [
    'All',
    'Sport',
    'Health',
    'Nutrition',
    'Mindfulness',
    'Study',
    'Language',
    'Productivity',
    'Sleep',
    'Art',
    'Finance',
    'Social',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cp = Provider.of<ChallengeProvider>(context, listen: false);
      cp.fetchDiscoverChallenges();
      cp.fetchDiscoverBundles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<ChallengeProvider>(context);

    // Sync joined bundle IDs from user document
    final userDoc = Provider.of<DocumentSnapshot?>(context);
    final userData = userDoc?.data() as Map<String, dynamic>?;
    if (userData != null) {
      cp.setJoinedBundleIds(
        List<String>.from(userData['activeBundleIds'] ?? []),
      );
    }

    final displayed = _selectedCategory == 'All'
        ? cp.discoverChallenges
        : cp.discoverChallenges
            .where((c) => c.category == _selectedCategory)
            .toList();

    final bundles = cp.discoverBundles;

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
                    // Header row
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Discover',
                              style: GoogleFonts.publicSans(
                                color: _cream,
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Find your next challenge',
                              style: GoogleFonts.publicSans(
                                color: _cream.withValues(alpha: 0.5),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CreateChallengePage(),
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _purple,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'Create',
                                  style: GoogleFonts.publicSans(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Category chips
                    SizedBox(
                      height: 38,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, i) => CategoryChip(
                          label: _categories[i],
                          isSelected: _selectedCategory == _categories[i],
                          onTap: () {
                            setState(
                                () => _selectedCategory = _categories[i]);
                            final cat = _categories[i] == 'All'
                                ? null
                                : _categories[i];
                            cp.fetchDiscoverChallenges(category: cat);
                            cp.fetchDiscoverBundles(category: cat);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Bundles section (only when bundles exist)
                    if (bundles.isNotEmpty) ...[
                      Row(
                        children: [
                          Text(
                            'Bundles',
                            style: GoogleFonts.publicSans(
                              color: _cream,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CreateBundlePage(),
                              ),
                            ),
                            child: Icon(
                              Icons.add,
                              color: _cream.withValues(alpha: 0.5),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        height: 190,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: bundles.length,
                          itemBuilder: (context, i) {
                            final bundle = bundles[i];
                            return BundleCard(
                              bundle: bundle,
                              isJoined: cp.isJoinedBundle(bundle.id),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      BundleDetailPage(bundle: bundle),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                    ],

                    // Challenges section header
                    Text(
                      'Challenges',
                      style: GoogleFonts.publicSans(
                        color: _cream,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // Challenge list / loading / empty states
            if (cp.isLoading)
              SliverFillRemaining(
                child: Center(
                  child: Lottie.asset('assets/json/loading.json', width: 100),
                ),
              )
            else if (displayed.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        color: _cream.withValues(alpha: 0.3),
                        size: 64,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No challenges found',
                        style: GoogleFonts.publicSans(
                          color: _cream.withValues(alpha: 0.6),
                          fontSize: 16,
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
                      final challenge = displayed[index];
                      return ChallengeCard(
                        challenge: challenge,
                        isJoined: cp.isJoined(challenge.id),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ChallengeDetailPage(challenge: challenge),
                          ),
                        ),
                      );
                    },
                    childCount: displayed.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
