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

/////
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

  late var _youShouldOneHabit =
      AppLocalizations.of(context)!.youShouldOneHabit.toString();

  ///
  ///
//////
  ///
  ///
  ///
  ///
  ///
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
                                              Text(_healthLabel,
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
                                              _yoga,
                                              _meditation,
                                              _drinkWater,
                                              _sleepWell
                                            ],
                                            yaziTipiRengi: _yaziTipiRengi,
                                            butonCategory: _healthLabel),
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
                                            Text(_sportLabel,
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
                                            _walk,
                                            _pushUp,
                                            _run,
                                            _swim
                                          ],
                                          yaziTipiRengi: _yaziTipiRengi,
                                          butonCategory: _sportLabel),
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
                                        Text(_studyLabel,
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
                                        _readABook,
                                        _learnEnglish,
                                        _mathExercise,
                                        _repeatToday
                                      ],
                                      yaziTipiRengi: _yaziTipiRengi,
                                      butonCategory: _studyLabel),
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
                                        Text(_artLabel,
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
                                        _playGuitar,
                                        _painting,
                                        _playPiano,
                                        _dance
                                      ],
                                      yaziTipiRengi: _yaziTipiRengi,
                                      butonCategory: _artLabel),
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
                                        Text(_financeLabel,
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
                                        _savingMoney,
                                        _checkStocks,
                                        _donate,
                                        _checkCurrencies
                                      ],
                                      yaziTipiRengi: _yaziTipiRengi,
                                      butonCategory: _financeLabel),
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
                                        Text(_socialLabel,
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
                                        _cinema,
                                        _meetWithFriends,
                                        _theater,
                                        _playGames
                                      ],
                                      yaziTipiRengi: _yaziTipiRengi,
                                      butonCategory: _socialLabel),
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
                                        Text(_quitABadHabitLabel,
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
                                        _quitSmoking,
                                        _quitEatingSnacks,
                                        _quitAlcohol,
                                        _stopSwearing
                                      ],
                                      yaziTipiRengi: _yaziTipiRengi,
                                      butonCategory: _quitABadHabitLabel),
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
