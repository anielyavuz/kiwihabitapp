import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kiwihabitapp/auth/authFunctions.dart';
import 'package:kiwihabitapp/auth/authentication.dart';
import 'package:kiwihabitapp/pages/defineYourHabit.dart';
import 'package:kiwihabitapp/pages/habitDetails.dart';
import 'package:kiwihabitapp/pages/intro.dart';
import 'package:kiwihabitapp/widgets/habitGroup.dart';
import 'package:kiwihabitapp/widgets/habitGroup2.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChooseHabits extends StatefulWidget {
  const ChooseHabits({Key? key}) : super(key: key);

  @override
  State<ChooseHabits> createState() => _ChooseHabitsState();
}

class _ChooseHabitsState extends State<ChooseHabits> {
//   ,"chooseYourHabits":"Habitlerinizi Seçin"
// ,"continue":"Devam et"
// ,"or":"Veya"
// ,"defineYourHabit":"Habitlerinizi Seçin"
  late var _chooseYourHabits =
      AppLocalizations.of(context)!.chooseYourHabits.toString();
  late var _continueButton =
      AppLocalizations.of(context)!.continueButton.toString();
  late var _orButton = AppLocalizations.of(context)!.orButton.toString();
  late var _defineYourHabit =
      AppLocalizations.of(context)!.defineYourHabit.toString();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Color _yaziTipiRengi = Color(0xffE4EBDE);
  AuthService _authService = AuthService();
  late Box box;
  List _yourHabits = [];
  @override
  void initState() {
    super.initState();

    box = Hive.box("kiwiHive");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Scaffold.of(context).hideCurrentSnackBar();
      },
      child: Scaffold(
          backgroundColor: Color.fromRGBO(21, 9, 35, 1),
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          _chooseYourHabits,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.publicSans(
                              fontSize: 25, color: _yaziTipiRengi),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  // color: Colors.red.shade100,
                                  child: ExpandableNotifier(
                                      initialExpanded: true,
                                      child: ScrollOnExpand(
                                          child: ExpandablePanel(
                                        header: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 5, 0, 0),
                                          child: Row(
                                            children: [
                                              Text("Health",
                                                  textAlign: TextAlign.start,
                                                  style: GoogleFonts.publicSans(
                                                      fontSize: 25,
                                                      color: _yaziTipiRengi)),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 0, 0, 0),
                                                child: Icon(
                                                  Icons.volunteer_activism,
                                                  size: 25,
                                                  color: Color.fromARGB(
                                                      223, 218, 21, 7),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        theme: ExpandableThemeData(
                                          iconColor: Colors.blue,
                                          headerAlignment:
                                              ExpandablePanelHeaderAlignment
                                                  .center,
                                        ),
                                        expanded: HabitGroup2(
                                            habitList: [
                                              "Yoga",
                                              "Meditation",
                                              "Drink Water",
                                              "Sleep Well"
                                            ],
                                            yaziTipiRengi: _yaziTipiRengi,
                                            butonCategory: "Health"),
                                        collapsed: Container(),
                                      )))),
                              Container(
                                child: ExpandableNotifier(
                                    initialExpanded: true,
                                    child: ScrollOnExpand(
                                        child: ExpandablePanel(
                                      header: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 5, 0, 0),
                                        child: Row(
                                          children: [
                                            Text("Sport",
                                                textAlign: TextAlign.start,
                                                style: GoogleFonts.publicSans(
                                                    fontSize: 25,
                                                    color: _yaziTipiRengi)),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 0, 0, 0),
                                              child: Icon(
                                                Icons.directions_run,
                                                size: 25,
                                                color: Color.fromARGB(
                                                    223, 18, 218, 7),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      theme: ExpandableThemeData(
                                        iconColor: Colors.blue,
                                        headerAlignment:
                                            ExpandablePanelHeaderAlignment
                                                .center,
                                      ),
                                      expanded: HabitGroup2(
                                          habitList: [
                                            "Walk",
                                            "Push Up",
                                            "Run",
                                            "Swim"
                                          ],
                                          yaziTipiRengi: _yaziTipiRengi,
                                          butonCategory: "Sport"),
                                      collapsed: Container(),
                                    ))),
                                // color: Colors.red.shade200,
                              ),
                              Container(
                                child: ExpandableNotifier(
                                    child: ScrollOnExpand(
                                        child: ExpandablePanel(
                                  header: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                    child: Row(
                                      children: [
                                        Text("Study",
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.publicSans(
                                                fontSize: 25,
                                                color: _yaziTipiRengi)),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 0, 0),
                                          child: Icon(
                                            Icons.school,
                                            size: 25,
                                            color: Color.fromARGB(
                                                223, 124, 38, 223),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  theme: ExpandableThemeData(
                                    iconColor: Colors.blue,
                                    headerAlignment:
                                        ExpandablePanelHeaderAlignment.center,
                                  ),
                                  expanded: HabitGroup2(
                                      habitList: [
                                        "Read a book",
                                        "Learn English",
                                        "Math Exercise",
                                        "Law"
                                      ],
                                      yaziTipiRengi: _yaziTipiRengi,
                                      butonCategory: "Study"),
                                  collapsed: Container(),
                                ))),
                                // color: Colors.red.shade300,
                              ),
                              Container(
                                child: ExpandableNotifier(
                                    child: ScrollOnExpand(
                                        child: ExpandablePanel(
                                  header: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                    child: Row(
                                      children: [
                                        Text("Art",
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.publicSans(
                                                fontSize: 25,
                                                color: _yaziTipiRengi)),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 0, 0),
                                          child: Icon(
                                            Icons.palette,
                                            size: 25,
                                            color: Color.fromARGB(
                                                223, 225, 5, 240),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  theme: ExpandableThemeData(
                                    iconColor: Colors.blue,
                                    headerAlignment:
                                        ExpandablePanelHeaderAlignment.center,
                                  ),
                                  expanded: HabitGroup2(
                                      habitList: [
                                        "Play Guitar",
                                        "Painting",
                                        "Play Piano",
                                        "Dance"
                                      ],
                                      yaziTipiRengi: _yaziTipiRengi,
                                      butonCategory: "Art"),
                                  collapsed: Container(),
                                ))),
                                // color: Colors.red.shade400,
                              ),
                              Container(
                                child: ExpandableNotifier(
                                    child: ScrollOnExpand(
                                        child: ExpandablePanel(
                                  header: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                    child: Row(
                                      children: [
                                        Text("Finance",
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.publicSans(
                                                fontSize: 25,
                                                color: _yaziTipiRengi)),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 0, 0),
                                          child: Icon(
                                            Icons.attach_money,
                                            size: 25,
                                            color:
                                                Color.fromARGB(223, 12, 162, 7),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  theme: ExpandableThemeData(
                                    iconColor: Colors.blue,
                                    headerAlignment:
                                        ExpandablePanelHeaderAlignment.center,
                                  ),
                                  expanded: HabitGroup2(
                                      habitList: [
                                        "Saving Money",
                                        "Investing",
                                        "Donation",
                                        "Market Search"
                                      ],
                                      yaziTipiRengi: _yaziTipiRengi,
                                      butonCategory: "Finance"),
                                  collapsed: Container(),
                                ))),
                                // color: Colors.red.shade500,
                              ),
                              Container(
                                child: ExpandableNotifier(
                                    child: ScrollOnExpand(
                                        child: ExpandablePanel(
                                  header: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                    child: Row(
                                      children: [
                                        Text("Social",
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.publicSans(
                                                fontSize: 25,
                                                color: _yaziTipiRengi)),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 0, 0),
                                          child: Icon(
                                            Icons.nightlife,
                                            size: 25,
                                            color: Color.fromARGB(
                                                223, 232, 118, 18),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  theme: ExpandableThemeData(
                                    iconColor: Colors.blue,
                                    headerAlignment:
                                        ExpandablePanelHeaderAlignment.center,
                                  ),
                                  expanded: HabitGroup2(
                                      habitList: [
                                        "Cinema",
                                        "Meet with friends",
                                        "Theater",
                                        "Listen Podcast"
                                      ],
                                      yaziTipiRengi: _yaziTipiRengi,
                                      butonCategory: "Social"),
                                  collapsed: Container(),
                                ))),
                                // color: Colors.red.shade600,
                              ),
                              Container(
                                child: ExpandableNotifier(
                                    child: ScrollOnExpand(
                                        child: ExpandablePanel(
                                  header: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                    child: Row(
                                      children: [
                                        Text("Quit a Bad Habit",
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.publicSans(
                                                fontSize: 25,
                                                color: _yaziTipiRengi)),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 0, 0),
                                          child: Icon(
                                            Icons.smoke_free,
                                            size: 25,
                                            color: Color.fromARGB(
                                                223, 19, 153, 243),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  theme: ExpandableThemeData(
                                    iconColor: Colors.blue,
                                    headerAlignment:
                                        ExpandablePanelHeaderAlignment.center,
                                  ),
                                  expanded: HabitGroup2(
                                      habitList: [
                                        "Quit smoking",
                                        "Quit eating snacks",
                                        "Quit alcohol",
                                        "Stop swearing"
                                      ],
                                      yaziTipiRengi: _yaziTipiRengi,
                                      butonCategory: "Quit a Bad Habit"),
                                  collapsed: Container(),
                                ))),
                                // color: Colors.red.shade700,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              _yourHabits =
                                  box.get("chooseYourHabitsHive") ?? [];

                              if (_yourHabits.length > 0) {
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                              // print(object);
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
                                            fontSize: 15,
                                            color: _yaziTipiRengi))),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: Text("--- $_orButton ---",
                                style: TextStyle(
                                  color: _yaziTipiRengi,
                                  fontSize: 15,
                                  fontFamily: 'Times New Roman',
                                  // fontWeight: FontWeight.bold
                                )),
                          ),
                          InkWell(
                            onTap: () async {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          DefineYourHabit()),
                                  (Route<dynamic> route) => false);

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => DefineYourHabit()));
                            },
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    // border: Border.all(color: _yaziTipiRengi.withOpacity(0.8),width: 0.7),
                                    // borderRadius: BorderRadius.circular(15)
                                    ),
                                child: Center(
                                    child: Text(_defineYourHabit,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.publicSans(
                                          decoration: TextDecoration.underline,
                                          fontSize: 15,
                                          color:
                                              _yaziTipiRengi.withOpacity(0.8),
                                        ))),
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
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      IntroPage()),
                              (Route<dynamic> route) => false);

                          // await _auth.signOut();

                          // var a = await _authService.signOut();
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => CheckAuth()));
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
          )),
    );
  }
}
