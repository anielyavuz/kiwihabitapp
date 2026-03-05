// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckInButton extends StatefulWidget {
  final bool alreadyCheckedIn;
  final Future<void> Function() onCheckIn;
  final Future<void> Function()? onUndo;

  const CheckInButton({
    Key? key,
    required this.alreadyCheckedIn,
    required this.onCheckIn,
    this.onUndo,
  }) : super(key: key);

  @override
  State<CheckInButton> createState() => _CheckInButtonState();
}

class _CheckInButtonState extends State<CheckInButton> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  bool _isUndoLoading = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _tap() async {
    if (widget.alreadyCheckedIn || _isLoading) return;
    setState(() => _isLoading = true);
    await widget.onCheckIn();
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _tapUndo() async {
    if (widget.onUndo == null || _isUndoLoading) return;
    setState(() => _isUndoLoading = true);
    await widget.onUndo!();
    if (mounted) setState(() => _isUndoLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 56,
        decoration: BoxDecoration(
          color: Color(0xff2D1B69),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))),
      );
    }

    if (widget.alreadyCheckedIn) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: Colors.green.shade800.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.shade600, width: 1),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade400, size: 22),
                  SizedBox(width: 10),
                  Text(
                    "Checked in today! ✓",
                    style: GoogleFonts.publicSans(
                      color: Colors.green.shade300,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.onUndo != null)
            _isUndoLoading
                ? Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white30,
                        strokeWidth: 1.5,
                      ),
                    ),
                  )
                : TextButton.icon(
                    onPressed: _tapUndo,
                    icon: Icon(Icons.undo, size: 14, color: Colors.white.withValues(alpha: 0.4)),
                    label: Text(
                      'Undo check-in',
                      style: GoogleFonts.publicSans(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 12,
                      ),
                    ),
                  ),
        ],
      );
    }

    return GestureDetector(
      onTap: _tap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff6C3FC5), Color(0xff9B6AE8)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Color(0xff6C3FC5).withOpacity(0.4), blurRadius: 12, offset: Offset(0, 4))],
        ),
        child: Center(
          child: Text(
            "Check In Today 🎯",
            style: GoogleFonts.publicSans(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
