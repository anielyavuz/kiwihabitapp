import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kiwihabitapp/auth/authentication.dart';
import 'package:kiwihabitapp/pages/bePremiumUser.dart';
import 'package:kiwihabitapp/pages/chooseyourhabits.dart';
import 'package:kiwihabitapp/pages/habitDetails.dart';
import 'package:kiwihabitapp/services/dailyLogs.dart';
import 'package:kiwihabitapp/widgets/textFieldDecoration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddNewHabit extends StatefulWidget {
  final Map userInfo;
  const AddNewHabit({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<AddNewHabit> createState() => _AddNewHabitState();
}

class _AddNewHabitState extends State<AddNewHabit> {
  late var _goalText = AppLocalizations.of(context)!.goalText.toString();

  late var _inADayText = AppLocalizations.of(context)!.inADay.toString();

  late var _everyDay = AppLocalizations.of(context)!.everyDay.toString();
  late var _habitNameTextField =
      AppLocalizations.of(context)!.habitName.toString();
  late var _addToHabits = AppLocalizations.of(context)!.addToHabits.toString();
  late var _addNewHabit = AppLocalizations.of(context)!.addNewHabit.toString();
  String _textBoxInput = "";
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

  ///
  late var _healthLabel = AppLocalizations.of(context)!.healthLabel.toString();
  late var _sportLabel = AppLocalizations.of(context)!.sportLabel.toString();
  late var _studyLabel = AppLocalizations.of(context)!.studyLabel.toString();
  late var _artLabel = AppLocalizations.of(context)!.artLabel.toString();

  late var _financeLabel =
      AppLocalizations.of(context)!.financeLabel.toString();
  late var _socialLabel = AppLocalizations.of(context)!.socialLabel.toString();
  late var _quitABadHabitLabel =
      AppLocalizations.of(context)!.quitABadHabitLabel.toString();

  ///
  ///
//////
  ///
  ///
  ///
  late var _category = _healthLabel;
  List _yourHabits = [];

  ///
  late var _yoga = AppLocalizations.of(context)!.yoga.toString();

  late var _meditation = AppLocalizations.of(context)!.meditation.toString();
  late var _drinkWater = AppLocalizations.of(context)!.drinkWater.toString();
  late var _sleepWell = AppLocalizations.of(context)!.sleepWell.toString();
  late var _walk = AppLocalizations.of(context)!.walk.toString();
  late var _pushUp = AppLocalizations.of(context)!.pushUp.toString();
  late var _run = AppLocalizations.of(context)!.run.toString();
  late var _swim = AppLocalizations.of(context)!.swim.toString();
  late var _readABook = AppLocalizations.of(context)!.readABook.toString();
  late var _learnEnglish =
      AppLocalizations.of(context)!.learnEnglish.toString();
  late var _mathExercise =
      AppLocalizations.of(context)!.mathExercise.toString();
  late var _repeatToday = AppLocalizations.of(context)!.repeatToday.toString();
  late var _playGuitar = AppLocalizations.of(context)!.playGuitar.toString();
  late var _painting = AppLocalizations.of(context)!.painting.toString();
  late var _playPiano = AppLocalizations.of(context)!.playPiano.toString();
  late var _dance = AppLocalizations.of(context)!.dance.toString();
  late var _savingMoney = AppLocalizations.of(context)!.savingMoney.toString();
  late var _checkStocks = AppLocalizations.of(context)!.checkStocks.toString();
  late var _donate = AppLocalizations.of(context)!.donate.toString();
  late var _checkCurrencies =
      AppLocalizations.of(context)!.checkCurrencies.toString();
  late var _cinema = AppLocalizations.of(context)!.cinema.toString();
  late var _meetWithFriends =
      AppLocalizations.of(context)!.meetWithFriends.toString();
  late var _theater = AppLocalizations.of(context)!.theater.toString();
  late var _playGames = AppLocalizations.of(context)!.playGames.toString();
  late var _quitSmoking = AppLocalizations.of(context)!.quitSmoking.toString();
  late var _quitEatingSnacks =
      AppLocalizations.of(context)!.quitEatingSnacks.toString();
  late var _quitAlcohol = AppLocalizations.of(context)!.quitAlcohol.toString();
  late var _stopSwearing =
      AppLocalizations.of(context)!.stopSwearing.toString();

  ///

  late List _allDefaultHabits = [
    _yoga,
    _meditation,
    _drinkWater,
    _sleepWell,
    _walk,
    _pushUp,
    _run,
    _swim,
    _readABook,
    _learnEnglish,
    _mathExercise,
    _repeatToday,
    _playGuitar,
    _painting,
    _playPiano,
    _dance,
    _savingMoney,
    _checkStocks,
    _donate,
    _checkCurrencies,
    _cinema,
    _meetWithFriends,
    _theater,
    _playGames,
    _quitSmoking,
    _quitEatingSnacks,
    _quitAlcohol,
    _stopSwearing
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
    dailyLogs("New Habit Created");

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => CheckAuth()),
        (Route<dynamic> route) => false);
  }

  dailyLogs(String _log) {
    // Future.delayed(const Duration(milliseconds: 2000), () {
    //   DailyLogs()
    //       .writeLog(widget.userInfo['id'], widget.userInfo['userName'], _log);
    // });
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
                          _addNewHabit,
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
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(40),
                              ],
                              autofocus: true,
                              onChanged: (value2) {
                                setState(() {
                                  _textBoxInput = value2;
                                });
                              },
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
                                hintText: _habitNameTextField,
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(75, 21, 9, 35)),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(21, 9, 35, 1),
                              border: Border.all(color: _yaziTipiRengi),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 20, 0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                    borderRadius: BorderRadius.circular(20),
                                    isExpanded: true,
                                    dropdownColor:
                                        Color.fromARGB(255, 46, 10, 87),
                                    value: _category,
                                    items: <String>[
                                      _healthLabel,
                                      _sportLabel,
                                      _studyLabel,
                                      _artLabel,
                                      _financeLabel,
                                      _socialLabel,
                                      _quitABadHabitLabel,
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
                                            value == _healthLabel
                                                ? Icon(
                                                    Icons.volunteer_activism,
                                                    size: 25,
                                                    color: Color.fromARGB(
                                                        223, 218, 21, 7),
                                                  )
                                                : value == _sportLabel
                                                    ? Icon(
                                                        Icons.directions_run,
                                                        size: 25,
                                                        color: Color.fromARGB(
                                                            223, 18, 218, 7),
                                                      )
                                                    : value == _studyLabel
                                                        ? Icon(
                                                            Icons.school,
                                                            size: 25,
                                                            color:
                                                                Color.fromARGB(
                                                                    223,
                                                                    124,
                                                                    38,
                                                                    223),
                                                          )
                                                        : value == _artLabel
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
                                                            : value ==
                                                                    _financeLabel
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
                                                                        _socialLabel
                                                                    ? Icon(
                                                                        Icons
                                                                            .nightlife,
                                                                        size:
                                                                            25,
                                                                        color: Color.fromARGB(
                                                                            223,
                                                                            232,
                                                                            118,
                                                                            18),
                                                                      )
                                                                    : Icon(
                                                                        Icons
                                                                            .smoke_free,
                                                                        size:
                                                                            25,
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
                                      Text(_inADayText,
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
                                              DateFormat(
                                                      'E',
                                                      Localizations.localeOf(context)
                                                          .toString())
                                                  .format(DateTime(2000, 1, 3).add(
                                                      Duration(days: int.parse(day['day'])))),
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
                                      _everyDay,
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
                                                      _goalText +
                                                          " " +
                                                          (index2 + 1)
                                                              .toString(),
                                                      style: TextStyle(
                                                          color: _yaziTipiRengi,
                                                          fontSize: 15)),
                                                  Row(
                                                    children: [
                                                      // InkWell(
                                                      //   onTap: () {
                                                      //     setState(() {
                                                      //       _slidingYourHabitAlltimes[
                                                      //                   index2]
                                                      //               ['alarm'] =
                                                      //           !_slidingYourHabitAlltimes[
                                                      //                   index2]
                                                      //               ['alarm'];
                                                      //     });

                                                      //     if (_slidingYourHabitAlltimes[
                                                      //             index2]
                                                      //         ['alarm']) {
                                                      //       ScaffoldMessenger
                                                      //               .of(context)
                                                      //           .hideCurrentSnackBar();
                                                      //       ScaffoldMessenger
                                                      //               .of(context)
                                                      //           .showSnackBar(
                                                      //         SnackBar(
                                                      //           duration: Duration(
                                                      //               milliseconds:
                                                      //                   2000),
                                                      //           content: Row(
                                                      //             mainAxisAlignment:
                                                      //                 MainAxisAlignment
                                                      //                     .center,
                                                      //             children: [
                                                      //               Text('Alarm enabled for ' +
                                                      //                   "Goal " +
                                                      //                   (index2 +
                                                      //                           1)
                                                      //                       .toString()),
                                                      //             ],
                                                      //           ),
                                                      //           // action: SnackBarAction(
                                                      //           //   label: "Be a Premium User",
                                                      //           //   onPressed: () {
                                                      //           //     Navigator.push(
                                                      //           //         context,
                                                      //           //         MaterialPageRoute(
                                                      //           //             builder: (context) =>
                                                      //           //                 BePremiumUser()));
                                                      //           //   },
                                                      //           // )
                                                      //         ),
                                                      //       );
                                                      //     } else {
                                                      //       ScaffoldMessenger
                                                      //               .of(context)
                                                      //           .hideCurrentSnackBar();
                                                      //       ScaffoldMessenger
                                                      //               .of(context)
                                                      //           .showSnackBar(
                                                      //         SnackBar(
                                                      //           duration: Duration(
                                                      //               milliseconds:
                                                      //                   2000),
                                                      //           content: Row(
                                                      //             mainAxisAlignment:
                                                      //                 MainAxisAlignment
                                                      //                     .center,
                                                      //             children: [
                                                      //               Text('Alarm disabled for ' +
                                                      //                   "Goal " +
                                                      //                   (index2 +
                                                      //                           1)
                                                      //                       .toString()),
                                                      //             ],
                                                      //           ),
                                                      //           // action: SnackBarAction(
                                                      //           //   label: "Be a Premium User",
                                                      //           //   onPressed: () {
                                                      //           //     Navigator.push(
                                                      //           //         context,
                                                      //           //         MaterialPageRoute(
                                                      //           //             builder: (context) =>
                                                      //           //                 BePremiumUser()));
                                                      //           //   },
                                                      //           // )
                                                      //         ),
                                                      //       );
                                                      //     }
                                                      //   },
                                                      //   child:

                                                      //   Icon(
                                                      //     _slidingYourHabitAlltimes[
                                                      //                 index2]
                                                      //             ['alarm']
                                                      //         ? Icons.alarm_on
                                                      //         : Icons.alarm_off,
                                                      //     size: 25,
                                                      //     color: _slidingYourHabitAlltimes[
                                                      //                 index2]
                                                      //             ['alarm']
                                                      //         ? Color(
                                                      //             0xff77A830)
                                                      //         : _yaziTipiRengi,
                                                      //   ),
                                                      // ),
                                                      // SizedBox(
                                                      //   width: 15,
                                                      // ),

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
                                                                .hideCurrentSnackBar();
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
                                                                .hideCurrentSnackBar();
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
                                                          TimeOfDay? newTime =
                                                              await showTimePicker(
                                                            context: context,
                                                            initialTime: TimeOfDay(
                                                                hour: int.parse(_slidingYourHabitAlltimes[index2]
                                                                            ['time']
                                                                        .toString()
                                                                        .split(
                                                                            "(")[1]
                                                                        .split(
                                                                            ")")[0]
                                                                        .split(
                                                                            ":")[
                                                                    0]),
                                                                minute: int.parse(_slidingYourHabitAlltimes[
                                                                            index2]
                                                                        ['time']
                                                                    .toString()
                                                                    .split("(")[1]
                                                                    .split(")")[0]
                                                                    .split(":")[1])),
                                                            builder: (context,
                                                                child) {
                                                              return MediaQuery(
                                                                data: MediaQuery.of(
                                                                        context)
                                                                    .copyWith(
                                                                        alwaysUse24HourFormat:
                                                                            true),
                                                                child: child ??
                                                                    Container(),
                                                              );
                                                            },
                                                          );
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
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 30),
                            child: RawMaterialButton(
                                fillColor:
                                    _textBoxInput == null || _textBoxInput == ""
                                        ? _yaziTipiRengi.withOpacity(0.2)
                                        : _yaziTipiRengi,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                                splashColor: Color(0xff867ae9),
                                textStyle: TextStyle(color: _yaziTipiRengi),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                  child: Text(_addToHabits,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color.fromRGBO(21, 9, 35, 1),
                                        fontSize: 15,
                                        fontFamily: 'Times New Roman',
                                        // fontWeight: FontWeight.bold
                                      )),
                                ),
                                onPressed:
                                    _textBoxInput == null || _textBoxInput == ""
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
