import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kiwihabitapp/pages/bePremiumUser.dart';

class HabitGroup extends StatefulWidget {
  final Color
      yaziTipiRengi; //Note: statefull'a parametre göndermek için gerekli
  final String butonYazi;
  final String butonCategory;
  const HabitGroup(
      {Key? key,
      required this.yaziTipiRengi,
      required this.butonYazi,
      required this.butonCategory})
      : super(key: key);
  @override
  State<HabitGroup> createState() => _HabitGroupState();
}

class _HabitGroupState extends State<HabitGroup> {
  late Box box;
  late List _chooseYourHabits = [];
  late List _chooseYourHabitsName = [];
  @override
  getCurrentChooseYourHabits() {
    _chooseYourHabitsName = [];
    _chooseYourHabits = box.get("chooseYourHabitsHive") ?? [];
    for (var item in _chooseYourHabits) {
      setState(() {
        _chooseYourHabitsName.add(item['habitName']);
      });
    }
    print(_chooseYourHabitsName);
  }

  @override
  void initState() {
    super.initState();

    box = Hive.box("kiwiHive");
    getCurrentChooseYourHabits();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // _kelimeleriCek();
  }

  bool _selected = false;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        fillColor: !_chooseYourHabitsName.contains(widget.butonYazi)
            ? widget.yaziTipiRengi
            : Colors.green,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        splashColor: Color(0xff867ae9),
        textStyle: TextStyle(color: widget.yaziTipiRengi),
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Text(widget.butonYazi,
              textAlign: TextAlign.center,
              style: GoogleFonts.publicSans(
                  fontSize: 15, color: Color.fromRGBO(21, 9, 35, 1))),
        ),
        onPressed: () async {
          setState(() {
            if (!_chooseYourHabitsName.contains(widget.butonYazi)) {
              if (_chooseYourHabits.length < 5) {
                var _habit = {};
                _habit['habitName'] = widget.butonYazi;
                _habit['habitCategory'] = widget.butonCategory;
                _chooseYourHabits.add(_habit);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      duration: Duration(milliseconds: 4000),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Habit limit reached'),
                          Icon(
                            Icons.error,
                            color: Colors.yellow,
                            size: 25,
                          ),
                        ],
                      ),
                      action: SnackBarAction(
                        label: "Be a Premium User",
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BePremiumUser()));
                        },
                      )),
                );
              }
            } else {
              setState(() {
                var _habit = {};
                _habit['habitName'] = widget.butonYazi;
                _habit['habitCategory'] = widget.butonCategory;
                // _chooseYourHabits.remove(_habit);
                _chooseYourHabits.removeWhere(
                    (element) => element["habitName"] == widget.butonYazi);
              });
            }
          });

          box.put("chooseYourHabitsHive", _chooseYourHabits);
          getCurrentChooseYourHabits();
        });
  }
}
