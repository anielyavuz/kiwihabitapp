import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kiwihabitapp/auth/authFunctions.dart';
import 'package:kiwihabitapp/auth/authentication.dart';
import 'package:kiwihabitapp/pages/chooseyourhabits.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int _index = 0;
  List _introPages = ["Hoş geldiniz", "Merhaba", "Selam", "Naber"];
  AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Color _yaziTipiRengi = Color(0xffE4EBDE);
  late Box box;
  late List _loginLogs;
  @override
  void initState() {
    super.initState();
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    DateTime _bugun = new DateTime(now.year, now.month, now.day);

    box = Hive.box("kiwiHive");
    _loginLogs = box.get("loginLogsHive") ?? [];
    for (var item in _loginLogs) {
      if (item.isBefore(_bugun)) {
        print("$item şuandan öncedir");
      } else {
        print("$item şuandan sonradır...");
      }
    }

    _loginLogs.add(date);
    print(_loginLogs);

    box.put("loginLogsHive", _loginLogs);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(21, 9, 35, 1),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0,20,0,0),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/kiwiLogo.png",
                      height: 100,
                      width: 100,
                    ),
                    Container(
                      child: Center(
                          child: Text(
                        "KiWi - Habit App",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.philosopher(
                            fontSize: 32, color: _yaziTipiRengi),
                      )),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: PageView(
                    controller:
                        PageController(viewportFraction: 1, initialPage: 0),
                    onPageChanged: (int index) => setState(() => _index = index),
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                        _introPages.length,
                        (index) => Padding(
                          padding: const EdgeInsets.fromLTRB(40,0,40,0),
                          child: Container(
                                width: 10,
                                height: 10,
                                color: Colors.amber.withOpacity(0.2),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(_introPages[_index],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: _yaziTipiRengi,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Times New Roman',
                                                  // fontWeight: FontWeight.bold
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("Above is an extract from the official flutter documentation",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: _yaziTipiRengi,
                                                  fontSize: 15,
                                                  fontFamily: 'Times New Roman',
                                                  // fontWeight: FontWeight.bold
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        ))),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RawMaterialButton(
                        fillColor: _yaziTipiRengi,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0))),
                        splashColor: Color(0xff867ae9),
                        textStyle: TextStyle(color: _yaziTipiRengi),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                          child: Text("Add Your First Habit",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromRGBO(21, 9, 35, 1),
                                fontSize: 15,
                                fontFamily: 'Times New Roman',
                                // fontWeight: FontWeight.bold
                              )),
                        ),
                        onPressed: () async {
                          var a = await _authService.anonymSignIn();
                        }),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    // box.put("key1", "value2");
                    final value = box.get("loginLogsHive") ?? "null";
                    print(value);
                  },
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: _yaziTipiRengi),
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Center(
                          child: Text("Already have any habits in KiWi ?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _yaziTipiRengi,
                                fontSize: 15,
                                fontFamily: 'Times New Roman',
                                // fontWeight: FontWeight.bold
                              ))),
                    ),
                  ),
                )
              
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
