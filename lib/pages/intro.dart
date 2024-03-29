import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kiwihabitapp/auth/authFunctions.dart';
import 'package:kiwihabitapp/auth/authentication.dart';
import 'package:kiwihabitapp/pages/chooseyourhabits.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kiwihabitapp/services/buttonlessPopUp.dart';
import 'package:kiwihabitapp/services/loginOptionsPopUp.dart';
import 'package:lottie/lottie.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int _index = 0;

  AuthService _authService = AuthService();
  var _userInfo;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Color _yaziTipiRengi = Color(0xffE4EBDE);
  late var _currentlanguageText =
      AppLocalizations.of(context)!.language.toString();

  late var _dontHaveKiwiAccount =
      AppLocalizations.of(context)!.dontHaveKiwiAccount.toString();

  late var _continueWith =
      AppLocalizations.of(context)!.continueWith.toString();

  bool _loadingIcon = false;
  late Box box;
  late List _loginLogs;

  loginOptionsPopUp() {
    var baseDialog = LoginOptionsBaseAlertDialog(
        title: _continueWith,
        content: "",
        yesOnPressed: () async {
          Navigator.of(context, rootNavigator: true).pop(false);
          var _exist = await AuthService().googleLoginFromIntroPage();
        },
        noOnPressed: () async {
          Navigator.of(context, rootNavigator: true).pop(false);
          var _userVarYok = await AuthService().appleLoginFromIntroPage();
          print("CCCCCCCCC");
          print(_userVarYok);
          if (!_userVarYok) {
            showDialog(
              context: context,
              builder: (_) => ButtonlessPopUp(
                input: _dontHaveKiwiAccount + "🤔",
                fontSize: 22.0,
              ),
            );
          }
        },
        yes: "Google Sign In",
        no: "Apple ID Sign In");
    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

  @override
  void initState() {
    super.initState();
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    DateTime _bugun = new DateTime(now.year, now.month, now.day);

    box = Hive.box("kiwiHive");
    _loginLogs = box.get("loginLogsHive") ?? [];
    // for (var item in _loginLogs) {
    //   if (item.isBefore(_bugun)) {
    //     print("$item şuandan öncedir");
    //   } else {
    //     print("$item şuandan sonradır...");
    //   }
    // }

    _loginLogs.add(date);
    // print("----------------------");
    // print(AppLocalizations.of(context)!.language.toString());

    // print("DDDDDDDDDDDDDAAAAAAAAAAAAATTTTTTTTTTTTAAAAAAAAAAAAAAAAA4");

    // box.put("loginLogsHive", _loginLogs);
  }

  @override
  Widget build(BuildContext context) {
    late var _appHeaderText =
        AppLocalizations.of(context)!.appHeader.toString();
    late var _addYourFirstHabitText =
        AppLocalizations.of(context)!.addYourFirstHabitButton.toString();
    late var _alreadyHaveAnyHabitText =
        AppLocalizations.of(context)!.allreadyHaveKiwiButton.toString();
    late var _introFirstScreen =
        AppLocalizations.of(context)!.introFirstScreen.toString();

    late var _introFirstScreenDetail =
        AppLocalizations.of(context)!.introFirstScreenDetail.toString();

    late var _introSecondScreen =
        AppLocalizations.of(context)!.introSecondScreen.toString();

    late var _introSecondScreenDetail =
        AppLocalizations.of(context)!.introSecondScreenDetail.toString();
    late var _introThirdScreen =
        AppLocalizations.of(context)!.introThirdScreen.toString();

    late var _introThirdScreenDetail =
        AppLocalizations.of(context)!.introThirdScreenDetail.toString();

    late var _introFourthScreen =
        AppLocalizations.of(context)!.introFourthScreen.toString();

    late var _introFourthScreenDetail =
        AppLocalizations.of(context)!.introFourthScreenDetail.toString();

    List _introPages = [
      _introFirstScreen,
      _introSecondScreen,
      _introThirdScreen,
      _introFourthScreen
    ];
    List _introSubPages = [
      _introFirstScreenDetail,
      _introSecondScreenDetail,
      _introThirdScreenDetail,
      _introFourthScreenDetail,
    ];
    List _introImages = [
      'assets/json/exercise.json',
      'assets/json/yoga.json',
      'assets/json/work.json',
      'assets/json/read.json',
      'assets/json/sleep.json'
    ];

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(21, 9, 35, 1),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Column(
                  children: [
                    Expanded(
                      flex: 4,
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
                              _appHeaderText,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.publicSans(
                                  fontSize: 32, color: _yaziTipiRengi),
                            )),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: PageView(
                          controller: PageController(
                              viewportFraction: 1, initialPage: 0),
                          onPageChanged: (int index) => setState(() {
                                _index = index;
                              }),
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                              _introPages.length,
                              (index) => Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(40, 0, 40, 0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color.fromARGB(
                                                  255, 212, 212, 212)),
                                          // color: Color(0xff1d3557),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 20),
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Container(
                                                    child: Lottie.asset(
                                                        _introImages[index],
                                                        fit: BoxFit.scaleDown),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        FittedBox(
                                                          fit: BoxFit.fill,
                                                          child: Padding(
                                                            padding: const EdgeInsets.fromLTRB(8,0,8,0),
                                                            child: Text(
                                                              _introPages[_index],
                                                              textAlign:
                                                                  TextAlign.center,
                                                              style: GoogleFonts
                                                                  .publicSans(
                                                                      fontSize: 18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color:
                                                                          _yaziTipiRengi),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          _introSubPages[
                                                              _index],
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts
                                                              .publicSans(
                                                                  fontSize: 15,
                                                                  color:
                                                                      _yaziTipiRengi),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.center,
                                          //   children: [

                                          //     Padding(
                                          //       padding:
                                          //           const EdgeInsets.all(8.0),
                                          //       child: Container(
                                          //         decoration: BoxDecoration(
                                          //           color: index == 0
                                          //               ? Colors.black
                                          //               : Color.fromARGB(
                                          //                   255, 250, 250, 250),
                                          //           borderRadius:
                                          //               BorderRadius.all(
                                          //                   Radius.circular(4)),
                                          //           // borderRadius: BorderRadius.all(Radius.circular(15))
                                          //         ),
                                          //         height: index == 0 ? 12 : 7,
                                          //         width: index == 0 ? 12 : 7,
                                          //       ),
                                          //     ),
                                          //     Padding(
                                          //       padding:
                                          //           const EdgeInsets.all(8.0),
                                          //       child: Container(
                                          //         decoration: BoxDecoration(
                                          //           color: index == 1
                                          //               ? Colors.black
                                          //               : Color.fromARGB(
                                          //                   255, 255, 255, 255),
                                          //           borderRadius:
                                          //               BorderRadius.all(
                                          //                   Radius.circular(4)),
                                          //           // borderRadius: BorderRadius.all(Radius.circular(15))
                                          //         ),
                                          //         height: index == 1 ? 12 : 7,
                                          //         width: index == 1 ? 12 : 7,
                                          //       ),
                                          //     ),
                                          //     Padding(
                                          //       padding:
                                          //           const EdgeInsets.all(8.0),
                                          //       child: Container(
                                          //         decoration: BoxDecoration(
                                          //           color: index == 2
                                          //               ? Colors.black
                                          //               : Color.fromARGB(
                                          //                   255, 255, 255, 255),
                                          //           borderRadius:
                                          //               BorderRadius.all(
                                          //                   Radius.circular(4)),
                                          //           // borderRadius: BorderRadius.all(Radius.circular(15))
                                          //         ),
                                          //         height: index == 2 ? 12 : 7,
                                          //         width: index == 2 ? 12 : 7,
                                          //       ),
                                          //     ),
                                          //     Padding(
                                          //       padding:
                                          //           const EdgeInsets.all(8.0),
                                          //       child: Container(
                                          //         decoration: BoxDecoration(
                                          //           color: index == 3
                                          //               ? Colors.black
                                          //               : Color.fromARGB(
                                          //                   255, 255, 255, 255),
                                          //           borderRadius:
                                          //               BorderRadius.all(
                                          //                   Radius.circular(4)),
                                          //           // borderRadius: BorderRadius.all(Radius.circular(15))
                                          //         ),
                                          //         height: index == 3 ? 12 : 7,
                                          //         width: index == 3 ? 12 : 7,
                                          //       ),
                                          //     ),
                                          //     // Padding(
                                          //     //   padding: const EdgeInsets.all(8.0),
                                          //     //   child: Container(
                                          //     //     decoration: BoxDecoration(
                                          //     //       color: index == 4
                                          //     //           ? Color.fromARGB(255, 0, 0, 0)
                                          //     //           : Color.fromARGB(
                                          //     //               255, 255, 255, 255),
                                          //     //       borderRadius: BorderRadius.all(
                                          //     //           Radius.circular(4)),
                                          //     //       // borderRadius: BorderRadius.all(Radius.circular(15))
                                          //     //     ),
                                          //     //     height: index == 4 ? 12 : 7,
                                          //     //     width: index == 4 ? 12 : 7,
                                          //     //   ),
                                          //     // )
                                          //   ],
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ))),
                    ),
                    Expanded(
                      flex: 1,
                      child: Wrap(
                          direction: Axis.horizontal,
                          children: List.generate(4, (index3) {
                            return Text(
                              ".",
                              style: TextStyle(
                                  color: index3 == _index
                                      ? Colors.green
                                      : _yaziTipiRengi,
                                  fontSize: index3 == _index ? 65 : 55),
                            );
                          })),
                    ),
                    Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RawMaterialButton(
                                fillColor: _yaziTipiRengi,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                                splashColor: Color(0xff867ae9),
                                textStyle: TextStyle(color: _yaziTipiRengi),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                  child: Text(_addYourFirstHabitText,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.publicSans(
                                          fontSize: 15,
                                          color: Color.fromRGBO(21, 9, 35, 1))),
                                ),
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChooseHabits()));

                                  // setState(() {
                                  //   _loadingIcon = true;
                                  // });
                                  // var a = await _authService.anonymSignIn();

                                  // setState(() {
                                  //   _loadingIcon = false;
                                  // });
                                }),
                            const SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () async {
                                loginOptionsPopUp();
                              },
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                              _yaziTipiRengi.withOpacity(0.5),
                                          width: 0.7),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                      child: Text(_alreadyHaveAnyHabitText,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.publicSans(
                                              fontSize: 15,
                                              color: _yaziTipiRengi
                                                  .withOpacity(0.8)))),
                                ),
                              ),
                            )
                          ],
                        ))
                  ],
                ),
              ),
              Visibility(
                visible: _loadingIcon,
                child: Stack(
                  children: [
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: Container(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Center(
                      child: Container(
                        child: Lottie.asset(
                            // "https://assets5.lottiefiles.com/private_files/lf30_ijwulw45.json"
                            "assets/json/loading.json"),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
