import 'package:flutter/material.dart';
import 'package:kiwihabitapp/widgets/habitGroup.dart';

class HabitGroup2 extends StatefulWidget {
  final List habitList;
  final Color yaziTipiRengi;
  final String butonCategory;
  const HabitGroup2(
      {Key? key,
      required this.habitList,
      required this.yaziTipiRengi,
      required this.butonCategory})
      : super(key: key);

  @override
  State<HabitGroup2> createState() => _HabitGroup2State();
}

class _HabitGroup2State extends State<HabitGroup2> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: HabitGroup(
                butonYazi: widget.habitList[0],
                yaziTipiRengi: widget.yaziTipiRengi,
                butonCategory: widget.butonCategory,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: HabitGroup(
                  butonYazi: widget.habitList[1],
                  yaziTipiRengi: widget.yaziTipiRengi,
                  butonCategory: widget.butonCategory,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: HabitGroup(
                  butonYazi: widget.habitList[2],
                  yaziTipiRengi: widget.yaziTipiRengi,
                  butonCategory: widget.butonCategory,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: HabitGroup(
                  butonYazi: widget.habitList[3],
                  yaziTipiRengi: widget.yaziTipiRengi,
                  butonCategory: widget.butonCategory,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
