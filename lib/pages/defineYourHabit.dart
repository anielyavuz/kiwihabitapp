import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kiwihabitapp/pages/bePremiumUser.dart';
import 'package:kiwihabitapp/pages/chooseyourhabits.dart';
import 'package:kiwihabitapp/pages/habitDetails.dart';
import 'package:kiwihabitapp/widgets/textFieldDecoration.dart';

class DefineYourHabit extends StatefulWidget {
  const DefineYourHabit({Key? key}) : super(key: key);

  @override
  State<DefineYourHabit> createState() => _DefineYourHabitState();
}

class _DefineYourHabitState extends State<DefineYourHabit> {
  var _habitName;
  late Box box;
  List _yourFinalHabits = [];
  var _category = "Health";
  List _YourHabits = [];
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
                          "Define Your Habits",
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
                                hintYazi: "Habit Name",
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
                                            style: GoogleFonts.publicSans(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 18,
                                                color: _yaziTipiRengi),
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
                                  child: Text("Add to habits",
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
                              "Habit List",
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
                                              'Health'
                                          ? Icon(
                                              Icons.volunteer_activism,
                                              size: 32,
                                              color: Color.fromARGB(
                                                  223, 232, 77, 77),
                                            )
                                          : habit['habitCategory'] == 'Sport'
                                              ? Icon(
                                                  Icons.directions_run,
                                                  size: 32,
                                                  color: Color.fromARGB(
                                                      223, 18, 218, 7),
                                                )
                                              : habit['habitCategory'] ==
                                                      'Study'
                                                  ? Icon(
                                                      Icons.school,
                                                      size: 32,
                                                      color: Color.fromARGB(
                                                          223, 124, 38, 223),
                                                    )
                                                  : habit['habitCategory'] ==
                                                          'Art'
                                                      ? Icon(
                                                          Icons.palette,
                                                          size: 32,
                                                          color: Color.fromARGB(
                                                              223, 225, 5, 240),
                                                        )
                                                      : habit['habitCategory'] ==
                                                              'Finance'
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
                                                                  'Social'
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
                                      Text(
                                          'You should have at least one habit '),
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
                                  child: Text("Continue",
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
