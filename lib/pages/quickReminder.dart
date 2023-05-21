import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kiwihabitapp/auth/authentication.dart';
import 'package:kiwihabitapp/pages/bePremiumUser.dart';
import 'package:kiwihabitapp/pages/chooseyourhabits.dart';
import 'package:kiwihabitapp/pages/habitDetails.dart';
import 'package:kiwihabitapp/services/dailyLogs.dart';
import 'package:kiwihabitapp/services/local_notification_service.dart';
import 'package:kiwihabitapp/widgets/textFieldDecoration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'package:timezone/timezone.dart' as tz;

class QuickReminder extends StatefulWidget {
  final Map userInfo;
  final int newInitialPage;
  const QuickReminder(
      {Key? key, required this.userInfo, required this.newInitialPage})
      : super(key: key);

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

  late var _quickNotificationAdd =
      AppLocalizations.of(context)!.quickNotificationAdd.toString();
  late var _quickNotificationTextLabel =
      AppLocalizations.of(context)!.quickNotificationTextLabel.toString();
  late var _scheduleNotification =
      AppLocalizations.of(context)!.scheduleNotification.toString();

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
    int _tempLastReminderID = 999999;
    _reminderMap.forEach((k, v) {
      _tempLastReminderID = k;
    });
    DateTime _dt = DateTime(_remindDay.year, _remindDay.month, _remindDay.day,
        _remindTime.hour, _remindTime.minute);
    var tzdatetime = tz.TZDateTime.from(_dt, tz.local);

    notificationsServices.sendScheduledNotifications2(
        _tempLastReminderID + 1,
        "KiWi🥝",
        _reminderName + " ⚡️",
        // _startTime.hour.toString() +
        //     ":0" +
        //     _startTime.minute.toString(),
        tzdatetime);
    _reminderMap[_tempLastReminderID + 1] = _reminderName;
    _reminderDatesMap[_tempLastReminderID + 1] = _dt;
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
        dailyLogs("Quick Reminder Created");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => CheckAuth()),
            (Route<dynamic> route) => false);
      });
    } else {}
  }

  dailyLogs(String _log) {
    // Future.delayed(const Duration(milliseconds: 2000), () {
    //   DailyLogs()
    //       .writeLog(widget.userInfo['id'], widget.userInfo['userName'], _log);
    // });
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
        resizeToAvoidBottomInset: true,
        backgroundColor: Color.fromRGBO(21, 9, 35, 1),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 80,
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Text(
                                _quickNotificationAdd,
                                textAlign: TextAlign.center,
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
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                          // width: MediaQuery.of(context).size.width * 9 / 10,
                          child: TextField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(40),
                            ],
                            style: TextStyle(fontSize: 22),
                            autofocus: true,
                            onChanged: (value2) {
                              setState(() {
                                _reminderName = value2;
                              });
                            },
                            controller: _turkceTextFieldController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(16),
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
                              hintText: _quickNotificationTextLabel,
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(75, 21, 9, 35)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                      child: InkWell(
                        onTap: _reminderName == null || _reminderName == ""
                            ? null
                            : () async {
                                timePickFunction();
                              },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              gradient: RadialGradient(
                                  center: Alignment(-.7, -.7),
                                  colors: _reminderName == null ||
                                          _reminderName == ""
                                      ? [
                                          // Colors.white,
                                          // Colors.white
                                          Color.fromARGB(49, 149, 117, 205),
                                          Color.fromARGB(49, 126, 87, 194),
                                          Color.fromARGB(49, 104, 58, 183),
                                          Color.fromARGB(48, 94, 53, 177),
                                          Color.fromARGB(49, 82, 45, 168),
                                          Color.fromARGB(49, 69, 39, 160),
                                        ]
                                      : [
                                          Colors.deepPurple[300]!,
                                          Colors.deepPurple[400]!,
                                          Colors.deepPurple[500]!,
                                          Colors.deepPurple[600]!,
                                          Colors.deepPurple[700]!,
                                          Colors.deepPurple[800]!,
                                        ],
                                  radius: .7),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              border: Border.all(width: 2)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: double.infinity,
                                // width: double.infinity,
                                child: IconButton(
                                    icon: Icon(
                                      Icons.schedule,
                                      size: 45.00,
                                      color: _reminderName == null ||
                                              _reminderName == ""
                                          ? Color.fromARGB(49, 209, 204, 215)
                                          : Color.fromARGB(255, 209, 204, 215),
                                    ),
                                    onPressed: _reminderName == null ||
                                            _reminderName == ""
                                        ? null
                                        : () async {
                                            timePickFunction();
                                          }),
                              ),
                              InkWell(
                                onTap:
                                    _reminderName == null || _reminderName == ""
                                        ? null
                                        : () async {
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
                                      color: _reminderName == null ||
                                              _reminderName == ""
                                          ? Color.fromARGB(49, 209, 204, 215)
                                          : Color.fromARGB(255, 209, 204, 215),
                                      fontSize: 40,
                                      fontFamily: 'Times New Roman',
                                      // fontWeight: FontWeight.bold
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            gradient: RadialGradient(
                                center: Alignment(.7, -.7),
                                colors:
                                    _reminderName == null || _reminderName == ""
                                        ? [
                                            // Colors.white,
                                            // Colors.white
                                            Color.fromARGB(49, 149, 117, 205),
                                            Color.fromARGB(49, 126, 87, 194),
                                            Color.fromARGB(49, 104, 58, 183),
                                            Color.fromARGB(48, 94, 53, 177),
                                            Color.fromARGB(49, 82, 45, 168),
                                            Color.fromARGB(49, 69, 39, 160),
                                          ]
                                        : [
                                            Colors.deepPurple[300]!,
                                            Colors.deepPurple[400]!,
                                            Colors.deepPurple[500]!,
                                            Colors.deepPurple[600]!,
                                            Colors.deepPurple[700]!,
                                            Colors.deepPurple[800]!,
                                          ],
                                radius: .7),
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            border: Border.all(width: 2)),
                        child: InkWell(
                          onTap: _reminderName == null || _reminderName == ""
                              ? null
                              : () async {
                                  datePickFunction();
                                },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: double.infinity,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.today,
                                    size: 45.00,
                                    color: _reminderName == null ||
                                            _reminderName == ""
                                        ? Color.fromARGB(49, 209, 204, 215)
                                        : Color.fromARGB(255, 209, 204, 215),
                                  ),
                                  onPressed: _reminderName == null ||
                                          _reminderName == ""
                                      ? null
                                      : () async {
                                          datePickFunction();
                                        },
                                ),
                              ),
                              InkWell(
                                onTap:
                                    _reminderName == null || _reminderName == ""
                                        ? null
                                        : () async {
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
                                      color: _reminderName == null ||
                                              _reminderName == ""
                                          ? Color.fromARGB(49, 209, 204, 215)
                                          : Color.fromARGB(255, 209, 204, 215),
                                      fontSize: 40,
                                      fontFamily: 'Times New Roman',
                                      // fontWeight: FontWeight.bold
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: RawMaterialButton(
                          fillColor:
                              _reminderName == null || _reminderName == ""
                                  ? Color.fromARGB(48, 43, 218, 49)
                                  : Color.fromARGB(255, 43, 218, 49),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0))),
                          splashColor: Color(0xff867ae9),
                          textStyle: TextStyle(color: _yaziTipiRengi),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                            child: Text(_scheduleNotification,
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
                  ),
                  Expanded(flex: 1, child: SizedBox())
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
                    side: BorderSide(color: Color(0xff996B3E), width: 1),
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
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
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
                top: MediaQuery.of(context).size.height - 340,
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
