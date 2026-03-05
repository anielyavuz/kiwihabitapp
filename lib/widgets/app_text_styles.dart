import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static const _cream = Color(0xffE4EBDE);

  static TextStyle headingLarge({Color? color}) => GoogleFonts.publicSans(
    color: color ?? _cream,
    fontSize: 26,
    fontWeight: FontWeight.w800,
  );

  static TextStyle headingMedium({Color? color}) => GoogleFonts.publicSans(
    color: color ?? _cream,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static TextStyle headingSmall({Color? color}) => GoogleFonts.publicSans(
    color: color ?? _cream,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static TextStyle bodyText({Color? color}) => GoogleFonts.publicSans(
    color: color ?? _cream,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle caption({Color? color}) => GoogleFonts.publicSans(
    color: color ?? _cream.withValues(alpha: 0.6),
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static TextStyle label({Color? color}) => GoogleFonts.publicSans(
    color: color ?? _cream,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
}
