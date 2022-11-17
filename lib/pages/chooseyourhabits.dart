import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kiwihabitapp/auth/authFunctions.dart';
import 'package:kiwihabitapp/auth/authentication.dart';
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
    return Scaffold(
        backgroundColor: Color.fromRGBO(21, 9, 35, 1),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
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
                Container(
                    color: Colors.red.shade100,
                    child: ExpandableNotifier(
                        child: ScrollOnExpand(
                            child: ExpandablePanel(
                      header: Text("Health",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Color.fromRGBO(21, 9, 35, 1),
                            fontSize: 25,
                            fontFamily: 'Times New Roman',
                            // fontWeight: FontWeight.bold
                          )),
                      theme: ExpandableThemeData(iconColor: Colors.blue),
                      expanded: HabitGroup2(habitList: [
                        "Meditation",
                        "Yoga",
                        "Drink Water",
                        "Sleep Well"
                      ], yaziTipiRengi: _yaziTipiRengi),
                      collapsed: Container(),
                    )))),
                Container(
                  child: ExpandableNotifier(
                      child: ScrollOnExpand(
                          child: ExpandablePanel(
                    header: Text("Sport",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Color.fromRGBO(21, 9, 35, 1),
                          fontSize: 25,
                          fontFamily: 'Times New Roman',
                          // fontWeight: FontWeight.bold
                        )),
                    theme: ExpandableThemeData(iconColor: Colors.blue),
                    expanded: HabitGroup2(
                        habitList: ["Walk", "Run", "Swim", "Push Up"],
                        yaziTipiRengi: _yaziTipiRengi),
                    collapsed: Container(),
                  ))),
                  color: Colors.red.shade200,
                ),
                Container(
                  child: ExpandableNotifier(
                      child: ScrollOnExpand(
                          child: ExpandablePanel(
                    header: Text("Study",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Color.fromRGBO(21, 9, 35, 1),
                          fontSize: 25,
                          fontFamily: 'Times New Roman',
                          // fontWeight: FontWeight.bold
                        )),
                    theme: ExpandableThemeData(iconColor: Colors.blue),
                    expanded: HabitGroup2(habitList: [
                      "Read a book",
                      "Learn English",
                      "Math Exercise",
                      "Law"
                    ], yaziTipiRengi: _yaziTipiRengi),
                    collapsed: Container(),
                  ))),
                  color: Colors.red.shade300,
                ),
                Container(
                  child: ExpandableNotifier(
                      child: ScrollOnExpand(
                          child: ExpandablePanel(
                    header: Text("Art",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Color.fromRGBO(21, 9, 35, 1),
                          fontSize: 25,
                          fontFamily: 'Times New Roman',
                          // fontWeight: FontWeight.bold
                        )),
                    theme: ExpandableThemeData(iconColor: Colors.blue),
                    expanded: HabitGroup2(habitList: [
                      "Play Guitar",
                      "Painting",
                      "Play Piano",
                      "Dance"
                    ], yaziTipiRengi: _yaziTipiRengi),
                    collapsed: Container(),
                  ))),
                  color: Colors.red.shade400,
                ),
                Container(
                  child: ExpandableNotifier(
                      child: ScrollOnExpand(
                          child: ExpandablePanel(
                    header: Text("Finance",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Color.fromRGBO(21, 9, 35, 1),
                          fontSize: 25,
                          fontFamily: 'Times New Roman',
                          // fontWeight: FontWeight.bold
                        )),
                    theme: ExpandableThemeData(iconColor: Colors.blue),
                    expanded: HabitGroup2(habitList: [
                      "Saving Money",
                      "Investing",
                      "Donation",
                      "Market Search"
                    ], yaziTipiRengi: _yaziTipiRengi),
                    collapsed: Container(),
                  ))),
                  color: Colors.red.shade500,
                ),
                Container(
                  child: ExpandableNotifier(
                      child: ScrollOnExpand(
                          child: ExpandablePanel(
                    header: Text("Social",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Color.fromRGBO(21, 9, 35, 1),
                          fontSize: 25,
                          fontFamily: 'Times New Roman',
                          // fontWeight: FontWeight.bold
                        )),
                    theme: ExpandableThemeData(iconColor: Colors.blue),
                    expanded: HabitGroup2(habitList: [
                      "Cinema",
                      "Meet with friends",
                      "Theater",
                      "Listen Podcast"
                    ], yaziTipiRengi: _yaziTipiRengi),
                    collapsed: Container(),
                  ))),
                  color: Colors.red.shade600,
                ),
                Container(
                  child: ExpandableNotifier(
                      child: ScrollOnExpand(
                          child: ExpandablePanel(
                    header: Text("Quit a Bad Habit",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Color.fromRGBO(21, 9, 35, 1),
                          fontSize: 25,
                          fontFamily: 'Times New Roman',
                          // fontWeight: FontWeight.bold
                        )),
                    theme: ExpandableThemeData(iconColor: Colors.blue),
                    expanded: HabitGroup2(habitList: [
                      "Quit smoking",
                      "Quit eating snacks",
                      "Quit alcohol",
                      "Stop swearing"
                    ], yaziTipiRengi: _yaziTipiRengi),
                    collapsed: Container(),
                  ))),
                  color: Colors.red.shade700,
                ),
                Center(
                  child: InkWell(
                    onTap: () async {
                      await _auth.signOut();
          
                      var a = await _authService.signOut();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CheckAuth()));
                    },
                    child: Container(
                      child: Text("Sign Out"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
