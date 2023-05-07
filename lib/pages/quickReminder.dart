import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kiwihabitapp/auth/authentication.dart';
import 'package:kiwihabitapp/pages/bePremiumUser.dart';
import 'package:kiwihabitapp/pages/chooseyourhabits.dart';
import 'package:kiwihabitapp/pages/habitDetails.dart';
import 'package:kiwihabitapp/services/local_notification_service.dart';
import 'package:kiwihabitapp/widgets/textFieldDecoration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'package:timezone/timezone.dart' as tz;

class QuickReminder extends StatefulWidget {
  const QuickReminder({Key? key}) : super(key: key);

  @override
  State<QuickReminder> createState() => _QuickReminderState();
}

class _QuickReminderState extends State<QuickReminder>
    with TickerProviderStateMixin {
  NotificationsServices notificationsServices = NotificationsServices();
  late AnimationController _checkController;
  String _lonieURL = "";
  Map _reminderMap = {};
  Map _reminderDatesMap = {};
  String _reminderName = "";
  final int _defaultinitialPage = 100;
  int _initialPage = 100; //initial page değeri değişirse bu değerde değişmeli
  DateTime _remindDay = DateTime.now();
  var _remindTime = TimeOfDay(
      hour: DateTime.now().add(Duration(minutes: 30)).hour,
      minute: DateTime.now().add(Duration(minutes: 30)).minute);
  PageController _pageController =
      PageController(viewportFraction: 1 / 7, initialPage: 100);
  final Color _backgroudRengi = Color.fromRGBO(21, 9, 35, 1);
  late var _goalText = AppLocalizations.of(context)!.goalText.toString();

  late var _inADayText = AppLocalizations.of(context)!.inADay.toString();

  late var _everyDay = AppLocalizations.of(context)!.everyDay.toString();
  late var _habitNameTextField =
      AppLocalizations.of(context)!.habitName.toString();
  late var _addToHabits = AppLocalizations.of(context)!.addToHabits.toString();
  late var _addNewHabit = AppLocalizations.of(context)!.addNewHabit.toString();

  bool _insistCheckBox = false;

  late Box box;
  List _yourFinalHabits = [];
  var _category = "Health";
  List _yourHabits = [];

  final Color _yaziTipiRengi = Color(0xffE4EBDE);
  TextEditingController _turkceTextFieldController = TextEditingController();
  var _habitDetails;
  var habitName;
  var _habitDays;

  scheduleReminderNotification() {
    int _tempLastReminderID = 0;
    _reminderMap.forEach((k, v) {
      _tempLastReminderID = k;
    });
    DateTime _dt = DateTime(_remindDay.year, _remindDay.month, _remindDay.day,
        _remindTime.hour, _remindTime.minute);
    var tzdatetime = tz.TZDateTime.from(_dt, tz.local);

    notificationsServices.sendScheduledNotifications2(
        _tempLastReminderID + 1,
        "KiWi🥝",
        "Reminder for " + _reminderName + " 😎",
        // _startTime.hour.toString() +
        //     ":0" +
        //     _startTime.minute.toString(),
        tzdatetime);
    _reminderMap[_tempLastReminderID + 1] = _reminderName;
    _reminderDatesMap[_tempLastReminderID + 1] = tzdatetime;
    box.put("reminderMapHive", _reminderMap);
    box.put("reminderDateMapHive", _reminderDatesMap);
    print(_reminderMap);
  }

  addNewReminder() {
    if (!_insistCheckBox) {
      scheduleReminderNotification();

      setState(() {
        _lonieURL = "assets/json/check.json";
      });
      _checkController.forward();
      Future.delayed(const Duration(milliseconds: 1200), () {
        _checkController.reset();
        setState(() {
          _lonieURL = "";
        });

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => CheckAuth()),
            (Route<dynamic> route) => false);
      });
    } else {}
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context);

    // Navigator.pop(context);
    return true;
  }

  @override
  void initState() {
    super.initState();

    box = Hive.box("kiwiHive");
    getCurrentChooseYourHabits();

    _checkController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
  }

  timePickFunction() async {
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
          hour: DateTime.now().add(Duration(minutes: 30)).hour,
          minute: DateTime.now().add(Duration(minutes: 30)).minute),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? Container(),
        );
      },
    );
    if (newTime == null)
      return;
    else {
      if (newTime.minute < 10) {
        newTime = TimeOfDay(
            hour: newTime.hour,
            minute: int.parse("0" + newTime.minute.toString()));
        // print(newTime);
      }

      setState(() {
        _remindTime = newTime!;
      });
    }
  }

  datePickFunction() async {
    DateTime? _selectedDate = await showDatePicker(
        locale: Localizations.localeOf(context),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: _backgroudRengi, // header background color
                onPrimary: _yaziTipiRengi, // header text color
                onSurface: Color.fromARGB(255, 20, 39, 20), // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: _backgroudRengi, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
        context: context,
        initialDate: DateTime.now()
            .add(Duration(days: _initialPage - _defaultinitialPage)),
        firstDate: DateTime.now().subtract(Duration(days: _defaultinitialPage)),
        lastDate: DateTime.now().add(Duration(days: _defaultinitialPage)));
    print(_selectedDate);
    setState(() {
      _remindDay = _selectedDate!;
    });
    if (_selectedDate != null) {
      var _difference = _selectedDate
          .difference(DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day))
          .inDays;
      print(_selectedDate);
      // _pageController.jumpToPage(
      //     _defaultinitialPage + _difference);

    }
  }

  getCurrentChooseYourHabits() async {
    _reminderMap =
        await box.get("reminderMapHive") ?? {999999: "startReminder"}; //eski
    _reminderDatesMap =
        await box.get("reminderDateMapHive") ?? {999999: DateTime.now()}; //eski
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
                                  _reminderName = value2;
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.today,
                                    size: 30.00,
                                    color: _yaziTipiRengi,
                                  ),
                                  onPressed: () async {
                                    datePickFunction();
                                  },
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  datePickFunction();
                                },
                                child: Text(
                                    _remindDay == DateTime.now()
                                        ? DateFormat(
                                                'dd-MM-yyyy',
                                                Localizations.localeOf(context)
                                                    .toString())
                                            .format(DateTime.now())
                                        : DateFormat(
                                                'dd-MM-yyyy',
                                                Localizations.localeOf(context)
                                                    .toString())
                                            .format(_remindDay),
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 209, 204, 215),
                                      fontSize: 15,
                                      fontFamily: 'Times New Roman',
                                      // fontWeight: FontWeight.bold
                                    )),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.schedule,
                                    size: 30.00,
                                    color: _yaziTipiRengi,
                                  ),
                                  onPressed: () async {
                                    timePickFunction();
                                  },
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  timePickFunction();
                                },
                                child: Text(
                                    _remindTime.minute < 10
                                        ? _remindTime.hour.toString() +
                                            ":0" +
                                            _remindTime.minute.toString()
                                        : _remindTime.hour.toString() +
                                            ":" +
                                            _remindTime.minute.toString(),
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 209, 204, 215),
                                      fontSize: 15,
                                      fontFamily: 'Times New Roman',
                                      // fontWeight: FontWeight.bold
                                    )),
                              )
                            ],
                          ),
                          Visibility(
                            visible: false,
                            child: Theme(
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
                                visualDensity: VisualDensity(horizontal: -4),
                                dense: true,
                                title: Text(
                                  "Israrla Hatırlat (Kapatılana kadar her 3 dk)",
                                  style: TextStyle(
                                    color: _yaziTipiRengi,
                                    fontSize: 15,
                                    fontFamily: 'Times New Roman',
                                  ),
                                ),
                                value: _insistCheckBox,
                                onChanged: (val) {
                                  setState(() {
                                    _insistCheckBox = !_insistCheckBox;
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: RawMaterialButton(
                                fillColor:
                                    _reminderName == null || _reminderName == ""
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
                                    _reminderName == null || _reminderName == ""
                                        ? null
                                        : () async {
                                            addNewReminder();
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
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 25,
                        color: Colors.white,
                      )),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height - 340 + 80,
                right: MediaQuery.of(context).size.width / 2 - 125,
                child: Container(
                  //  BoxDecoration(
                  //   border: Border.all(color: Colors.black),
                  //   color: Color(0xff70e000),
                  //   borderRadius:
                  //       BorderRadius.all(Radius.circular(50 / 2)),
                  // )

                  width: 250,
                  height: 250,
                  child: _lonieURL == ""
                      ? SizedBox()
                      : Lottie.asset(_lonieURL, controller: _checkController),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
