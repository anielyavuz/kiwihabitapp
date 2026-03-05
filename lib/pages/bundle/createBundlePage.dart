// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:kiwihabitapp/providers/challenge_provider.dart';
import 'package:kiwihabitapp/widgets/category_chip.dart';

class CreateBundlePage extends StatefulWidget {
  const CreateBundlePage({super.key});

  @override
  State<CreateBundlePage> createState() => _CreateBundlePageState();
}

class _CreateBundlePageState extends State<CreateBundlePage> {
  static const _bg = Color.fromRGBO(21, 9, 35, 1);
  static const _cream = Color(0xffE4EBDE);
  static const _purple = Color(0xff6C3FC5);

  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  String _selectedCategory = 'Sport';
  TimeOfDay? _preCheckTime;
  TimeOfDay? _finalCheckTime;
  bool _isLoading = false;
  final Set<String> _selectedChallengeIds = {};

  static const _categories = [
    'Sport', 'Health', 'Study', 'Art', 'Finance', 'Social',
    'Nutrition', 'Mindfulness', 'Language', 'Sleep', 'Productivity',
  ];

  static const _categoryIcons = {
    'Sport': 'exercise',
    'Health': 'yoga',
    'Study': 'read',
    'Art': 'work',
    'Finance': 'work',
    'Social': 'exercise',
    'Nutrition': 'yoga',
    'Mindfulness': 'yoga',
    'Language': 'read',
    'Sleep': 'sleep',
    'Productivity': 'work',
  };

