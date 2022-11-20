import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kiwihabitapp/pages/bePremiumUser.dart';

class HabitGroup extends StatefulWidget {
  final Color
      yaziTipiRengi; //Note: statefull'a parametre göndermek için gerekli
  final String butonYazi;
  const HabitGroup(
      {Key? key, required this.yaziTipiRengi, required this.butonYazi})
      : super(key: key);
  @override
  State<HabitGroup> createState() => _HabitGroupState();
}

class _HabitGroupState extends State<HabitGroup> {
  late Box box;
  @override
  late List _chooseYourHabits;

  getCurrentChooseYourHabits() {
    _chooseYourHabits = box.get("chooseYourHabitsHive") ?? [];
  }

  void initState() {
    super.initState();

    box = Hive.box("kiwiHive");
    getCurrentChooseYourHabits();
  }

  bool _selected = false;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        fillColor: !_chooseYourHabits.contains(widget.butonYazi)
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
              style: TextStyle(
                color: Color.fromRGBO(21, 9, 35, 1),
                fontSize: 15,
                fontFamily: 'Times New Roman',
                // fontWeight: FontWeight.bold
              )),
        ),
        onPressed: () async {
          setState(() {
            if (!_chooseYourHabits.contains(widget.butonYazi)) {
              if (_chooseYourHabits.length < 5) {
                _chooseYourHabits.add(widget.butonYazi);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      duration: Duration(days: 4000),
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
              _chooseYourHabits.remove(widget.butonYazi);
            }
          });

          box.put("chooseYourHabitsHive", _chooseYourHabits);
          getCurrentChooseYourHabits();
        });
  }
}
