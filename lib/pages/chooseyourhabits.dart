import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kiwihabitapp/auth/authFunctions.dart';
import 'package:kiwihabitapp/auth/authentication.dart';

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
                    expanded: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: RawMaterialButton(
                                    fillColor: _yaziTipiRengi,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0))),
                                    splashColor: Color(0xff867ae9),
                                    textStyle: TextStyle(color: _yaziTipiRengi),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(12, 0, 12, 0),
                                      child: Text("Meditation",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color.fromRGBO(21, 9, 35, 1),
                                            fontSize: 15,
                                            fontFamily: 'Times New Roman',
                                            // fontWeight: FontWeight.bold
                                          )),
                                    ),
                                    onPressed: () async {}),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: RawMaterialButton(
                                    fillColor: _yaziTipiRengi,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0))),
                                    splashColor: Color(0xff867ae9),
                                    textStyle: TextStyle(color: _yaziTipiRengi),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(12, 0, 12, 0),
                                      child: Text("Yoga",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color.fromRGBO(21, 9, 35, 1),
                                            fontSize: 15,
                                            fontFamily: 'Times New Roman',
                                            // fontWeight: FontWeight.bold
                                          )),
                                    ),
                                    onPressed: () async {}),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: RawMaterialButton(
                                    fillColor: _yaziTipiRengi,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0))),
                                    splashColor: Color(0xff867ae9),
                                    textStyle: TextStyle(color: _yaziTipiRengi),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(12, 0, 12, 0),
                                      child: Text("Drink Water",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color.fromRGBO(21, 9, 35, 1),
                                            fontSize: 15,
                                            fontFamily: 'Times New Roman',
                                            // fontWeight: FontWeight.bold
                                          )),
                                    ),
                                    onPressed: () async {}),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: RawMaterialButton(
                                    fillColor: _yaziTipiRengi,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0))),
                                    splashColor: Color(0xff867ae9),
                                    textStyle: TextStyle(color: _yaziTipiRengi),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(12, 0, 12, 0),
                                      child: Text("Sleep Well",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color.fromRGBO(21, 9, 35, 1),
                                            fontSize: 15,
                                            fontFamily: 'Times New Roman',
                                            // fontWeight: FontWeight.bold
                                          )),
                                    ),
                                    onPressed: () async {}),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    collapsed: Container(),
                  )))),
              Container(
                child: Text("AAAAAAAAA"),
                color: Colors.red.shade200,
              ),
              Container(
                child: Text("AAAAAAAAA"),
                color: Colors.red.shade300,
              ),
              Container(
                child: Text("AAAAAAAAA"),
                color: Colors.red.shade400,
              ),
              Container(
                child: Text("AAAAAAAAA"),
                color: Colors.red.shade500,
              ),
              Container(
                child: Text("AAAAAAAAA"),
                color: Colors.red.shade600,
              ),
              Container(
                child: Text("AAAAAAAAA"),
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
        ));
  }
}
