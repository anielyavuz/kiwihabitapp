import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kiwihabitapp/auth/authFunctions.dart';
import 'package:kiwihabitapp/auth/authentication.dart';
import 'package:kiwihabitapp/pages/defineYourHabit.dart';
import 'package:kiwihabitapp/widgets/habitGroup.dart';
import 'package:kiwihabitapp/widgets/habitGroup2.dart';

class ChooseHabits extends StatefulWidget {
  const ChooseHabits({Key? key}) : super(key: key);

  @override
  State<ChooseHabits> createState() => _ChooseHabitsState();
}

class _ChooseHabitsState extends State<ChooseHabits> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Color _yaziTipiRengi = Color(0xffE4EBDE);
  AuthService _authService = AuthService();
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
                          "Choose Your Habits",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _yaziTipiRengi,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Times New Roman',
                            // fontWeight: FontWeight.bold
                          ),
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
                                                  style: TextStyle(
                                                    color: _yaziTipiRengi,
                                                    fontSize: 25,
                                                    fontFamily:
                                                        'Times New Roman',
                                                    // fontWeight: FontWeight.bold
                                                  )),
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
                                        expanded: HabitGroup2(habitList: [
                                          "Yoga",
                                          "Meditation",
                                          "Drink Water",
                                          "Sleep Well"
                                        ], yaziTipiRengi: _yaziTipiRengi),
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
                                                style: TextStyle(
                                                  color: _yaziTipiRengi,
                                                  fontSize: 25,
                                                  fontFamily: 'Times New Roman',
                                                  // fontWeight: FontWeight.bold
                                                )),
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
                                      expanded: HabitGroup2(habitList: [
                                        "Walk",
                                        "Push Up",
                                        "Run",
                                        "Swim"
                                      ], yaziTipiRengi: _yaziTipiRengi),
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
                                            style: TextStyle(
                                              color: _yaziTipiRengi,
                                              fontSize: 25,
                                              fontFamily: 'Times New Roman',
                                              // fontWeight: FontWeight.bold
                                            )),
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
                                  expanded: HabitGroup2(habitList: [
                                    "Read a book",
                                    "Learn English",
                                    "Math Exercise",
                                    "Law"
                                  ], yaziTipiRengi: _yaziTipiRengi),
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
                                            style: TextStyle(
                                              color: _yaziTipiRengi,
                                              fontSize: 25,
                                              fontFamily: 'Times New Roman',
                                              // fontWeight: FontWeight.bold
                                            )),
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
                                  expanded: HabitGroup2(habitList: [
                                    "Play Guitar",
                                    "Painting",
                                    "Play Piano",
                                    "Dance"
                                  ], yaziTipiRengi: _yaziTipiRengi),
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
                                            style: TextStyle(
                                              color: _yaziTipiRengi,
                                              fontSize: 25,
                                              fontFamily: 'Times New Roman',
                                              // fontWeight: FontWeight.bold
                                            )),
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
                                  expanded: HabitGroup2(habitList: [
                                    "Saving Money",
                                    "Investing",
                                    "Donation",
                                    "Market Search"
                                  ], yaziTipiRengi: _yaziTipiRengi),
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
                                            style: TextStyle(
                                              color: _yaziTipiRengi,
                                              fontSize: 25,
                                              fontFamily: 'Times New Roman',
                                              // fontWeight: FontWeight.bold
                                            )),
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
                                  expanded: HabitGroup2(habitList: [
                                    "Cinema",
                                    "Meet with friends",
                                    "Theater",
                                    "Listen Podcast"
                                  ], yaziTipiRengi: _yaziTipiRengi),
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
                                            style: TextStyle(
                                              color: _yaziTipiRengi,
                                              fontSize: 25,
                                              fontFamily: 'Times New Roman',
                                              // fontWeight: FontWeight.bold
                                            )),
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
                                  expanded: HabitGroup2(habitList: [
                                    "Quit smoking",
                                    "Quit eating snacks",
                                    "Quit alcohol",
                                    "Stop swearing"
                                  ], yaziTipiRengi: _yaziTipiRengi),
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
                        children: [
                          InkWell(
                            onTap: () async {},
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
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: Text("--- or ---",
                                style: TextStyle(
                                  color: _yaziTipiRengi,
                                  fontSize: 15,
                                  fontFamily: 'Times New Roman',
                                  // fontWeight: FontWeight.bold
                                )),
                          ),
                          InkWell(
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DefineYourHabit()));
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
                                    child: Text("Define Your Habit",
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
                Positioned(
                  left: 5,
                  child: Container(
                    height: 40,
                    child: IconButton(
                        onPressed: () async {
                          await _auth.signOut();

                          var a = await _authService.signOut();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CheckAuth()));
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
