import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kiwihabitapp/auth/authFunctions.dart';
import 'package:kiwihabitapp/auth/authentication.dart';
import 'package:lottie/lottie.dart';

class HabitDetails extends StatefulWidget {
  const HabitDetails({Key? key}) : super(key: key);
  @override
  State<HabitDetails> createState() => _HabitDetailsState();
}

class _HabitDetailsState extends State<HabitDetails> {
  @override
  final Color _yaziTipiRengi = Color(0xffE4EBDE);
  bool _loadingIcon = false;
  AuthService _authService = AuthService();
  bool _checkedBoxEveryday = true;
  bool _checkedBoxAlarm = true;
  Map habitsMap = {};
  int _index = 0;
  int _inADay = 1;
  late Box box;
  List _yourHabits = [];
  int _pageNumber = 0;
  PageController _pageController =
      PageController(viewportFraction: 1, initialPage: 0);

  List _weekDays = [
    {'day': 'Mon', 'value': true},
    {'day': 'Tue', 'value': true},
    {'day': 'Wed', 'value': true},
    {'day': 'Thu', 'value': true},
    {'day': 'Fri', 'value': true},
    {'day': 'Sat', 'value': true},
    {'day': 'Sun', 'value': true},
  ];

  List _allTimes = [
    {
      "time": TimeOfDay(hour: 12, minute: 30),
      "notification": true,
      "alarm": false
    }
  ];

  TextEditingController _activityCount = TextEditingController();

  getCurrentChooseYourHabits() {
    _yourHabits = box.get("chooseYourHabitsHive") ?? [];

    // for (var item in _YourHabits) {
    //   setState(() {
    //     _chooseYourHabitsName.add(item['habitName']);
    //   });
    // }
    for (var _yourHabit in _yourHabits) {
      setState(() {
        _yourHabit['_weekDays'] = [
          {
            'day': DateTime(2000, 1, 3)
                .difference(DateTime(2000, 1, 3))
                .inDays
                .toString(),
            'value': true
          },
          {
            'day': DateTime(2000, 1, 4)
                .difference(DateTime(2000, 1, 3))
                .inDays
                .toString(),
            'value': true
          },
          {
            'day': DateTime(2000, 1, 5)
                .difference(DateTime(2000, 1, 3))
                .inDays
                .toString(),
            'value': true
          },
          {
            'day': DateTime(2000, 1, 6)
                .difference(DateTime(2000, 1, 3))
                .inDays
                .toString(),
            'value': true
          },
          {
            'day': DateTime(2000, 1, 7)
                .difference(DateTime(2000, 1, 3))
                .inDays
                .toString(),
            'value': true
          },
          {
            'day': DateTime(2000, 1, 8)
                .difference(DateTime(2000, 1, 3))
                .inDays
                .toString(),
            'value': true
          },
          {
            'day': DateTime(2000, 1, 9)
                .difference(DateTime(2000, 1, 3))
                .inDays
                .toString(),
            'value': true
          },
        ];
        _yourHabit['_allTimes'] = [
          {
            "time": TimeOfDay(hour: 12, minute: 30),
            "notification": true,
            "alarm": false
          },
        ];
        _yourHabit['_checkedBoxEveryday'] = true;
      });
    }

    print(_yourHabits);
  }