  static const _categoryColors = {
    'Sport': '#1A6B3C',
    'Health': '#6B1A6B',
    'Study': '#1A3B6B',
    'Art': '#8B1A6B',
    'Finance': '#1A6B1A',
    'Social': '#6B4A1A',
    'Nutrition': '#6B3A1A',
    'Mindfulness': '#4B1A6B',
    'Language': '#1A5B6B',
    'Sleep': '#2B1A6B',
    'Productivity': '#4B3A1A',
  };

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _pickTime({required bool isPre}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isPre
          ? (_preCheckTime ?? const TimeOfDay(hour: 9, minute: 0))
          : (_finalCheckTime ?? const TimeOfDay(hour: 21, minute: 0)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xff6C3FC5),
            surface: Color(0xff1C0F30),
            onSurface: Color(0xffE4EBDE),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isPre) {
          _preCheckTime = picked;
        } else {
          _finalCheckTime = picked;
        }
      });
    }
  }

  Future<void> _create() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter a bundle title.',
            style: GoogleFonts.publicSans()),
      ));
      return;
    }
    if (_selectedChallengeIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Select at least one challenge.',
            style: GoogleFonts.publicSans()),
      ));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      final userDoc =
          Provider.of<DocumentSnapshot?>(context, listen: false);
      final userData = userDoc?.data() as Map<String, dynamic>?;
      final cp = Provider.of<ChallengeProvider>(context, listen: false);

      final id = await cp.createNewBundle(
        creatorUid: user?.uid ?? '',
        creatorName: userData?['userName'] ?? 'KiWi User',
        title: _titleController.text.trim(),
        description: _descController.text.trim().isNotEmpty
            ? _descController.text.trim()
            : 'A $_selectedCategory challenge bundle!',
        category: _selectedCategory,
        iconName: _categoryIcons[_selectedCategory] ?? 'exercise',
        coverColor: _categoryColors[_selectedCategory] ?? '#2D1B69',
        challengeIds: _selectedChallengeIds.toList(),
        preCheckTime:
            _preCheckTime != null ? _formatTime(_preCheckTime!) : '',
        finalCheckTime:
            _finalCheckTime != null ? _formatTime(_finalCheckTime!) : '',
      );

      if (mounted) {
        setState(() => _isLoading = false);
        if (id != null) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Bundle created! Others can now find and join it.',
                style: GoogleFonts.publicSans()),
            backgroundColor: Colors.green.shade800,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Failed to create bundle. Check your connection and try again.',
                style: GoogleFonts.publicSans()),
            backgroundColor: Colors.red.shade800,
          ));
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Something went wrong. Please try again.',
              style: GoogleFonts.publicSans()),
          backgroundColor: Colors.red.shade800,
        ));
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: _cream),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Bundle',
          style: GoogleFonts.publicSans(
              color: _cream, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Label('Bundle Title'),
            SizedBox(height: 8),
            TextField(
              controller: _titleController,
              style: GoogleFonts.publicSans(
                  color: Color(0xff150923), fontSize: 15),
              maxLength: 50,
              decoration: InputDecoration(
                hintText: 'e.g. Morning Routine Bundle',
                hintStyle:
                    GoogleFonts.publicSans(color: Colors.grey.shade500),
                filled: true,
                fillColor: _cream,
                counterStyle: GoogleFonts.publicSans(
                    color: _cream.withValues(alpha: 0.4)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
            ),

            SizedBox(height: 16),
            _Label('Description (optional)'),
            SizedBox(height: 8),
            TextField(
              controller: _descController,
              style: GoogleFonts.publicSans(
                  color: Color(0xff150923), fontSize: 14),
              maxLines: 3,
              maxLength: 200,
              decoration: InputDecoration(
                hintText: 'Describe this bundle...',
                hintStyle: GoogleFonts.publicSans(
                    color: Colors.grey.shade500, fontSize: 13),
                filled: true,
                fillColor: _cream,
                counterStyle: GoogleFonts.publicSans(
                    color: _cream.withValues(alpha: 0.4)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none),
                contentPadding: EdgeInsets.all(16),
              ),
            ),

            SizedBox(height: 16),
            _Label('Category'),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories
                  .map((cat) => CategoryChip(
                        label: cat,
                        isSelected: _selectedCategory == cat,
                        onTap: () =>
                            setState(() => _selectedCategory = cat),
                      ))
                  .toList(),
            ),

            SizedBox(height: 24),
            _Label('Select Challenges'),
            SizedBox(height: 4),
            Text(
              'Choose one or more challenges to include in this bundle.',
              style: GoogleFonts.publicSans(
                  color: _cream.withValues(alpha: 0.5), fontSize: 12),
            ),
            SizedBox(height: 10),
            Consumer<ChallengeProvider>(
              builder: (context, cp, _) {
                final challenges = cp.discoverChallenges;
                if (challenges.isEmpty) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _purple.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: _purple.withValues(alpha: 0.2)),
                    ),
                    child: Center(
                      child: Text(
                        'No challenges available.',
                        style: GoogleFonts.publicSans(
                          color: _cream.withValues(alpha: 0.4),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: challenges.length,
                  separatorBuilder: (_, __) => SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final challenge = challenges[i];
                    final isSelected =
                        _selectedChallengeIds.contains(challenge.id);
                    final chipColor =
                        CategoryChip.colorForCategory(challenge.category);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedChallengeIds.remove(challenge.id);
                          } else {
                            _selectedChallengeIds.add(challenge.id);
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 180),
                        padding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _purple.withValues(alpha: 0.15)
                              : _purple.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? _purple.withValues(alpha: 0.8)
                                : _purple.withValues(alpha: 0.2),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.check_box_outlined
                                  : Icons.check_box_outline_blank,
                              color: isSelected
                                  ? _purple
                                  : _cream.withValues(alpha: 0.3),
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                challenge.title,
                                style: GoogleFonts.publicSans(
                                  color: isSelected
                                      ? _cream
                                      : _cream.withValues(alpha: 0.65),
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: chipColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color:
                                        chipColor.withValues(alpha: 0.4)),
                              ),
                              child: Text(
                                challenge.category,
                                style: GoogleFonts.publicSans(
                                  color: chipColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            SizedBox(height: 20),
            _Label('Daily Reminders (optional)'),
            SizedBox(height: 4),
            Text(
              'Pre-check reminds participants to start. Final-check is the deadline.',
              style: GoogleFonts.publicSans(
                  color: _cream.withValues(alpha: 0.5), fontSize: 12),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _TimePickerTile(
                    label: 'Pre-Check',
                    icon: Icons.alarm_outlined,
                    time: _preCheckTime,
                    onTap: () => _pickTime(isPre: true),
                    onClear: _preCheckTime == null
                        ? null
                        : () => setState(() => _preCheckTime = null),
                    color: _purple,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _TimePickerTile(
                    label: 'Final Check',
                    icon: Icons.alarm_on_outlined,
                    time: _finalCheckTime,
                    onTap: () => _pickTime(isPre: false),
                    onClear: _finalCheckTime == null
                        ? null
                        : () => setState(() => _finalCheckTime = null),
                    color: Colors.orange,
                  ),
                ),
              ],
            ),

            SizedBox(height: 36),
            ElevatedButton(
              onPressed: _isLoading ? null : _create,
              style: ElevatedButton.styleFrom(
                backgroundColor: _purple,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
                disabledBackgroundColor:
                    _purple.withValues(alpha: 0.5),
              ),
              child: _isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      'Create Bundle',
                      style: GoogleFonts.publicSans(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: GoogleFonts.publicSans(
          color: Color(0xffE4EBDE),
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      );
}

class _TimePickerTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final TimeOfDay? time;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final Color color;

  const _TimePickerTile({
    required this.label,
    required this.icon,
    required this.time,
    required this.onTap,
    required this.onClear,
    required this.color,
  });

  String get _timeStr => time == null
      ? 'Not set'
      : '${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    const cream = Color(0xffE4EBDE);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: color.withValues(alpha: time != null ? 0.5 : 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: GoogleFonts.publicSans(
                          color: cream.withValues(alpha: 0.5),
                          fontSize: 10,
                          fontWeight: FontWeight.w600)),
                  Text(_timeStr,
                      style: GoogleFonts.publicSans(
                          color: time != null
                              ? cream
                              : cream.withValues(alpha: 0.35),
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            if (onClear != null)
              GestureDetector(
                onTap: onClear,
                child: Icon(Icons.close,
                    color: cream.withValues(alpha: 0.4), size: 16),
              ),
          ],
        ),
      ),
    );
  }
}
