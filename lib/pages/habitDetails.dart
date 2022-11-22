import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HabitDetails extends StatefulWidget {
  const HabitDetails({Key? key}) : super(key: key);
  @override
  State<HabitDetails> createState() => _HabitDetailsState();
}

class _HabitDetailsState extends State<HabitDetails> {
  @override
  final Color _yaziTipiRengi = Color(0xffE4EBDE);
  Map habitsMap = {};
  int _index = 0;
  int _inADay = 1;
  late Box box;
  List _yourHabits = [];
  List _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  TextEditingController _activityCount = TextEditingController();
  getCurrentChooseYourHabits() {
    _yourHabits = box.get("chooseYourHabitsHive") ?? [];
    // for (var item in _YourHabits) {
    //   setState(() {
    //     _chooseYourHabitsName.add(item['habitName']);
    //   });
    // }
    print(_yourHabits);
  }

  @override
  void initState() {
    super.initState();

    box = Hive.box("kiwiHive");
    getCurrentChooseYourHabits();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(21, 9, 35, 1),
        body: SafeArea(
            child: Stack(children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: Center(
                    child: Text(
                      "Habit Details",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Times New Roman',
                        // fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: PageView(
                    controller:
                        PageController(viewportFraction: 1, initialPage: 0),
                    onPageChanged: (int index) =>
                        setState(() => _index = index),
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                        _yourHabits.length,
                        (index) => Padding(
                              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                            Color.fromARGB(255, 212, 212, 212)),
                                    // color: Color(0xff1d3557),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        _yourHabits[index]['habitName'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Times New Roman',
                                          // fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: Row(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SizedBox(
                                                  height: 25,
                                                  width: 25,
                                                  child: RawMaterialButton(
                                                      fillColor: _inADay > 1
                                                          ? Color(0xff542e71)
                                                          : Color.fromARGB(
                                                              255, 89, 89, 89),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      15.0))),
                                                      splashColor:
                                                          Color(0xff867ae9),
                                                      textStyle: TextStyle(
                                                          color: Colors.white),
                                                      child: Text("-",
                                                          style: TextStyle(
                                                            color:
                                                                _yaziTipiRengi,
                                                            fontSize: 15,
                                                            fontFamily:
                                                                'Times New Roman',
                                                            // fontWeight: FontWeight.bold
                                                          )),
                                                      onPressed: _inADay <= 1
                                                          ? null
                                                          : () {
                                                              if (_inADay > 1) {
                                                                setState(() {
                                                                  _inADay =
                                                                      _inADay -
                                                                          1;
                                                                });
                                                              }
                                                            }),
                                                ),
                                                Text(_inADay.toString(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25,
                                                      fontFamily:
                                                          'Times New Roman',
                                                      // fontWeight: FontWeight.bold
                                                    )),
                                                SizedBox(
                                                  height: 25,
                                                  width: 25,
                                                  child: RawMaterialButton(
                                                      fillColor:
                                                          Color(0xff542e71),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      15.0))),
                                                      splashColor:
                                                          Color(0xff867ae9),
                                                      textStyle: TextStyle(
                                                          color: Colors.white),
                                                      child: Text("+",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontFamily:
                                                                'Times New Roman',
                                                            // fontWeight: FontWeight.bold
                                                          )),
                                                      onPressed: () {
                                                        setState(() {
                                                          _inADay = _inADay + 1;
                                                        });
                                                      }),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            Text("in a day",
                                                style: TextStyle(
                                                  color: _yaziTipiRengi,
                                                  fontSize: 25,
                                                  fontFamily: 'Times New Roman',
                                                  // fontWeight: FontWeight.bold
                                                ))
                                          ],
                                        )),
                                    Expanded(
                                      child: Row(
                                        children: _weekDays.map((day) {
                                          return Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                9,
                                            child: RawMaterialButton(
                                                fillColor: Colors.green,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15.0))),
                                                splashColor: Color(0xff867ae9),
                                                textStyle: TextStyle(
                                                    color: _yaziTipiRengi),
                                                child: Text(day,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          21, 9, 35, 1),
                                                      fontSize: 15,
                                                      fontFamily:
                                                          'Times New Roman',
                                                      // fontWeight: FontWeight.bold
                                                    )),
                                                onPressed: () async {}),
                                          );
                                        }).toList(),
                                      ),
                                      flex: 2,
                                    )
                                  ],
                                ),
                              ),
                            ))),
              )
            ],
          ),
          Positioned(
            left: 5,
            child: Container(
              height: 40,
              child: IconButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 25,
                    color: Colors.white,
                  )),
            ),
          )
        ])));
  }
}
