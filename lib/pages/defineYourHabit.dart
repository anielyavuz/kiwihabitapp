import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kiwihabitapp/pages/bePremiumUser.dart';
import 'package:kiwihabitapp/pages/chooseyourhabits.dart';
import 'package:kiwihabitapp/pages/habitDetails.dart';
import 'package:kiwihabitapp/widgets/textFieldDecoration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DefineYourHabit extends StatefulWidget {
  const DefineYourHabit({Key? key}) : super(key: key);

  @override
  State<DefineYourHabit> createState() => _DefineYourHabitState();
}

class _DefineYourHabitState extends State<DefineYourHabit> {
  late var _defineYourHabit =
      AppLocalizations.of(context)!.defineYourHabit.toString();

  late var _habitNameTextField =
      AppLocalizations.of(context)!.habitName.toString();
  late var _addToHabits = AppLocalizations.of(context)!.addToHabits.toString();
  late var _habitList = AppLocalizations.of(context)!.habitList.toString();
  late var _continueButton =
      AppLocalizations.of(context)!.continueButton.toString();

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

  late var _youShouldOneHabit =
      AppLocalizations.of(context)!.youShouldOneHabit.toString();

  var _habitName;
  late Box box;
  List _yourFinalHabits = [];
  late var _category = _healthLabel;
  List _YourHabits = [];

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
  var habitName;

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

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ChooseHabits()));

    // Navigator.pop(context);
    return true;
  }

  @override
  void initState() {
    super.initState();

    box = Hive.box("kiwiHive");
    getCurrentChooseYourHabits();
  }

  getCurrentChooseYourHabits() {
    _YourHabits = box.get("chooseYourHabitsHive") ?? [];
    // for (var item in _YourHabits) {
    //   setState(() {
    //     _chooseYourHabitsName.add(item['habitName']);
    //   });
    // }
    // print(_YourHabits);
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
                          _defineYourHabit,
                          style: GoogleFonts.publicSans(
                              fontWeight: FontWeight.w800,
                              fontSize: 25,
                              color: _yaziTipiRengi),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                              width: MediaQuery.of(context).size.width * 9 / 10,
                              child: TextFieldDecoration(
                                hintYazi: _habitNameTextField,
                                textfieldData: (newtextfieldData) {
                                  setState(() {
                                    _habitName = newtextfieldData;
                                  });
                                },
                              )),
                          Container(
                            width:
                                MediaQuery.of(context).size.width * 9 / 10 - 20,
                            padding: EdgeInsets.fromLTRB(15, 0, 20, 0),
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
                                            style: GoogleFonts.publicSans(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 18,
                                                color: _yaziTipiRengi),
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
                                                          color: Color.fromARGB(
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
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: RawMaterialButton(
                                fillColor:
                                    _habitName == null || _habitName == ""
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
                                      style: GoogleFonts.publicSans(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          color: Color.fromRGBO(21, 9, 35, 1))),
                                ),
                                onPressed: _habitName == null ||
                                        _habitName == ""
                                    ? null
                                    : () async {
                                        // if (_YourHabits.length < 5) {

                                        setState(() {
                                          var _habit = {};
                                          _habit['habitName'] = _habitName;
                                          _habit['habitCategory'] = _category;
                                          // print(_habitName);
                                          _YourHabits.add(_habit);
                                        });
                                        print(
                                            "DDDDDDDDDDDDDAAAAAAAAAAAAATTTTTTTTTTTTAAAAAAAAAAAAAAAAA1");

                                        box.put("chooseYourHabitsHive",
                                            _YourHabits);

                                        getCurrentChooseYourHabits();
                                        // }
                                        // else {
                                        //   ScaffoldMessenger.of(context)
                                        //       .hideCurrentSnackBar();
                                        //   ScaffoldMessenger.of(context)
                                        //       .showSnackBar(
                                        //     SnackBar(
                                        //         duration: Duration(
                                        //             milliseconds: 4000),
                                        //         content: Row(
                                        //           mainAxisAlignment:
                                        //               MainAxisAlignment.center,
                                        //           children: [
                                        //             Text('Habit limit reached'),
                                        //             Icon(
                                        //               Icons.error,
                                        //               color: Colors.yellow,
                                        //               size: 25,
                                        //             ),
                                        //           ],
                                        //         ),
                                        //         action: SnackBarAction(
                                        //           label: "Be a Premium User",
                                        //           onPressed: () {
                                        //             Navigator.push(
                                        //                 context,
                                        //                 MaterialPageRoute(
                                        //                     builder: (context) =>
                                        //                         BePremiumUser()));
                                        //           },
                                        //         )),
                                        //   );
                                        // }
                                      }),
                          ),
                        ],
                      )),
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        Container(
                            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _habitList,
                              style: GoogleFonts.publicSans(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                  color: _yaziTipiRengi),
                            )),
                        SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: _YourHabits.map((habit) {
                                return Container(
                                  // height: MediaQuery.of(context).size.height / 13,
                                  child: Card(
                                    color: _yaziTipiRengi,
                                    child: ListTile(
                                      isThreeLine: false,
                                      leading: habit['habitCategory'] ==
                                              _healthLabel
                                          ? Icon(
                                              Icons.volunteer_activism,
                                              size: 32,
                                              color: Color.fromARGB(
                                                  223, 232, 77, 77),
                                            )
                                          : habit['habitCategory'] ==
                                                  _sportLabel
                                              ? Icon(
                                                  Icons.directions_run,
                                                  size: 32,
                                                  color: Color.fromARGB(
                                                      223, 18, 218, 7),
                                                )
                                              : habit['habitCategory'] ==
                                                      _studyLabel
                                                  ? Icon(
                                                      Icons.school,
                                                      size: 32,
                                                      color: Color.fromARGB(
                                                          223, 124, 38, 223),
                                                    )
                                                  : habit['habitCategory'] ==
                                                          _artLabel
                                                      ? Icon(
                                                          Icons.palette,
                                                          size: 32,
                                                          color: Color.fromARGB(
                                                              223, 225, 5, 240),
                                                        )
                                                      : habit['habitCategory'] ==
                                                              _financeLabel
                                                          ? Icon(
                                                              Icons
                                                                  .attach_money,
                                                              size: 32,
                                                              color: Color
                                                                  .fromARGB(
                                                                      223,
                                                                      12,
                                                                      162,
                                                                      7),
                                                            )
                                                          : habit['habitCategory'] ==
                                                                  _socialLabel
                                                              ? Icon(
                                                                  Icons
                                                                      .nightlife,
                                                                  size: 32,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          223,
                                                                          232,
                                                                          118,
                                                                          18),
                                                                )
                                                              : Icon(
                                                                  Icons
                                                                      .smoke_free,
                                                                  size: 32,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          223,
                                                                          19,
                                                                          153,
                                                                          243),
                                                                ),
                                      dense: true,
                                      visualDensity:
                                          VisualDensity(vertical: -4),
                                      title: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 3),
                                          child: Text(
                                            habit['habitName'],
                                            style: GoogleFonts.publicSans(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                                color: Color.fromRGBO(
                                                    21, 9, 35, 1)),
                                          )),
                                      subtitle: Text(
                                        habit['habitCategory'],
                                        style: GoogleFonts.publicSans(
                                            fontWeight: FontWeight.w200,
                                            fontSize: 11,
                                            color:
                                                Color.fromRGBO(21, 9, 35, 1)),
                                      ),
                                      trailing: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.redAccent),
                                        child: Icon(Icons.delete),
                                        onPressed: () {
                                          setState(() {
                                            _YourHabits.removeWhere((element) =>
                                                element["habitName"] ==
                                                habit['habitName']);
                                          });
                                          print(
                                              "DDDDDDDDDDDDDAAAAAAAAAAAAATTTTTTTTTTTTAAAAAAAAAAAAAAAAA2");

                                          box.put("chooseYourHabitsHive",
                                              _YourHabits);

                                          getCurrentChooseYourHabits();
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            _yourFinalHabits =
                                box.get("chooseYourHabitsHive") ?? [];

                            if (_yourFinalHabits.length > 0) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HabitDetails()));
                            } else {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(milliseconds: 2000),
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(_youShouldOneHabit),
                                      Icon(
                                        Icons.error,
                                        color: Colors.yellow,
                                        size: 25,
                                      ),
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
                                  child: Text(_continueButton,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.publicSans(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          color: _yaziTipiRengi))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
