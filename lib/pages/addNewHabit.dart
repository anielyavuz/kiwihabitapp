import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kiwihabitapp/auth/authentication.dart';
import 'package:kiwihabitapp/pages/bePremiumUser.dart';
import 'package:kiwihabitapp/pages/chooseyourhabits.dart';
import 'package:kiwihabitapp/pages/habitDetails.dart';
import 'package:kiwihabitapp/widgets/textFieldDecoration.dart';

class AddNewHabit extends StatefulWidget {
  const AddNewHabit({Key? key}) : super(key: key);

  @override
  State<AddNewHabit> createState() => _AddNewHabitState();
}

class _AddNewHabitState extends State<AddNewHabit> {
  bool _slidingCheckBoxEveryDay = true;
  List _slidingYourHabitAlltimes = [
    {
      'time': TimeOfDay(hour: 12, minute: 30).toString(),
      'notification': true,
      'alarm': false
    }
  ];
  List _slidingItemWeekDaysList = [
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
  int _slidingCountADay = 1;
  String _slidingIconName = "Yoga";
  Icon _slidingIcon = Icon(
    Icons.volunteer_activism,
    size: 25,
    color: Color.fromARGB(223, 218, 21, 7),
  );

  var _habitName;
  late Box box;
  List _yourFinalHabits = [];
  var _category = "Health";
  List _yourHabits = [];
  List _allDefaultHabits = [
    "Yoga",
    "Meditation",
    "Drink Water",
    "Sleep Well",
    "Walk",
    "Push Up",
    "Run",
    "Swim",
    "Read a book",
    "Learn English",
    "Math Exercise",
    "Law",
    "Play Guitar",
    "Painting",
    "Play Piano",
    "Dance",
    "Saving Money",
    "Investing",
    "Donation",
    "Market Search",
    "Cinema",
    "Meet with friends",
    "Theater",
    "Listen Podcast",
    "Quit smoking",
    "Quit eating snacks",
    "Quit alcohol",
    "Stop swearing"
  ];
  final Color _yaziTipiRengi = Color(0xffE4EBDE);
  TextEditingController _turkceTextFieldController = TextEditingController();
  var _habitDetails;
  var habitName;
  var _habitDays;
  addNewHabit() {
    Map _editedHabitAdd = {};
    _editedHabitAdd['habitName'] = _turkceTextFieldController.text;
    _editedHabitAdd['habitCategory'] = _category;
    _editedHabitAdd['_weekDays'] = _slidingItemWeekDaysList;
    _editedHabitAdd['_allTimes'] = _slidingYourHabitAlltimes;
    _editedHabitAdd['_checkedBoxEveryday'] = _slidingCheckBoxEveryDay;
    // print(_editedHabitAdd);

    _yourHabits.add(_editedHabitAdd);

    //////////////////
    ///

    _habitDetails[_turkceTextFieldController.text] = {};
    _habitDetails[_turkceTextFieldController.text]['habitCategory'] = _category;
    _habitDetails[_turkceTextFieldController.text]['_allTimes'] =
        _slidingYourHabitAlltimes;

    ////////////////
    ///

    List _tempListe = [];
    for (var _slidingItemWeekDaysListItem in _slidingItemWeekDaysList) {
      if (_slidingItemWeekDaysListItem['value']) {
        _tempListe.add(_slidingItemWeekDaysListItem['day'].toString());
      }
    }
    _habitDays[_turkceTextFieldController.text] = _tempListe;
    print("1");
    box.put("chooseYourHabitsHive", _yourHabits);
    print("2");
    box.put("habitDetailsHive", _habitDetails);
    print("3");
    box.put("habitDays", _habitDays);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => CheckAuth()),
        (Route<dynamic> route) => false);
  }

  Future<bool> _onBackPressed() async {
    // List _tempList = [];
    // for (var habit in _YourHabits) {
    //   print(habit["habitName"]);
    //   if (!_allDefaultHabits.contains(habit["habitName"]))
    //     setState(() {
    //       _tempList.add(habit['habitName']);
    //     });
    // }

    // for (var item in _tempList) {
    //   _YourHabits.removeWhere((element) => element["habitName"] == item);
    // }
    // box.put("chooseYourHabitsHive", _YourHabits);

    // getCurrentChooseYourHabits();

    Navigator.pop(context);

    // Navigator.pop(context);
    return true;
  }

  @override
  void initState() {
    super.initState();

    box = Hive.box("kiwiHive");
    getCurrentChooseYourHabits();
  }

  getCurrentChooseYourHabits() async {
    _yourHabits = box.get("chooseYourHabitsHive") ?? [];
    _habitDetails = await box.get("habitDetailsHive") ?? [];
    _habitDays = await box.get("habitDays") ?? [];

    // for (var item in _yourHabits) {
    //   setState(() {
    //     _chooseYourHabitsName.add(item['habitName']);
    //   });
    // }
    // print(_yourHabits);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromRGBO(21, 9, 35, 1),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Center(
                        child: Text(
                          "Add New Habit",
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                            // width: MediaQuery.of(context).size.width * 9 / 10,
                            child: TextField(
                              onChanged: (value2) {},
                              controller: _turkceTextFieldController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                isCollapsed: true,
                                filled: true,
                                fillColor: _yaziTipiRengi,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.green,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.purple,
                                    width: 2.0,
                                  ),
                                ),
                                hintText: "Habit Name",
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(75, 21, 9, 35)),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(21, 9, 35, 1),
                              border: Border.all(color: _yaziTipiRengi),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                  borderRadius: BorderRadius.circular(20),
                                  isExpanded: true,
                                  dropdownColor:
                                      Color.fromARGB(255, 46, 10, 87),
                                  value: _category,
                                  items: <String>[
                                    'Health',
                                    'Sport',
                                    'Study',
                                    'Art',
                                    'Finance',
                                    'Social',
                                    'Quit a Bad Habit',
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Row(
                                        children: [
                                          new Text(
                                            value,
                                            style: TextStyle(
                                                color: _yaziTipiRengi,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          value == 'Health'
                                              ? Icon(
                                                  Icons.volunteer_activism,
                                                  size: 25,
                                                  color: Color.fromARGB(
                                                      223, 218, 21, 7),
                                                )
                                              : value == 'Sport'
                                                  ? Icon(
                                                      Icons.directions_run,
                                                      size: 25,
                                                      color: Color.fromARGB(
                                                          223, 18, 218, 7),
                                                    )
                                                  : value == 'Study'
                                                      ? Icon(
                                                          Icons.school,
                                                          size: 25,
                                                          color: Color.fromARGB(
                                                              223,
                                                              124,
                                                              38,
                                                              223),
                                                        )
                                                      : value == 'Art'
                                                          ? Icon(
                                                              Icons.palette,
                                                              size: 25,
                                                              color: Color
                                                                  .fromARGB(
                                                                      223,
                                                                      225,
                                                                      5,
                                                                      240),
                                                            )
                                                          : value == 'Finance'
                                                              ? Icon(
                                                                  Icons
                                                                      .attach_money,
                                                                  size: 25,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          223,
                                                                          12,
                                                                          162,
                                                                          7),
                                                                )
                                                              : value ==
                                                                      'Social'
                                                                  ? Icon(
                                                                      Icons
                                                                          .nightlife,
                                                                      size: 25,
                                                                      color: Color.fromARGB(
                                                                          223,
                                                                          232,
                                                                          118,
                                                                          18),
                                                                    )
                                                                  : Icon(
                                                                      Icons
                                                                          .smoke_free,
                                                                      size: 25,
                                                                      color: Color.fromARGB(
                                                                          223,
                                                                          19,
                                                                          153,
                                                                          243),
                                                                    )
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _category = value!;
                                    });
                                  }),
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: Row(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              0,
                                              0,
                                              4,
                                              0,
                                            ),
                                            child: SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: RawMaterialButton(
                                                  fillColor:
                                                      _slidingCountADay > 1
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
                                                  onPressed:
                                                      _slidingCountADay <= 1
                                                          ? null
                                                          : () {
                                                              if (_slidingCountADay >
                                                                  1) {
                                                                setState(() {
                                                                  _slidingCountADay--;

                                                                  _slidingYourHabitAlltimes
                                                                      .removeLast();
                                                                });
                                                              }
                                                            }),
                                            ),
                                          ),
                                          Container(
                                            // width: 20,
                                            padding:
                                                EdgeInsets.fromLTRB(5, 0, 5, 0),
                                            decoration: BoxDecoration(
                                                // color: Color(0xff77A830),
                                                // border: Border.all(
                                                //     color:
                                                //         Color(0xff77A830)),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Text(
                                                _slidingCountADay.toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: _yaziTipiRengi,
                                                  fontSize: 25,
                                                  fontFamily: 'Times New Roman',
                                                  // fontWeight: FontWeight.bold
                                                )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              4,
                                              0,
                                              0,
                                              0,
                                            ),
                                            child: SizedBox(
                                              height: 20,
                                              width: 20,
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
                                                      _slidingCountADay++;

                                                      _slidingYourHabitAlltimes
                                                          .add({
                                                        "time": TimeOfDay(
                                                                hour: _slidingCountADay <
                                                                        12
                                                                    ? 12 +
                                                                        _slidingCountADay -
                                                                        1
                                                                    : (12 +
                                                                            _slidingCountADay -
                                                                            1) %
                                                                        24,
                                                                minute: 30)
                                                            .toString(),
                                                        "notification": true,
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
                                  children: _slidingItemWeekDaysList
                                      .map<Widget>((day) {
                                    return Container(
                                      padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                                      width:
                                          MediaQuery.of(context).size.width / 9,
                                      height:
                                          MediaQuery.of(context).size.width /
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
                                          textStyle:
                                              TextStyle(color: _yaziTipiRengi),
                                          child: Text(
                                              DateFormat('E').format(
                                                  DateTime(2000, 1, 3).add(
                                                      Duration(
                                                          days: int.parse(
                                                              day['day'])))),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    21, 9, 35, 1),
                                                fontSize: 12,
                                                fontFamily: 'Times New Roman',
                                                // fontWeight: FontWeight.bold
                                              )),
                                          onPressed: () async {
                                            int _daySelected = 0;
                                            for (var _weekDay
                                                in _slidingItemWeekDaysList) {
                                              if (_weekDay['value']) {
                                                _daySelected += 1;
                                              }
                                            }
                                            if (_daySelected > 1) {
                                              bool _allDaysSelected = true;
                                              setState(() {
                                                day['value'] = !day['value'];
                                              });
                                              for (var _weekDay
                                                  in _slidingItemWeekDaysList) {
                                                if (!_weekDay['value']) {
                                                  _allDaysSelected = false;
                                                }
                                              }
                                              if (_allDaysSelected) {
                                                // _checkedBoxEveryday = true;
                                                _slidingCheckBoxEveryDay = true;
                                              } else {
                                                _slidingCheckBoxEveryDay =
                                                    false;
                                                // _checkedBoxEveryday = false;
                                              }
                                            } else {
                                              if (!day['value'] == true) {
                                                bool _allDaysSelected = true;
                                                setState(() {
                                                  day['value'] = !day['value'];
                                                });
                                                for (var _weekDay
                                                    in _slidingItemWeekDaysList) {
                                                  if (!_weekDay['value']) {
                                                    _allDaysSelected = false;
                                                  }
                                                }
                                                if (_allDaysSelected) {
                                                  _slidingCheckBoxEveryDay =
                                                      true;
                                                  // _checkedBoxEveryday =
                                                  //     true;
                                                } else {
                                                  _slidingCheckBoxEveryDay =
                                                      false;
                                                  // _checkedBoxEveryday =
                                                  //     false;
                                                }
                                              }
                                            }
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
                                    value: _slidingCheckBoxEveryDay,
                                    onChanged: (val) {
                                      if (!_slidingCheckBoxEveryDay) {
                                        setState(() {
                                          _slidingCheckBoxEveryDay = true;
                                          for (var day
                                              in _slidingItemWeekDaysList) {
                                            setState(() {
                                              day['value'] = true;
                                            });
                                          }
                                        });
                                      }
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                  ),
                                ),
                              ],
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
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Container(
                                // width:
                                //     MediaQuery.of(context).size.width *
                                //         3 /
                                //         5,
                                height: 200,
                                // width: 50,

                                child: ListView.builder(
                                    itemCount: _slidingYourHabitAlltimes.length,
                                    itemBuilder: (context, index2) {
                                      // print(_kaydirmaNoktalari);
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        child: RawMaterialButton(
                                            // fillColor: _yaziTipiRengi,
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: _yaziTipiRengi),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15.0))),
                                            // splashColor: Colors.green,
                                            textStyle: TextStyle(
                                                color: _yaziTipiRengi),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
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
                                                          color: _yaziTipiRengi,
                                                          fontSize: 15)),
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            _slidingYourHabitAlltimes[
                                                                        index2]
                                                                    ['alarm'] =
                                                                !_slidingYourHabitAlltimes[
                                                                        index2]
                                                                    ['alarm'];
                                                          });

                                                          if (_slidingYourHabitAlltimes[
                                                                  index2]
                                                              ['alarm']) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        2000),
                                                                content: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text('Alarm enabled for ' +
                                                                        "Goal " +
                                                                        (index2 +
                                                                                1)
                                                                            .toString()),
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
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        2000),
                                                                content: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text('Alarm disabled for ' +
                                                                        "Goal " +
                                                                        (index2 +
                                                                                1)
                                                                            .toString()),
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
                                                          _slidingYourHabitAlltimes[
                                                                      index2]
                                                                  ['alarm']
                                                              ? Icons.alarm_on
                                                              : Icons.alarm_off,
                                                          size: 25,
                                                          color: _slidingYourHabitAlltimes[
                                                                      index2]
                                                                  ['alarm']
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
                                                            _slidingYourHabitAlltimes[
                                                                        index2][
                                                                    'notification'] =
                                                                !_slidingYourHabitAlltimes[
                                                                        index2][
                                                                    'notification'];
                                                          });

                                                          if (_slidingYourHabitAlltimes[
                                                                  index2][
                                                              'notification']) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        2000),
                                                                content: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text('Notification enabled for ' +
                                                                        "Goal " +
                                                                        (index2 +
                                                                                1)
                                                                            .toString()),
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
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        2000),
                                                                content: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text('Notification disabled for ' +
                                                                        "Goal " +
                                                                        (index2 +
                                                                                1)
                                                                            .toString()),
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
                                                          _slidingYourHabitAlltimes[
                                                                      index2][
                                                                  'notification']
                                                              ? Icons
                                                                  .notifications_active
                                                              : Icons
                                                                  .notifications_off,
                                                          size: 25,
                                                          color: _slidingYourHabitAlltimes[
                                                                      index2][
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
                                                        onTap: () async {
                                                          TimeOfDay? newTime = await showTimePicker(
                                                              context: context,
                                                              initialTime: TimeOfDay(
                                                                  hour: int.parse(_slidingYourHabitAlltimes[index2]['time']
                                                                          .toString()
                                                                          .split("(")[
                                                                              1]
                                                                          .split(")")[
                                                                              0]
                                                                          .split(":")[
                                                                      0]),
                                                                  minute: int.parse(_slidingYourHabitAlltimes[index2]
                                                                          ['time']
                                                                      .toString()
                                                                      .split("(")[1]
                                                                      .split(")")[0]
                                                                      .split(":")[1])));
                                                          if (newTime == null)
                                                            return;
                                                          else {
                                                            if (newTime.minute <
                                                                10) {
                                                              newTime = TimeOfDay(
                                                                  hour: newTime
                                                                      .hour,
                                                                  minute: int.parse("0" +
                                                                      newTime
                                                                          .minute
                                                                          .toString()));
                                                              print(newTime);
                                                            }

                                                            setState(() {
                                                              _slidingYourHabitAlltimes[
                                                                          index2]
                                                                      ['time'] =
                                                                  newTime
                                                                      .toString();
                                                            });
                                                          }
                                                        },
                                                        child: Text(
                                                            _slidingYourHabitAlltimes[
                                                                            index2]
                                                                        ['time']
                                                                    .toString()
                                                                    .split(
                                                                        "(")[1]
                                                                    .split(
                                                                        ")")[0]
                                                                    .split(
                                                                        ":")[0]
                                                                    .toString() +
                                                                ":" +
                                                                _slidingYourHabitAlltimes[
                                                                            index2]
                                                                        ['time']
                                                                    .toString()
                                                                    .split(
                                                                        "(")[1]
                                                                    .split(
                                                                        ")")[0]
                                                                    .split(
                                                                        ":")[1]
                                                                    .toString(),
                                                            style: TextStyle(
                                                                color:
                                                                    _yaziTipiRengi,
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
                          ),

                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: RawMaterialButton(
                                fillColor:
                                    _turkceTextFieldController.text == null || _turkceTextFieldController.text == ""
                                        ? _yaziTipiRengi.withOpacity(0.2)
                                        : _yaziTipiRengi,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                                splashColor: Color(0xff867ae9),
                                textStyle: TextStyle(color: _yaziTipiRengi),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                  child: Text("Add to habits",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color.fromRGBO(21, 9, 35, 1),
                                        fontSize: 15,
                                        fontFamily: 'Times New Roman',
                                        // fontWeight: FontWeight.bold
                                      )),
                                ),
                                onPressed:
                                    _turkceTextFieldController.text == null || _turkceTextFieldController.text == ""
                                        ? null
                                        : () async {
                                            addNewHabit();
                                          }),
                          ),
                        ],
                      )),
                ],
              ),
              Positioned(
                left: 5,
                child: Container(
                  height: 40,
                  child: IconButton(
                      onPressed: () async {
                        _onBackPressed();
                        // List _tempList = [];
                        // for (var habit in _YourHabits) {
                        //   print(habit["habitName"]);
                        //   if (!_allDefaultHabits.contains(habit["habitName"]))
                        //     setState(() {
                        //       _tempList.add(habit['habitName']);
                        //     });
                        // }

                        // for (var item in _tempList) {
                        //   _YourHabits.removeWhere(
                        //       (element) => element["habitName"] == item);
                        // }
                        // box.put("chooseYourHabitsHive", _YourHabits);

                        // getCurrentChooseYourHabits();

                        // // Navigator.pop(context);

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => ChooseHabits()));
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 25,
                        color: Colors.white,
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
