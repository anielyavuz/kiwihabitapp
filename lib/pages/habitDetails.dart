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
  bool _checkedBoxEveryday = true;
  bool _checkedBoxAlarm = true;
  Map habitsMap = {};
  int _index = 0;
  int _inADay = 1;
  late Box box;
  List _yourHabits = [];
  List _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  List<TimeOfDay> _allTimes = [
    TimeOfDay(hour: 12, minute: 30),
  ];

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
                flex: 7,
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
                                    // border: Border.all(
                                    //     color:
                                    //         Color.fromARGB(255, 212, 212, 212)),
                                    // color: Color(0xff1d3557),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Column(
                                  children: [
                                    Text(
                                      _yourHabits[index]['habitName'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Times New Roman',
                                        // fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Goal",
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: _yaziTipiRengi,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Times New Roman',
                                          // fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    Row(
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
                                                      ? Color(0xff996B3E)
                                                      : Color.fromARGB(
                                                          86, 153, 107, 62),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15.0))),
                                                  splashColor:
                                                      Color(0xff77A830),
                                                  textStyle: TextStyle(
                                                      color: Colors.white),
                                                  child: Text("-",
                                                      style: TextStyle(
                                                        color: _yaziTipiRengi,
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
                                                                  _inADay - 1;

                                                              _allTimes
                                                                  .removeLast();
                                                            });
                                                          }
                                                        }),
                                            ),
                                            Text(_inADay.toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25,
                                                  fontFamily: 'Times New Roman',
                                                  // fontWeight: FontWeight.bold
                                                )),
                                            SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: RawMaterialButton(
                                                  fillColor: Color(0xff996B3E),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15.0))),
                                                  splashColor:
                                                      Color(0xff77A830),
                                                  textStyle: TextStyle(
                                                      color: Colors.white),
                                                  child: Text("+",
                                                      style: TextStyle(
                                                        color: _yaziTipiRengi,
                                                        fontSize: 15,
                                                        fontFamily:
                                                            'Times New Roman',
                                                        // fontWeight: FontWeight.bold
                                                      )),
                                                  onPressed: () {
                                                    setState(() {
                                                      _inADay = _inADay + 1;

                                                      _allTimes.add(TimeOfDay(
                                                          hour:
                                                              12 + _inADay - 1,
                                                          minute: 30));
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
                                    ),
                                    Row(
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
                                    CheckboxListTile(
                                      side: BorderSide(
                                          color: Color(0xff996B3E), width: 1),
                                      activeColor: Color(0xff77A830),
                                      // tileColor: Color(0xff996B3E),
                                      checkColor: _yaziTipiRengi,
                                      contentPadding: EdgeInsets.zero,
                                      visualDensity:
                                          VisualDensity(horizontal: -4),
                                      dense: true,
                                      title: Text(
                                        "Everyday",
                                        style: TextStyle(
                                          color: _yaziTipiRengi,
                                          fontSize: 15,
                                          fontFamily: 'Times New Roman',
                                        ),
                                      ),
                                      value: _checkedBoxEveryday,
                                      onChanged: (val) {
                                        setState(() {
                                          _checkedBoxEveryday = val!;
                                        });
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                    ),
                                    CheckboxListTile(
                                      side: BorderSide(
                                          color: Color(0xff996B3E), width: 1),
                                      activeColor: Color(0xff77A830),
                                      // tileColor: Color(0xff996B3E),
                                      checkColor: _yaziTipiRengi,
                                      contentPadding: EdgeInsets.zero,
                                      visualDensity:
                                          VisualDensity(horizontal: -4),
                                      dense: true,
                                      title: Text(
                                        "Alarm",
                                        style: TextStyle(
                                          color: _yaziTipiRengi,
                                          fontSize: 15,
                                          fontFamily: 'Times New Roman',
                                        ),
                                      ),
                                      value: _checkedBoxAlarm,
                                      onChanged: (val) {
                                        setState(() {
                                          _checkedBoxAlarm = val!;
                                        });
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                    ),
                                    Container(
                                      height: 200,
                                      // width: 50,
                                      child: ListView.builder(
                                          itemCount: _allTimes.length,
                                          itemBuilder: (context, index) {
                                            // print(_kaydirmaNoktalari);
                                            return Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              child: RawMaterialButton(
                                                  fillColor: Colors.green,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      15.0))),
                                                  splashColor:
                                                      Color(0xff867ae9),
                                                  textStyle: TextStyle(
                                                      color: _yaziTipiRengi),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      TimeOfDay? newTime =
                                                          await showTimePicker(
                                                              context: context,
                                                              initialTime:
                                                                  _allTimes[
                                                                      index]);
                                                      if (newTime == null)
                                                        return;
                                                      else {
                                                        setState(() {
                                                          _allTimes[index] =
                                                              newTime;
                                                        });
                                                      }
                                                    },
                                                    child: Text(
                                                        _allTimes[index]
                                                                .hour
                                                                .toString() +
                                                            ":" +
                                                            _allTimes[index]
                                                                .minute
                                                                .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                _yaziTipiRengi,
                                                            fontSize: 35)),
                                                  ),
                                                  onPressed: () async {}),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ))),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "...",
                      style: TextStyle(color: _yaziTipiRengi, fontSize: 35),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HabitDetails()));

                            // Navigator.pushAndRemoveUntil(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (BuildContext context) =>
                            //             HabitDetails()),
                            //     (Route<dynamic> route) => false);
                          },
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border.all(color: _yaziTipiRengi),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Center(
                                  child: Text("Continue",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: _yaziTipiRengi,
                                        fontSize: 15,
                                        fontFamily: 'Times New Roman',
                                        // fontWeight: FontWeight.bold
                                      ))),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HabitDetails()));

                            // Navigator.pushAndRemoveUntil(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (BuildContext context) =>
                            //             HabitDetails()),
                            //     (Route<dynamic> route) => false);
                          },
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border.all(color: _yaziTipiRengi),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Center(
                                  child: Text("Continue",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: _yaziTipiRengi,
                                        fontSize: 15,
                                        fontFamily: 'Times New Roman',
                                        // fontWeight: FontWeight.bold
                                      ))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
