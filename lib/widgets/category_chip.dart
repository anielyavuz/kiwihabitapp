import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  static const _categories = {
    "All": Color(0xff6C3FC5),
    "Sport": Color(0xff1A6B3C),
    "Health": Color(0xff6B1A6B),
    "Study": Color(0xff1A3B6B),
    "Art": Color(0xff8B1A6B),
    "Finance": Color(0xff1A6B1A),
    "Social": Color(0xff6B4A1A),
    "Nutrition": Color(0xff6B3A1A),
    "Mindfulness": Color(0xff4B1A6B),
    "Language": Color(0xff1A5B6B),
    "Sleep": Color(0xff2B1A6B),
    "Productivity": Color(0xff4B3A1A),
  };

  static Color colorForCategory(String cat) {
    return _categories[cat] ?? const Color(0xff6C3FC5);
  }

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = colorForCategory(label);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.publicSans(
            color: isSelected ? Colors.white : color,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
