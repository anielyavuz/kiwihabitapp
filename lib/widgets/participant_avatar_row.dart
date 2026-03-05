import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiwihabitapp/models/participant_model.dart';

class ParticipantAvatarRow extends StatelessWidget {
  final List<ParticipantModel> participants;
  final int maxShown;

  const ParticipantAvatarRow({
    Key? key,
    required this.participants,
    this.maxShown = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shown = participants.take(maxShown).toList();
    final overflow = participants.length - maxShown;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < shown.length; i++)
          Transform.translate(
            offset: Offset(-i * 10.0, 0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xff6C3FC5),
              backgroundImage: shown[i].photoUrl.isNotEmpty
                  ? NetworkImage(shown[i].photoUrl)
                  : null,
              child: shown[i].photoUrl.isEmpty
                  ? Text(
                      shown[i].userName.isNotEmpty
                          ? shown[i].userName[0].toUpperCase()
                          : '?',
                      style: GoogleFonts.publicSans(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : null,
            ),
          ),
        if (overflow > 0)
          Transform.translate(
            offset: Offset(-shown.length * 10.0, 0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xff2D1B69),
              child: Text(
                '+$overflow',
                style: GoogleFonts.publicSans(
                  color: const Color(0xffE4EBDE),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