  writeHabitsFinaltoDB() {
    Map _habitDetails = {};
    Map _habitDays = {};

    for (var _habit in _yourHabits.toList()) {
      _habitDetails[_habit['habitName']] = {};
      _habitDetails[_habit['habitName']]['habitCategory'] =
          _habit['habitCategory'];

      _habitDetails[_habit['habitName']]['_allTimes'] = _habit['_allTimes'];

      _habitDays[_habit['habitName']] = [];
      for (var _weekDay in _habit['_weekDays']) {
        if (_weekDay['value'] == true) {
          _habitDays[_habit['habitName']].add(_weekDay['day']);
        }
      }
    }

    box.put("habitDetailsHive", _habitDetails);
    box.put("habitDays", _habitDays);
    print(_habitDays);
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
                    controller: _pageController,
                    onPageChanged: (int index) => setState(() {
                          _index = index;
                          _pageNumber = index;
                        }),
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
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 25),
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
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Goal",
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: _yaziTipiRengi,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Times New Roman',
                                            // fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 10),
                                      child: Row(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                  0,
                                                  0,
                                                  4,
                                                  0,
                                                ),
                                                child: SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child: RawMaterialButton(
                                                      fillColor: _yourHabits[index]['_allTimes']
                                                                  .length >
                                                              1
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
                                                            color:
                                                                _yaziTipiRengi,
                                                            fontSize: 15,
                                                            fontFamily:
                                                                'Times New Roman',
                                                            // fontWeight: FontWeight.bold
                                                          )),
                                                      onPressed: _yourHabits[index]
                                                                      ['_allTimes']
                                                                  .length <=
                                                              1
                                                          ? null
                                                          : () {
                                                              if (_yourHabits[index]
                                                                          [
                                                                          '_allTimes']
                                                                      .length >
                                                                  1) {
                                                                setState(() {
                                                                  _inADay =
                                                                      _inADay -
                                                                          1;

                                                                  _yourHabits[index]
                                                                          [
                                                                          '_allTimes']
                                                                      .removeLast();
                                                                });
                                                              }
                                                            }),
                                                ),
                                              ),
                                              Container(
                                                // width: 20,
                                                padding: EdgeInsets.fromLTRB(
                                                    5, 0, 5, 0),
                                                decoration: BoxDecoration(
                                                    // color: Color(0xff77A830),
                                                    // border: Border.all(
                                                    //     color:
                                                    //         Color(0xff77A830)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Text(
                                                    _yourHabits[index]
                                                            ['_allTimes']
                                                        .length
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: _yaziTipiRengi,
                                                      fontSize: 25,
                                                      fontFamily:
                                                          'Times New Roman',
                                                      // fontWeight: FontWeight.bold
                                                    )),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                  4,
                                                  0,
                                                  0,
                                                  0,
                                                ),
                                                child: SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child: RawMaterialButton(
                                                      fillColor:
                                                          Color(0xff996B3E),
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
                                                            color:
                                                                _yaziTipiRengi,
                                                            fontSize: 15,
                                                            fontFamily:
                                                                'Times New Roman',
                                                            // fontWeight: FontWeight.bold
                                                          )),
                                                      onPressed: () {
                                                        setState(() {
                                                          _inADay = _inADay + 1;

                                                          _yourHabits[index]
                                                                  ['_allTimes']
                                                              .add({
                                                            "time": TimeOfDay(
                                                                hour: _inADay <
                                                                        12
                                                                    ? 12 +
                                                                        _inADay -
                                                                        1
                                                                    : (12 +
                                                                            _inADay -
                                                                            1) %
                                                                        24,
                                                                minute: 30),
                                                            "notification":
                                                                true,
                                                            "alarm": false
                                                          });
                                                        });
                                                      }),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text("in a day",
                                              style: TextStyle(
                                                color: _yaziTipiRengi,
                                                fontSize: 15,
                                                fontFamily: 'Times New Roman',
                                                // fontWeight: FontWeight.bold
                                              ))
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: _yourHabits[index]['_weekDays']
                                          .map<Widget>((day) {
                                        return Container(
                                          padding:
                                              EdgeInsets.fromLTRB(3, 0, 3, 0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              9,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              11,
                                          child: RawMaterialButton(
                                              fillColor: day['value']
                                                  ? Colors.green
                                                  : _yaziTipiRengi,
                                              shape: const RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 134, 85, 36),
                                                      width: 3),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(8.0))),
                                              splashColor: Colors.green,
                                              textStyle: TextStyle(
                                                  color: _yaziTipiRengi),
                                              child: Text(
                                                  DateFormat('E').format(
                                                      DateTime(2000, 1, 3).add(
                                                          Duration(
                                                              days: int.parse(day['day'])))),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        21, 9, 35, 1),
                                                    fontSize: 12,
                                                    fontFamily:
                                                        'Times New Roman',
                                                    // fontWeight: FontWeight.bold
                                                  )),
                                              onPressed: () async {
                                                int _daySelected = 0;
                                                for (var _weekDay
                                                    in _yourHabits[index]
                                                        ['_weekDays']) {
                                                  if (_weekDay['value']) {
                                                    _daySelected += 1;
                                                  }
                                                }
                                                if (_daySelected > 1) {
                                                  bool _allDaysSelected = true;
                                                  setState(() {
                                                    day['value'] =
                                                        !day['value'];
                                                  });
                                                  for (var _weekDay
                                                      in _yourHabits[index]
                                                          ['_weekDays']) {
                                                    if (!_weekDay['value']) {
                                                      _allDaysSelected = false;
                                                    }
                                                  }
                                                  if (_allDaysSelected) {
                                                    // _checkedBoxEveryday = true;
                                                    _yourHabits[index][
                                                            '_checkedBoxEveryday'] =
                                                        true;
                                                  } else {
                                                    _yourHabits[index][
                                                            '_checkedBoxEveryday'] =
                                                        false;
                                                    // _checkedBoxEveryday = false;
                                                  }
                                                } else {
                                                  if (!day['value'] == true) {
                                                    bool _allDaysSelected =
                                                        true;
                                                    setState(() {
                                                      day['value'] =
                                                          !day['value'];
                                                    });
                                                    for (var _weekDay
                                                        in _yourHabits[index]
                                                            ['_weekDays']) {
                                                      if (!_weekDay['value']) {
                                                        _allDaysSelected =
                                                            false;
                                                      }
                                                    }
                                                    if (_allDaysSelected) {
                                                      _yourHabits[index][
                                                              '_checkedBoxEveryday'] =
                                                          true;
                                                      // _checkedBoxEveryday =
                                                      //     true;
                                                    } else {
                                                      _yourHabits[index][
                                                              '_checkedBoxEveryday'] =
                                                          false;
                                                      // _checkedBoxEveryday =
                                                      //     false;
                                                    }
                                                  }
                                                }

                                                // print("-------------");
                                                // print(_yourHabits);
                                              }),
                                        );
                                      }).toList(),
                                    ),
                                    Theme(
                                      data: ThemeData(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                      ),
                                      child: CheckboxListTile(
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
                                        value: _yourHabits[index]
                                            ['_checkedBoxEveryday'],
                                        onChanged: (val) {
                                          if (!_yourHabits[index]
                                              ['_checkedBoxEveryday']) {
                                            setState(() {
                                              _yourHabits[index]
                                                      ['_checkedBoxEveryday'] =
                                                  true;
                                              for (var day in _yourHabits[index]
                                                  ['_weekDays']) {
                                                day['value'] = true;
                                              }
                                            });
                                          }
                                        },
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                      ),
                                    ),
                                    // CheckboxListTile(
                                    //   side: BorderSide(
                                    //       color: Color(0xff996B3E), width: 1),
                                    //   activeColor: Color(0xff77A830),
                                    //   // tileColor: Color(0xff996B3E),
                                    //   checkColor: _yaziTipiRengi,
                                    //   contentPadding: EdgeInsets.zero,
                                    //   visualDensity:
                                    //       VisualDensity(horizontal: -4),
                                    //   dense: true,
                                    //   title: Text(
                                    //     "Alarm",
                                    //     style: TextStyle(
                                    //       color: _yaziTipiRengi,
                                    //       fontSize: 15,
                                    //       fontFamily: 'Times New Roman',
                                    //     ),
                                    //   ),
                                    //   value: _checkedBoxAlarm,
                                    //   onChanged: (val) {
                                    //     setState(() {
                                    //       _checkedBoxAlarm = val!;
                                    //     });
                                    //   },
                                    //   controlAffinity:
                                    //       ListTileControlAffinity.leading,
                                    // ),
                                    Expanded(
                                      child: Container(
                                        // width:
                                        //     MediaQuery.of(context).size.width *
                                        //         3 /
                                        //         5,
                                        height: 200,
                                        // width: 50,

                                        child: ListView.builder(
                                            itemCount: _yourHabits[index]
                                                    ['_allTimes']
                                                .length,
                                            itemBuilder: (context, index2) {
                                              // print(_kaydirmaNoktalari);
                                              return Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                child: RawMaterialButton(
                                                    // fillColor: _yaziTipiRengi,
                                                    shape: RoundedRectangleBorder(
                                                        side: BorderSide(
                                                            color:
                                                                _yaziTipiRengi),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15.0))),
                                                    // splashColor: Colors.green,
                                                    textStyle: TextStyle(
                                                        color: _yaziTipiRengi),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          15, 5, 15, 5),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              "Goal " +
                                                                  (index2 + 1)
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  color:
                                                                      _yaziTipiRengi,
                                                                  fontSize:
                                                                      15)),
                                                          Row(
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    _yourHabits[index]['_allTimes']
                                                                            [
                                                                            index2]
                                                                        [
                                                                        'alarm'] = !_yourHabits[index]['_allTimes']
                                                                            [
                                                                            index2]
                                                                        [
                                                                        'alarm'];
                                                                  });

                                                                  if (_yourHabits[index]
                                                                              [
                                                                              '_allTimes']
                                                                          [
                                                                          index2]
                                                                      [
                                                                      'alarm']) {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                        duration:
                                                                            Duration(milliseconds: 2000),
                                                                        content:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text('Alarm enabled for ' +
                                                                                "Goal " +
                                                                                (index2 + 1).toString()),
                                                                          ],
                                                                        ),
                                                                        // action: SnackBarAction(
                                                                        //   label: "Be a Premium User",
                                                                        //   onPressed: () {
                                                                        //     Navigator.push(
                                                                        //         context,
                                                                        //         MaterialPageRoute(
                                                                        //             builder: (context) =>
                                                                        //                 BePremiumUser()));
                                                                        //   },
                                                                        // )
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                        duration:
                                                                            Duration(milliseconds: 2000),
                                                                        content:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text('Alarm disabled for ' +
                                                                                "Goal " +
                                                                                (index2 + 1).toString()),
                                                                          ],
                                                                        ),
                                                                        // action: SnackBarAction(
                                                                        //   label: "Be a Premium User",
                                                                        //   onPressed: () {
                                                                        //     Navigator.push(
                                                                        //         context,
                                                                        //         MaterialPageRoute(
                                                                        //             builder: (context) =>
                                                                        //                 BePremiumUser()));
                                                                        //   },
                                                                        // )
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                                child: Icon(
                                                                  _yourHabits[index]['_allTimes']
                                                                              [
                                                                              index2]
                                                                          [
                                                                          'alarm']
                                                                      ? Icons
                                                                          .alarm_on
                                                                      : Icons
                                                                          .alarm_off,
                                                                  size: 25,
                                                                  color: _yourHabits[index]['_allTimes']
                                                                              [
                                                                              index2]
                                                                          [
                                                                          'alarm']
                                                                      ? Color(
                                                                          0xff77A830)
                                                                      : _yaziTipiRengi,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    _yourHabits[index]['_allTimes']
                                                                            [
                                                                            index2]
                                                                        [
                                                                        'notification'] = !_yourHabits[index]['_allTimes']
                                                                            [
                                                                            index2]
                                                                        [
                                                                        'notification'];
                                                                  });

                                                                  if (_yourHabits[index]
                                                                              [
                                                                              '_allTimes']
                                                                          [
                                                                          index2]
                                                                      [
                                                                      'notification']) {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                        duration:
                                                                            Duration(milliseconds: 2000),
                                                                        content:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text('Notification enabled for ' +
                                                                                "Goal " +
                                                                                (index2 + 1).toString()),
                                                                          ],
                                                                        ),
                                                                        // action: SnackBarAction(
                                                                        //   label: "Be a Premium User",
                                                                        //   onPressed: () {
                                                                        //     Navigator.push(
                                                                        //         context,
                                                                        //         MaterialPageRoute(
                                                                        //             builder: (context) =>
                                                                        //                 BePremiumUser()));
                                                                        //   },
                                                                        // )
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                        duration:
                                                                            Duration(milliseconds: 2000),
                                                                        content:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text('Notification disabled for ' +
                                                                                "Goal " +
                                                                                (index2 + 1).toString()),
                                                                          ],
                                                                        ),
                                                                        // action: SnackBarAction(
                                                                        //   label: "Be a Premium User",
                                                                        //   onPressed: () {
                                                                        //     Navigator.push(
                                                                        //         context,
                                                                        //         MaterialPageRoute(
                                                                        //             builder: (context) =>
                                                                        //                 BePremiumUser()));
                                                                        //   },
                                                                        // )
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                                child: Icon(
                                                                  _yourHabits[index]['_allTimes']
                                                                              [
                                                                              index2]
                                                                          [
                                                                          'notification']
                                                                      ? Icons
                                                                          .notifications_active
                                                                      : Icons
                                                                          .notifications_off,
                                                                  size: 25,
                                                                  color: _yourHabits[index]['_allTimes']
                                                                              [
                                                                              index2]
                                                                          [
                                                                          'notification']
                                                                      ? Color(
                                                                          0xff77A830)
                                                                      : _yaziTipiRengi,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  TimeOfDay?
                                                                      newTime =
                                                                      await showTimePicker(
                                                                          context:
                                                                              context,
                                                                          initialTime:
                                                                              _yourHabits[index]['_allTimes'][index2]['time']);
                                                                  if (newTime ==
                                                                      null)
                                                                    return;
                                                                  else {
                                                                    setState(
                                                                        () {
                                                                      _yourHabits[index]['_allTimes'][index2]
                                                                              [
                                                                              'time'] =
                                                                          newTime;
                                                                    });
                                                                  }
                                                                },
                                                                child: _yourHabits[index]['_allTimes'][index2]['time']
                                                                            .minute
                                                                            .toString() !=
                                                                        "0"
                                                                    ? Text(
                                                                        _yourHabits[index]['_allTimes'][index2]['time'].hour.toString() +
                                                                            ":" +
                                                                            _yourHabits[index]['_allTimes'][index2]['time']
                                                                                .minute
                                                                                .toString(),
                                                                        style: TextStyle(
                                                                            color:
                                                                                _yaziTipiRengi,
                                                                            fontSize:
                                                                                25))
                                                                    : Text(_yourHabits[index]['_allTimes'][index2]['time'].hour.toString() + ":00",
                                                                        style: TextStyle(
                                                                            color: _yaziTipiRengi,
                                                                            fontSize: 25)),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    onPressed: null),
                                              );
                                            }),
                                      ),
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
                    Wrap(
                        direction: Axis.horizontal,
                        children: List.generate(_yourHabits.length, (index3) {
                          return Text(
                            ".",
                            style: TextStyle(
                                color: index3 == _pageNumber
                                    ? Colors.green
                                    : _yaziTipiRengi,
                                fontSize: index3 == _pageNumber ? 65 : 55),
                          );
                        })),
                    Row(
                      mainAxisAlignment: _pageNumber == 0
                          ? MainAxisAlignment.center
                          : _pageNumber == _yourHabits.length - 1
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.spaceEvenly,
                      children: [
                        Visibility(
                          visible: _yourHabits.length == 1
                              ? false
                              : _pageNumber == 0
                                  ? false
                                  : _pageNumber == _yourHabits.length - 1
                                      ? false
                                      : true,
                          child: InkWell(
                            onTap: () async {
                              _pageController.previousPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInCirc);

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => HabitDetails()));

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
                                width: MediaQuery.of(context).size.width / 3,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border: Border.all(color: _yaziTipiRengi),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Center(
                                    child: Text("Previous",
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
                        ),
                        Visibility(
                          visible: _pageNumber == _yourHabits.length - 1
                              ? false
                              : true,
                          child: InkWell(
                            onTap: () async {
                              _pageController.nextPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInCirc);

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => HabitDetails()));

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
                                width: MediaQuery.of(context).size.width / 3,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border: Border.all(color: _yaziTipiRengi),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Center(
                                    child: Text("Next",
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
                        ),
                      ],
                    ),
                    Visibility(
                      visible:
                          _pageNumber == _yourHabits.length - 1 ? true : false,
                      child: Row(
                        mainAxisAlignment: _yourHabits.length == 1
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceEvenly,
                        children: [
                          Visibility(
                            visible: _yourHabits.length == 1 ? false : true,
                            child: InkWell(
                              onTap: () async {
                                _pageController.previousPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInCirc);

                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => HabitDetails()));

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
                                  width: MediaQuery.of(context).size.width / 3,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: _yaziTipiRengi),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                      child: Text("Previous",
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
                          ),
                          InkWell(
                            onTap: () async {
                              // print(_yourHabits);

                              // List _tempHabits = List.from(_yourHabits);
                              List _tempHabits = _yourHabits.toList();
                              for (var _yourHabits in _tempHabits) {
                                for (var _yourHabitsTime
                                    in _yourHabits['_allTimes']) {
                                  _yourHabitsTime['time'] =
                                      _yourHabitsTime['time'].toString();
                                }
                              }

                              writeHabitsFinaltoDB();
                              print(_tempHabits);
                              print("Sayfa değiştir....");
                              setState(() {
                                _loadingIcon = true;
                              });
                              var a = await _authService.anonymSignIn();

                              setState(() {
                                _loadingIcon = false;
                              });

                              box.put("chooseYourHabitsHive", _tempHabits);

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          CheckAuth()),
                                  (Route<dynamic> route) => false);
                            },
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Container(
                                width: MediaQuery.of(context).size.width / 3,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border: Border.all(color: _yaziTipiRengi),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Center(
                                    child: Text("Finish",
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
          ),
          Visibility(
            visible: _loadingIcon,
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: Container(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                Center(
                  child: Container(
                    child: Lottie.asset(
                        // "https://assets5.lottiefiles.com/private_files/lf30_ijwulw45.json"
                        "assets/json/loading.json"),
                  ),
                )
              ],
            ),
          ),
        ])));
  }
}
