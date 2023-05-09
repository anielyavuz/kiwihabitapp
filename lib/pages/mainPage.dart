import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:kiwihabitapp/pages/addNewHabit.dart';
import 'package:kiwihabitapp/pages/bePremiumUser.dart';
import 'package:kiwihabitapp/pages/graphicPage.dart';
import 'package:kiwihabitapp/pages/intro.dart';
import 'package:kiwihabitapp/pages/quickReminder.dart';
import 'package:kiwihabitapp/services/audioClass.dart';
import 'package:kiwihabitapp/services/batteryOptimization.dart';
import 'package:kiwihabitapp/services/firebaseDocs.dart';
import 'package:kiwihabitapp/services/firestoreClass.dart';
import 'package:kiwihabitapp/services/iconClass.dart';
import 'package:kiwihabitapp/services/loginOptionsPopUp.dart';
import 'package:kiwihabitapp/services/twoButtonPopUp.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'package:timezone/timezone.dart' as tz;

import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kiwihabitapp/auth/authFunctions.dart';
import 'package:kiwihabitapp/auth/authentication.dart';
import 'package:kiwihabitapp/services/local_notification_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:soundpool/soundpool.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Map _reminderMap = {};
  Map _reminderDatesMap = {};
  bool _isButtonPressed = false;
  int _isButtonPressedID = 0;
  late var _todayText = AppLocalizations.of(context)!.todayText.toString();
  late var _signIn = AppLocalizations.of(context)!.signIn.toString();
  late var _exitButton = AppLocalizations.of(context)!.exitButton.toString();
  late var _deleteAccount =
      AppLocalizations.of(context)!.deleteAccount.toString();
  late var _cancelButton =
      AppLocalizations.of(context)!.cancelButton.toString();

  late var _deleteHabit = AppLocalizations.of(context)!.deleteHabit.toString();

  late var _goalText = AppLocalizations.of(context)!.goalText.toString();

  late var _inADayText = AppLocalizations.of(context)!.inADay.toString();

  late var _everyDay = AppLocalizations.of(context)!.everyDay.toString();

  late var _deleteAccountConfirm =
      AppLocalizations.of(context)!.deleteAccountConfirm.toString();

  late var _reallyAsk = AppLocalizations.of(context)!.reallyAsk.toString();

  var _userInfo;
  var _configsInfo;

  bool _slidingCheckBoxEveryDay = true;
  List _sligingYourHabitAlltimes = [];
  List _slidingItemWeekDaysList = [];
  int _slidingCountADay = 1;
  int _configsInfoInteger = 0;
  String _slidingIconName = "Yoga";
  bool _editleme = true;
  Icon _slidingIcon = Icon(
    Icons.volunteer_activism,
    size: 25,
    color: Color.fromARGB(223, 218, 21, 7),
  );
  String version = "";
  String code = "";
  late List _loginLogs;
  String _slidingHeaderText = "Drink Water";
  PanelController _pc = new PanelController();
  int _expand1 = 4;
  int _expand2 = 4;
  NotificationsServices notificationsServices = NotificationsServices();
  late Box box;
  List<DateTime> days = [];
  List _yourHabits = [];
  bool _batterySaver = true;
  var _habitDays;
  var _habitDetails;
  int _currentIndexCalendar =
      100; //initial page değeri değişirse bu değerde değişmeli

  final Color _yaziTipiRengi = Color(0xffE4EBDE);
  final Color _backgroudRengi = Color.fromRGBO(21, 9, 35, 1);
  List _currentDayHabit = [];
  Map _currentDayCompletedHabits = {};
  bool _bottomNavigatorShow = true;
  Map _completedHabits = {};
  Map _icons = {
    "Health": Icon(
      Icons.volunteer_activism,
      size: 25,
      color: Color.fromARGB(223, 218, 21, 7),
    ),
    "Sport": Icon(
      Icons.directions_run,
      size: 25,
      color: Color.fromARGB(223, 18, 218, 7),
    ),
    "Study": Icon(
      Icons.school,
      size: 25,
      color: Color.fromARGB(223, 124, 38, 223),
    ),
    "Art": Icon(
      Icons.palette,
      size: 25,
      color: Color.fromARGB(223, 225, 5, 240),
    ),
    "Finance": Icon(
      Icons.attach_money,
      size: 25,
      color: Color.fromARGB(223, 12, 162, 7),
    ),
    "Social": Icon(
      Icons.nightlife,
      size: 25,
      color: Color.fromARGB(223, 232, 118, 18),
    ),
    "Quit a Bad Habit": Icon(
      Icons.smoke_free,
      size: 25,
      color: Color.fromARGB(223, 19, 153, 243),
    )
  };
  Map _completedHelp = {};
  Map _finalCompleted = {};
  double _opacityAnimation = 0;
  int _opacityAnimationDuration = 500;
  var _datetime;
  List _tempWillDelete = ["Drink Water", "Walk", "Take a pill"];
  final int _defaultinitialPage = 100;
  int _initialPage = 100; //initial page değeri değişirse bu değerde değişmeli
  AuthService _authService = AuthService();
  PageController _pageController =
      PageController(viewportFraction: 1 / 7, initialPage: 100);
  BaseAlertDialog baseAlertDialog = BaseAlertDialog();
  List<DateTime> calculateDaysInterval(DateTime startDate, DateTime endDate) {
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }

    return days;
  }

  loginOptionsPopUp() {
    var baseDialog = LoginOptionsBaseAlertDialog(
        title: "Please Pick a Login Method",
        content: "",
        yesOnPressed: () async {
          Navigator.of(context, rootNavigator: true).pop(false);
          AuthService().googleLoginFromMainPage(_userInfo);
        },
        noOnPressed: () async {
          AuthService().appleLoginFromMainPage(_userInfo);
          Navigator.of(context, rootNavigator: true).pop(false);
        },
        yes: "Google Sign In",
        no: "Apple ID Sign In");
    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

  askToLoginBeforeExit() {
    var baseDialog = BaseAlertDialog(
        title: "Warning",
        content: "You will lose your habits data, please sign up before leave.",
        yesOnPressed: () async {
          //

          // var k = await AuthService().googleLoginFromMainPage(_userInfo);
          Navigator.of(context, rootNavigator: true).pop(false);
          loginOptionsPopUp();
        },
        noOnPressed: () async {
          box.put("chooseYourHabitsHive", []);
          box.put("habitDetailsHive", []);
          box.put("habitDays", []);
          box.put("completedHabits", {});
          box.put("finalCompleted", {});
          box.put("reminderMapHive", {});
          box.put("reminderDateMapHive", {});
          var a = await _authService.signOutAndDeleteUser(
              _userInfo['id'], _userInfo['registerType']);
          // await _auth.signOut();
          print("Silindiiiiiiiii");

          Navigator.of(context, rootNavigator: true).pop(false);

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => CheckAuth()),
              (Route<dynamic> route) => false);

          // Navigator.of(context, rootNavigator: true).pop(false);
        },
        yes: _signIn,
        no: _exitButton);
    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

  deleteAccount() {
    var baseDialog = BaseAlertDialog(
        title: _reallyAsk,
        content: _deleteAccountConfirm,
        noOnPressed: () async {
          box.put("chooseYourHabitsHive", []);
          box.put("habitDetailsHive", []);
          box.put("habitDays", []);
          box.put("completedHabits", {});
          box.put("finalCompleted", {});
          box.put("reminderMapHive", {});
          box.put("reminderDateMapHive", {});
          AuthService().signOutAndDeleteUser(_userInfo['id'], "Anonym");
          Navigator.of(context, rootNavigator: true).pop(false);
        },
        yesOnPressed: () async {
          Navigator.of(context, rootNavigator: true).pop(false);
        },
        yes: _cancelButton,
        no: "Delete");
    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

  isButtonPressedCheck(int isButtonPressedID) {
    setState(() {
      print("button true");
      _isButtonPressed = true;
      _isButtonPressedID = isButtonPressedID;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _isButtonPressed = false;
        print("button false");
      });
    });
  }

  versionInform() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
      code = packageInfo.buildNumber;
    });
  }

  test() {
    print(_reminderDatesMap);
    print("------------");
    print(_reminderMap);

    _reminderMap.forEach((k, v) {
      print("??");
      print(_reminderDatesMap[k]);

      print("Test " +
          tz.TZDateTime.from(_reminderDatesMap[k], tz.local).toString());
    });
  }

  notificaitonMap() {
    notificationsServices.stopNotifications();

    _reminderMap.forEach((k, v) {
      // print("Tarih bilinmiyor " + _reminderDatesMap[k].toString());
      if (_reminderDatesMap[k].isAfter(DateTime.now())) {
        print("Tarih sonra " + _reminderDatesMap[k].toString());
        print("Test $k " +
            tz.TZDateTime.from(_reminderDatesMap[k], tz.local).toString());
        notificationsServices.sendScheduledNotifications2(
            k,
            "KiWi🥝",
            "Reminder for " + v + " 😎",
            // _startTime.hour.toString() +
            //     ":0" +
            //     _startTime.minute.toString(),
            tz.TZDateTime.from(_reminderDatesMap[k], tz.local));
      }
    });
    int _notificationID = 0;
    List list = List.generate(
        10,
        (i) =>
            i); //0'dan 10'a kadar elemanları olan liste oluşturur. Sonraki 10 güne notification'ı yazar.
    int _nameDayInt = 0;
    // print(_habitDays);
    for (var _addedDay in list) {
      _nameDayInt = ((DateTime.now().add(Duration(days: _addedDay)))
              .difference(DateTime(2000, 1, 3))
              .inDays %
          7);
      // print(_nameDayInt);
      if (_habitDetails.length > 0) {
        if (_habitDays != null) {
          _habitDays.forEach((k, v) {
            if (v.contains(_nameDayInt.toString())) {
              for (var _habitInfo in _habitDetails[k]['_allTimes']) {
                ///örn:  [{time: TimeOfDay(12:30), notification: true, alarm: false}]}z
                ///
                if (_habitInfo['notification']) {
                  TimeOfDay _startTime = TimeOfDay(
                      hour: int.parse(_habitInfo['time']
                          .split("(")[1]
                          .split(")")[0]
                          .split(":")[0]),
                      minute: int.parse(_habitInfo['time']
                          .split("(")[1]
                          .split(")")[0]
                          .split(":")[1]));
                  DateTime _dt = DateTime(
                      DateTime.now().add(Duration(days: _addedDay)).year,
                      DateTime.now().add(Duration(days: _addedDay)).month,
                      DateTime.now().add(Duration(days: _addedDay)).day,
                      _startTime.hour,
                      _startTime.minute);
                  var tzdatetime = tz.TZDateTime.from(
                      _dt, tz.local); //could be var instead of final

                  if (_dt.isAfter(DateTime.now())) {
                    if (_startTime.minute > 9) {
                      notificationsServices.sendScheduledNotifications2(
                          _notificationID,
                          "KiWi🥝",
                          "Time for " + k + " 😎",
                          // _startTime.hour.toString() +
                          //     ":" +
                          //     _startTime.minute.toString(),
                          tzdatetime);
                    } else {
                      notificationsServices.sendScheduledNotifications2(
                          _notificationID,
                          "KiWi🥝",
                          "Time for " + k + " 😎",
                          // _startTime.hour.toString() +
                          //     ":0" +
                          //     _startTime.minute.toString(),
                          tzdatetime);
                    }

                    _notificationID += 1;
                  }
                }
              }
            }
          });
        }
      }
    }

//alttaki alan db'de depolama ihtiyacı olursa diye tutuluyor

    // Map _notificationMap = {};
    // _notificationMap['NotificationID'] = _notificationID;
    // _notificationMap[_yourHabits[0]['habitName']] = [];

    // print(_yourHabits[0]['habitName']);
    // DateTime dt = DateTime.now()
    //     .add(Duration(seconds: 30)); //Or whatever DateTime you want
    // var tzdatetime =
    //     tz.TZDateTime.from(dt, tz.local); //could be var instead of final

    // print(tzdatetime);
    //alttaki alan db'de depolama ihtiyacı olursa diye tutuluyor
  }

  recalculateListWithAnimation() {
    _opacityAnimationDuration = 1;
    _opacityAnimation = 0;
    Future.delayed(const Duration(milliseconds: 250), () {
      _opacityAnimationDuration = 250;
      _opacityAnimation = 1;
      currentDayHabits();
    });
  }

  removeHabit() {
    setState(() {
      _editleme = false;
    });
    print("AAA");
    print(_yourHabits);
    setState(() {
      _yourHabits
          .removeWhere((item) => item['habitName'] == _slidingHeaderText);

      _habitDetails.removeWhere((key, value) => key == _slidingHeaderText);
      _habitDays.removeWhere((key, value) => key == _slidingHeaderText);
    });
    print("BBB");
    print(_yourHabits);
    print("001");
    box.put("chooseYourHabitsHive", _yourHabits);
    print("002");
    box.put("habitDetailsHive", _habitDetails);
    print("003");
    box.put("habitDays", _habitDays);

    recalculateListWithAnimation();

    Future.delayed(const Duration(milliseconds: 2500), () {
      notificaitonMap();
    });
  }

  removeHabitFromSlide(String _habitNameForSlide) {
    setState(() {
      _editleme = false;
    });
    print("AAA");
    print(_yourHabits);
    setState(() {
      _yourHabits
          .removeWhere((item) => item['habitName'] == _habitNameForSlide);

      _habitDetails.removeWhere((key, value) => key == _habitNameForSlide);
      _habitDays.removeWhere((key, value) => key == _habitNameForSlide);
    });
    print("BBB");
    print(_yourHabits);
    print("001");
    box.put("chooseYourHabitsHive", _yourHabits);
    print("002");
    box.put("habitDetailsHive", _habitDetails);
    print("003");
    box.put("habitDays", _habitDays);

    recalculateListWithAnimation();

    Future.delayed(const Duration(milliseconds: 2500), () {
      notificaitonMap();
    });
  }

  quickReminderFunction() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => QuickReminder()));
  }

  addNewHabitFunction() {
    // if (_yourHabits.length < 5) {
    print("Yeni habit oluşturabilirsiniz");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddNewHabit()));
    // } else {}
  }

  slidingCompletedProcess()
  //sliging ekranda habit editlemesi tamamlandıktan sonra ilgili parametreler yerine yazılır.
  {
    print('_sligingYourHabitAlltimes');
    print(_sligingYourHabitAlltimes);
    _yourHabits.removeWhere((item) => item['habitName'] == _slidingHeaderText);

    Map _editedHabitAdd = {};
    _editedHabitAdd['habitName'] = _slidingHeaderText;
    _editedHabitAdd['habitCategory'] = _slidingIconName;
    _editedHabitAdd['_weekDays'] = _slidingItemWeekDaysList;
    _editedHabitAdd['_allTimes'] = _sligingYourHabitAlltimes;
    _editedHabitAdd['_checkedBoxEveryday'] = _slidingCheckBoxEveryDay;
    // print(_editedHabitAdd);

    _yourHabits.add(_editedHabitAdd);

    //////////////////

    _habitDetails.removeWhere((key, value) => key == _slidingHeaderText);

    _habitDetails[_slidingHeaderText] = {};
    _habitDetails[_slidingHeaderText]['habitCategory'] = _slidingIconName;
    _habitDetails[_slidingHeaderText]['_allTimes'] = _sligingYourHabitAlltimes;

    ////////////////
    ///
    _habitDays.removeWhere((key, value) => key == _slidingHeaderText);
    List _tempListe = [];
    for (var _slidingItemWeekDaysListItem in _slidingItemWeekDaysList) {
      if (_slidingItemWeekDaysListItem['value']) {
        _tempListe.add(_slidingItemWeekDaysListItem['day'].toString());
      }
    }
    _habitDays[_slidingHeaderText] = _tempListe;
    print("1");
    box.put("chooseYourHabitsHive", _yourHabits);
    print("2");
    box.put("habitDetailsHive", _habitDetails);
    print("3");
    box.put("habitDays", _habitDays);

    recalculateListWithAnimation();

    Future.delayed(const Duration(milliseconds: 2500), () {
      notificaitonMap();
    });
  }

  Function listEquality = const DeepCollectionEquality.unordered().equals;
  transportDataFromOnPremToCloud()
  //onpremden clouda aktaran fonksiyon burası. Uygulama ilk açıldığında senkronizasyonu yapar. Eğer daha az aktarım yapılsın istenirse bu fonksyion başka yerlere taşınabilir.
  {
    if (_userInfo != null) {
      if (_userInfo['id'] != null) {
        // print("ALOOOOO $_habitDetails");
        if (_habitDetails.length > 0) {
          // print("000000000000");
          CloudDB().transportDataFromOnPremToCloud(_userInfo['id'], _yourHabits,
              _habitDetails, _habitDays, _habitDays, _finalCompleted);
        } else {
          // print("Burada eksikler var.....");
          box.put("chooseYourHabitsHive", _userInfo['yourHabits']);
          box.put("habitDetailsHive", _userInfo['habitDetails']);
          box.put("habitDays", _userInfo['habitDays']);
          box.put("completedHabits", _userInfo['completedHabits']);
          box.put("finalCompleted", _userInfo['finalCompleted']);

          setState(() {
            _yourHabits = _userInfo['yourHabits'];
            _habitDetails = _userInfo['habitDetails'];
            _habitDays = _userInfo['habitDays'];
            _habitDays = _userInfo['completedHabits'];
            _finalCompleted = _userInfo['finalCompleted'];
          });

          recalculateListWithAnimation();

          Future.delayed(const Duration(milliseconds: 2500), () {
            notificaitonMap();
          });

          // print("Burada eksikler var.....");
        }
      }
    }
  }

  getCurrentChooseYourHabits() async {
    _yourHabits = await box.get("chooseYourHabitsHive") ?? []; //eski
    _reminderMap =
        await box.get("reminderMapHive") ?? {999999: "startReminder"}; //eski
    _reminderDatesMap =
        await box.get("reminderDateMapHive") ?? {999999: DateTime.now()}; //eski
    _habitDetails = await box.get("habitDetailsHive") ?? [];
    _habitDays = await box.get("habitDays") ?? [];
    _completedHabits = await box.get("completedHabits") ?? {};

    _finalCompleted = await box.get("finalCompleted") ?? {};

    recalculateListWithAnimation();
    Future.delayed(const Duration(milliseconds: 2500), () {
      transportDataFromOnPremToCloud();
    });
  }

  returnFromCompletedHabitList(String _habitName) {
    setState(() {
      _completedHabits[DateFormat('dd MMMM yyyy')
              .format(days[_currentIndexCalendar])
              .toString()]
          .removeWhere((key, value) => key == _habitName);

      _finalCompleted[DateFormat('dd MMMM yyyy')
              .format(days[_currentIndexCalendar])
              .toString()]
          .removeWhere((key, value) => key == _habitName);
    });

    setState(() {
      _currentDayHabit.add(_habitName);
    });

    box.put("completedHabits", _completedHabits);
    box.put("finalCompleted", _finalCompleted);

    // _finalCompleted = copyDeepMap(_completedHabits);

    //print("Final Map'e klonlanıyorr");
  }

  completedHabits(String _habitName, Map _time) {
    //print('_completedHabits');
    //print(_completedHabits);
    if (_completedHabits[DateFormat('dd MMMM yyyy')
            .format(days[_currentIndexCalendar])
            .toString()] ==
        null) {
      _completedHabits[DateFormat('dd MMMM yyyy')
          .format(days[_currentIndexCalendar])
          .toString()] = {};
    }
    if (_completedHabits[DateFormat('dd MMMM yyyy')
            .format(days[_currentIndexCalendar])
            .toString()][_habitName] ==
        null) {
      _completedHabits[DateFormat('dd MMMM yyyy')
          .format(days[_currentIndexCalendar])
          .toString()][_habitName] = [];
    }
    setState(() {
      _completedHabits[DateFormat('dd MMMM yyyy')
              .format(days[_currentIndexCalendar])
              .toString()][_habitName]
          .add(_time);
    });

    if (_completedHabits[DateFormat('dd MMMM yyyy')
                .format(days[_currentIndexCalendar])
                .toString()][_habitName]
            .length ==
        _habitDetails[_habitName]['_allTimes'].length) {
      //print("Map finale Klonlanıyorrr");

      if (_finalCompleted[DateFormat('dd MMMM yyyy')
              .format(days[_currentIndexCalendar])
              .toString()] ==
          null) {
        _finalCompleted[DateFormat('dd MMMM yyyy')
            .format(days[_currentIndexCalendar])
            .toString()] = {};
      }
      if (_finalCompleted[DateFormat('dd MMMM yyyy')
              .format(days[_currentIndexCalendar])
              .toString()] ==
          null) {
        _finalCompleted[DateFormat('dd MMMM yyyy')
                .format(days[_currentIndexCalendar])
                .toString()] ==
            [];
      }

      _finalCompleted[DateFormat('dd MMMM yyyy')
              .format(days[_currentIndexCalendar])
              .toString()][_habitName] =
          copyDeepList(_completedHabits[DateFormat('dd MMMM yyyy')
              .format(days[_currentIndexCalendar])
              .toString()][_habitName]);
    }

    box.put("completedHabits", _completedHabits);
    box.put("finalCompleted", _finalCompleted);

    // //print('_completedHabits2');
    // //print(_completedHabits);

    compareCurrentAndCompleted();
  }

  editSingleHabit(String slidingHeaderText) {
    PlayAudio().play("baloncuk");
    int _habitCount = 0;
    for (var item in _yourHabits) {
      if (item['habitName'] == slidingHeaderText) {
        break;
      }
      _habitCount++;
    }

    setState(() {
      _slidingCheckBoxEveryDay =
          _yourHabits[_habitCount]['_checkedBoxEveryday'];
      _sligingYourHabitAlltimes = _yourHabits[_habitCount]['_allTimes'];
      _slidingItemWeekDaysList = _yourHabits[_habitCount]['_weekDays'];
      _slidingCountADay = _yourHabits[_habitCount]['_allTimes'].length;
      _slidingIcon = IconClass()
          .getIconFromName(_yourHabits[_habitCount]['habitCategory']);
      _slidingIconName = _yourHabits[_habitCount]['habitCategory'];
      _slidingHeaderText = slidingHeaderText;
    });

    _pc.open();
    // //print("EDİTLE");
  }

  remainHabitRepeat(String habitName) {
    int _totalLength = _habitDetails[habitName]['_allTimes'].length;
    int _completedLength = 0;

    if (_completedHabits[DateFormat('dd MMMM yyyy')
            .format(days[_currentIndexCalendar])
            .toString()] !=
        null) {
      if (_completedHabits[DateFormat('dd MMMM yyyy')
              .format(days[_currentIndexCalendar])
              .toString()][habitName] !=
          null) {
        _completedLength = _completedHabits[DateFormat('dd MMMM yyyy')
                .format(days[_currentIndexCalendar])
                .toString()][habitName]
            .length;
      }
    }

    return (_totalLength - _completedLength);
  }

  remainHabitTimeRepeat(String habitName) {
    int _totalLength = _habitDetails[habitName]['_allTimes'].length;
    int _completedLength = 0;

    if (_completedHabits[DateFormat('dd MMMM yyyy')
            .format(days[_currentIndexCalendar])
            .toString()] !=
        null) {
      if (_completedHabits[DateFormat('dd MMMM yyyy')
              .format(days[_currentIndexCalendar])
              .toString()][habitName] !=
          null) {
        _completedLength = _completedHabits[DateFormat('dd MMMM yyyy')
                .format(days[_currentIndexCalendar])
                .toString()][habitName]
            .length;
      }
    }

    return (_completedLength);
  }

  expandConfiguration() {
    _expand1 = _currentDayHabit.length;
    if (_finalCompleted[DateFormat('dd MMMM yyyy')
            .format(days[_currentIndexCalendar])
            .toString()] !=
        null) {
      _expand2 = _finalCompleted[DateFormat('dd MMMM yyyy')
              .format(days[_currentIndexCalendar])
              .toString()]
          .keys
          .toList()
          .length;
    }
  }

  compareCurrentAndCompleted() {
    // //print('_habitDetails');
    // //print(_habitDetails);

    List _willRemoveHabitNames = [];
    for (var habitName in _currentDayHabit) {
      if (_completedHabits[DateFormat('dd MMMM yyyy')
              .format(days[_currentIndexCalendar])
              .toString()] !=
          null) {
        if (_completedHabits[DateFormat('dd MMMM yyyy')
                .format(days[_currentIndexCalendar])
                .toString()][habitName] !=
            null) {
          if (_completedHabits[DateFormat('dd MMMM yyyy')
                      .format(days[_currentIndexCalendar])
                      .toString()][habitName]
                  .length ==
              _habitDetails[habitName]['_allTimes'].length) {
            //print("Habitin tüm tekrarları bitti, kaldırılabilir");

            _willRemoveHabitNames.add(habitName);
            // //print(_willRemoveHabitNames);
            //
          } else {
            //print("Henüz bu habitte yapılacak tekrar var...");
          }
        }
      }
    }
    if (_willRemoveHabitNames.length != 0) {
      for (var _willRemoveHabitName in _willRemoveHabitNames) {
        setState(() {
          _currentDayHabit.removeWhere((item) => item == _willRemoveHabitName);
        });
        // //print("$_willRemoveHabitName habitini kaldırıyorum.");
      }

      // recalculateListForCurrentListWithAnimation();
    }
  }

  currentDayHabits() {
    //habşt details {Swim: {habitCategory: Sport, _allTimes: [{time: TimeOfDay(12:30), notification: true, alarm: false}]}, Learn English: {habitCategory: Study, _allTimes: [{time: TimeOfDay(12:30), notification: true, alarm: false}]}, Painting: {habitCategory: Art, _allTimes: [{time: TimeOfDay(12:30), notification: true, alarm: false}]}}
    setState(() {
      _currentDayHabit = [];
      _habitDays.forEach((k, v) {
        if (DateTime.parse(DateFormat(
                    'yyyy-MM-dd', Localizations.localeOf(context).toString())
                .format(DateTime.parse(_userInfo['createTime'])))
            .add(Duration(seconds: -1))
            .isBefore(DateTime.parse(DateFormat(
                    'yyyy-MM-dd', Localizations.localeOf(context).toString())
                .format(DateTime.now().add(
                    Duration(days: _initialPage - _defaultinitialPage)))))) {
          if (v.contains(((DateTime.now().add(
                          Duration(days: _initialPage - _defaultinitialPage)))
                      .difference(DateTime(2000, 1, 3))
                      .inDays %
                  7)
              .toString())) {
            setState(() {
              _currentDayHabit.add(k);
            });
          }
        }
      });
    });
    compareCurrentAndCompleted();
    // //print("_currentDayHabit");
    // //print(_currentDayHabit);
  }

  // Future<void> _configureLocalTimeZone() async {
  //   tz.initializeTimeZones();

  //   final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
  //   tz.setLocalLocation(tz.getLocation(timeZoneName!));
  // }

  // _timeZoneTriggerFunction() async {
  //   await _configureLocalTimeZone();
  // }

  void listenToNotification() =>
      notificationsServices.onNotificationClick.stream
          .listen(onNotificationListener);

  void onNotificationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      //print('payload $payload');

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => BePremiumUser()));
    }
  }

  checkBatterySaverMode() async {
    if (!Platform.isIOS) {
      _batterySaver =
          await BatteryOptimization().isBatteryOptimizationDisabled();
    }
  }

  loginLogsAdd() {
    _loginLogs = box.get("loginLogsHive") ?? [];
    DateTime now = new DateTime.now();
    DateTime bugunSifirSifir = DateTime.parse(
        DateFormat('yyyy-MM-dd').format(DateTime.now()).toString());
    DateTime date = new DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);

    _loginLogs.add(date);

    print(_loginLogs.length);
    print(_loginLogs);
    box.put("loginLogsHive", _loginLogs);
    for (DateTime _loginLog in _loginLogs) {
      if (_loginLog.isBefore(bugunSifirSifir)) {
        // print(_loginLog);
        // print("yazılacak");
      }
    }
  }

  Timer? timer;
  @override
  void initState() {
    super.initState();

    checkBatterySaverMode();
    // notificaitonMap();
    listenToNotification(); //payload için
    // _timeZoneTriggerFunction();
    Future.delayed(const Duration(milliseconds: 2500), () {
      notificaitonMap();
    });

    notificationsServices.initialiseNotifications();
    calculateDaysInterval(DateTime.now().subtract(Duration(days: _initialPage)),
        DateTime.now().add(Duration(days: _initialPage)));

    box = Hive.box("kiwiHive");
    loginLogsAdd();
    getCurrentChooseYourHabits();
    versionInform();
  }

  copyDeepMap(map) {
    Map newMap = {};
    map.forEach((key, value) {
      newMap[key] = (value is Map) ? copyDeepMap(value) : value;
    });
    return newMap;
  }

  copyDeepList(list) {
    List newList = [];
    for (var item in list) {
      newList.add(item);
    }

    return newList;
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    if (Provider.of<QuerySnapshot> != null &&
        Provider.of<DocumentSnapshot> != null) {
      _userInfo = Provider.of<DocumentSnapshot>(context).data();

      _configsInfo = Provider.of<QuerySnapshot>(context);
      if (_userInfo != null) {
        if (_userInfo['userAuth'] == "Test") {
          _configsInfoInteger = 1;
        } else {
          _configsInfoInteger = 0;
        }
      } else {
        Future.delayed(const Duration(milliseconds: 500), () async {
          //print("IIIIIIIIIIIIIII");
          await _auth.signOut();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => IntroPage()),
              (Route<dynamic> route) => false);
        });
      }
    }

    return MaterialApp(
      home: Scaffold(
        drawer: Drawer(
            backgroundColor: _yaziTipiRengi,
            child: Container(
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(_todayText,
                            style: GoogleFonts.publicSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: _backgroudRengi)),
                        Column(
                          children: [
                            Text(
                                DateFormat(
                                        'EEEE',
                                        Localizations.localeOf(context)
                                            .toString())
                                    .format(DateTime.now())
                                    .toString(),
                                style: GoogleFonts.publicSans(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: _backgroudRengi)),
                            Text(
                                DateFormat(
                                        'dd MMMM yyyy',
                                        Localizations.localeOf(context)
                                            .toString())
                                    .format(DateTime.now())
                                    .toString(),
                                style: TextStyle(
                                  color: _backgroudRengi,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  // fontFamily: 'Times New Roman'
                                )),
                          ],
                        ),
                      ],
                    ),
                    currentAccountPicture: GestureDetector(
                        onTap: () {
                          // uploadImage();
                          // //profil fotosunun yenileneceği alan burası
                        },
                        child: Stack(
                          children: [
                            // CircleAvatar(
                            //   backgroundColor: Colors.transparent,
                            //   backgroundImage: _photo,
                            //   // child: ClipOval(
                            //   //   child: _photo,
                            //   // )
                            // ),
                            // Center(child: Icon(Icons.add_a_photo_rounded))
                          ],
                        )),
                    decoration: BoxDecoration(
                      color: _backgroudRengi,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage("assets/images/kapak.jpg")),
                    ),
                    accountEmail: null,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.important_devices),
                              title: InkWell(
                                onTap: () async {
                                  test();
                                },
                                child: Container(
                                  child: Text("Test",
                                      style: GoogleFonts.publicSans(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: _backgroudRengi)),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _configsInfo.docs[_configsInfoInteger]
                                  ['Analytics'],
                              child: ListTile(
                                leading: Icon(Icons.analytics),
                                title: InkWell(
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GraphicPage()));
                                  },
                                  child: Container(
                                    child: Text("Analytics",
                                        style: GoogleFonts.publicSans(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            color: _backgroudRengi)),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _configsInfo.docs[_configsInfoInteger]
                                  ['AudioTest'],
                              child: ListTile(
                                leading: Icon(Icons.voicemail),
                                title: InkWell(
                                  onTap: () async {
                                    FirebaseDocs().playAudio(
                                        _configsInfo.docs[_configsInfoInteger]
                                            ['AudioTestInfo']);
                                  },
                                  child: Container(
                                    child: Text("Audio Test",
                                        style: GoogleFonts.publicSans(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            color: _backgroudRengi)),
                                  ),
                                ),
                              ),
                            ),

                            _userInfo != null
                                ? _userInfo['userName'] == "Guest"
                                    ? ListTile(
                                        leading: Icon(Icons.person),
                                        title: InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            loginOptionsPopUp();
                                          },
                                          child: Container(
                                            child: Text(_signIn,
                                                style: GoogleFonts.publicSans(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                    color: _backgroudRengi)),
                                          ),
                                        ),
                                      )
                                    : ListTile(
                                        leading: CircleAvatar(
                                            backgroundColor:
                                                Colors.black.withOpacity(0),
                                            backgroundImage: NetworkImage(
                                                _userInfo['photoUrl'])),
                                        title: InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {},
                                          child: Container(
                                            child: Text(_userInfo['userName'],
                                                style: GoogleFonts.publicSans(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                    color: _backgroudRengi)),
                                          ),
                                        ),
                                      )
                                : SizedBox(),

                            // ListTile(
                            //   leading:
                            //       Icon(Icons.notification_important_rounded),
                            //   title: InkWell(
                            //     splashColor: Colors.transparent,
                            //     highlightColor: Colors.transparent,
                            //     onTap: () async {
                            //       //print(DateFormat('dd/MM/yyyy - HH:mm:ss')
                            //           .format(DateTime.now())
                            //           .toString());

                            //       // //print(_configsInfo.docs[_configsInfoInteger]
                            //       //     ['Social']);
                            //       // // //print(_todayText);
                            //       // // notificationsServices
                            //       // //     .specificTimeNotification(
                            //       // //         "KiWi🥝", "Yoga zamanı 💁", 0, 5);

                            //       // //////////BURASI ÖNEMLİ////////////
                            //       // notificationsServices.sendNotifications(
                            //       //     "KiWi🥝", "Yoga zamanı 💁");

                            //       // notificationsServices
                            //       //     .sendPayloadNotifications(
                            //       //         0,
                            //       //         "KiWi🥝",
                            //       //         "Premium ol 💁",
                            //       //         "payload navigationnnnn");
                            //       // DateTime dt = DateTime.now().add(Duration(
                            //       //     seconds:
                            //       //         5)); //Or whatever DateTime you want
                            //       // var tzdatetime = tz.TZDateTime.from(dt,
                            //       //     tz.local); //could be var instead of final
                            //       // // notificationsServices
                            //       // //     .sendScheduledNotifications2(
                            //       // //         0, "Swim", "20:05", tzdatetime);
                            //       // notificationsServices.stopNotifications();

                            //       //////////BURASI ÖNEMLİ////////////
                            //     },
                            //     child: Container(
                            //       child: Text("Notifications Test",
                            //           style: GoogleFonts.publicSans(
                            //               fontWeight: FontWeight.w600,
                            //               fontSize: 18,
                            //               color: _backgroudRengi)),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Version: " + version.toString(),
                                      style: GoogleFonts.publicSans(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: _backgroudRengi)),
                                  Text(_userInfo != null ? _userInfo['id'] : "",
                                      style: GoogleFonts.publicSans(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 8,
                                          color: _backgroudRengi))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
                              child: Column(
                                children: [
                                  _userInfo != null
                                      ? _userInfo['userName'] == "Guest"
                                          ? SizedBox()
                                          : ListTile(
                                              leading: Icon(Icons.delete),
                                              title: InkWell(
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  deleteAccount();
                                                },
                                                child: Container(
                                                  child: Text(_deleteAccount,
                                                      style: GoogleFonts.publicSans(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 18,
                                                          color:
                                                              _backgroudRengi)),
                                                ),
                                              ),
                                            )
                                      : SizedBox(),
                                  ListTile(
                                    leading: Icon(Icons.exit_to_app),
                                    title: InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        if (_userInfo['userName'] == "Guest") {
                                          askToLoginBeforeExit();
                                        } else {
                                          var a = await _authService
                                              .signOutAndDeleteUser(
                                                  _userInfo['id'],
                                                  _userInfo['registerType']);
                                          // await _auth.signOut();

                                          box.put("chooseYourHabitsHive", []);
                                          box.put("habitDetailsHive", []);
                                          box.put("habitDays", []);
                                          box.put("completedHabits", {});
                                          box.put("finalCompleted", {});
                                          box.put("loginLogsHive", []);
                                          box.put("reminderMapHive", {});
                                          box.put("reminderDateMapHive", {});

                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          CheckAuth()),
                                              (Route<dynamic> route) => false);

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CheckAuth()));
                                        }
                                      },
                                      child: Container(
                                        child: Text(_exitButton,
                                            style: GoogleFonts.publicSans(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                color: _backgroudRengi)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        appBar: AppBar(
          title: Text(
            (DateFormat('yyyy-MM-dd')
                        .format(days[_currentIndexCalendar])
                        .toString()) ==
                    (DateFormat('yyyy-MM-dd').format(DateTime.now()).toString())
                ? _todayText
                : DateFormat('dd MMMM yyyy',
                        Localizations.localeOf(context).toString())
                    .format(days[_currentIndexCalendar])
                    .toString(),
            style: GoogleFonts.publicSans(
                // fontWeight: FontWeight.bold,
                // fontSize: 15,
                color: _yaziTipiRengi),
          ),

          actions: <Widget>[
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Visibility(
                    visible: _defaultinitialPage != _initialPage,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.replay_circle_filled,
                              size: 30.00,
                              color: _yaziTipiRengi,
                            ),
                            onPressed: () async {
                              _pageController.jumpToPage(_defaultinitialPage);
                            },
                          ),
                          Text(
                            "Today",
                            style: GoogleFonts.publicSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                                color: _yaziTipiRengi),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.today,
                    size: 30.00,
                    color: _yaziTipiRengi,
                  ),
                  onPressed: () async {
                    DateTime? _selectedDate = await showDatePicker(
                        locale: Localizations.localeOf(context),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary:
                                    _backgroudRengi, // header background color
                                onPrimary: _yaziTipiRengi, // header text color
                                onSurface: Color.fromARGB(
                                    255, 20, 39, 20), // body text color
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
                        initialDate: DateTime.now().add(
                            Duration(days: _initialPage - _defaultinitialPage)),
                        firstDate: DateTime.now()
                            .subtract(Duration(days: _defaultinitialPage)),
                        lastDate: DateTime.now()
                            .add(Duration(days: _defaultinitialPage)));
                    // print(_selectedDate);
                    if (_selectedDate != null) {
                      var _difference = _selectedDate
                          .difference(DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day))
                          .inDays;

                      _pageController
                          .jumpToPage(_defaultinitialPage + _difference);
                      // _pageController.animateToPage(
                      //     _defaultinitialPage + _difference,
                      //     duration: Duration(milliseconds: 500),
                      //     curve: Curves.easeInCirc);
                    }
                  },
                ),
              ],
            )
          ],
          centerTitle: false,
          titleSpacing: 0.0,
          brightness: Brightness
              .dark, //uygulamanın üstündeki alanın(saat şarj gibi) beyaz yazı olmasını sağlıyor
          leading: (
                  //sol drawerın iconu
                  Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.list,
                color: Colors.green,
                size: 25,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
                // friendsRequestSayisiniOgren();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          )
              //sağ drawerın iconu
              ),
          // title: Center(child: Text("Farm Word")),
          flexibleSpace: Container(
              decoration: BoxDecoration(
                  // image: DecorationImage(
                  //   image: AssetImage("assets/images/kiwiLogo.png"),
                  //   // fit: BoxFit.cover,
                  // ),
                  gradient: LinearGradient(
            colors: [
              Color.fromRGBO(21, 9, 35, 1),
              Color.fromRGBO(21, 9, 35, 1),
            ],
          ))),
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Color.fromRGBO(21, 9, 35, 1),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    !Platform.isIOS
                        ? (Visibility(
                            visible: !_batterySaver,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 8),
                              child: Container(
                                height: 55,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(227, 74, 209, 79),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                              3 /
                                              4 -
                                          10,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 5, 10),
                                      child: Text(
                                        "For better notification timing please disable battery optimization for KiWi",
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.publicSans(
                                            // fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 4,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            child: RawMaterialButton(
                                              // fillColor: _yaziTipiRengi,
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: _backgroudRengi),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.0))),
                                              // splashColor: Colors.green,
                                              textStyle: TextStyle(
                                                  color: _yaziTipiRengi),
                                              child: Icon(
                                                Icons.check,
                                                size: 25,
                                                color: Colors.black,
                                              ),
                                              onPressed: () {
                                                BatteryOptimization()
                                                    .showDisableBatteryOptimizationSettings();
                                                setState(() {
                                                  _batterySaver = true;
                                                });
                                              },
                                            ),
                                          ),
                                          // InkWell(
                                          //   onTap: () {
                                          //     setState(() {
                                          //       _batterySaver = true;
                                          //     });
                                          //   },
                                          //   child: Icon(
                                          //     Icons.close,
                                          //     size: 35,
                                          //     color: Colors.white,
                                          //   ),
                                          // ),
                                          Container(
                                            height: 30,
                                            width: 30,
                                            child: RawMaterialButton(
                                              // fillColor: _yaziTipiRengi,
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: _backgroudRengi),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.0))),
                                              // splashColor: Colors.green,
                                              textStyle: TextStyle(
                                                  color: _yaziTipiRengi),
                                              child: Icon(
                                                Icons.close,
                                                size: 25,
                                                color: Colors.black,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _batterySaver = true;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))
                        : SizedBox(),
                    Container(
                      height: 54,
                      child: PageView(
                          controller: _pageController,
                          onPageChanged: (int index) => setState(() {
                                // //print(index);
                                _currentIndexCalendar = index;
                                _initialPage = index;
                                recalculateListWithAnimation();
                              }),
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                              days.length,
                              (index) => Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        // _pageController.jumpToPage(index);
                                        _pageController.animateToPage(index,
                                            duration:
                                                Duration(milliseconds: 250),
                                            curve: Curves.easeInCirc);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            // border: Border.all(
                                            //     color: Color.fromARGB(
                                            //         255, 212, 212, 212),width: 0.5),
                                            color: _initialPage != index
                                                ? Color.fromARGB(
                                                    255, 56, 24, 93)
                                                : Color.fromARGB(
                                                    255, 48, 135, 51),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 2, 0, 1),
                                              child: Text(
                                                days[index].day.toString(),
                                                style: GoogleFonts.publicSans(
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: _yaziTipiRengi),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 2, 0, 0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    color: _initialPage != index
                                                        ? Color.fromARGB(
                                                            255, 35, 3, 69)
                                                        : Color.fromARGB(
                                                            255, 32, 87, 34),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                        DateFormat(
                                                                'E',
                                                                Localizations
                                                                        .localeOf(
                                                                            context)
                                                                    .toString())
                                                            .format(days[index])
                                                            .toString(),
                                                        style: days[index]
                                                                    .toString() ==
                                                                DateFormat(
                                                                        'yyyy-MM-dd 00:00:00.000')
                                                                    .format(
                                                                        DateTime
                                                                            .now())
                                                                    .toString()
                                                            ? GoogleFonts
                                                                .publicSans(
                                                                shadows: [
                                                                  Shadow(
                                                                      color:
                                                                          _yaziTipiRengi,
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              -2))
                                                                ],
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .transparent,
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                decorationThickness:
                                                                    3,
                                                                decorationColor:
                                                                    _yaziTipiRengi,
                                                              )
                                                            : GoogleFonts.publicSans(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12,
                                                                color:
                                                                    _yaziTipiRengi)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))),
                    ),
                    Container(
                      height: _tempWillDelete.length * 48 + 5,
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: ListView.builder(
                          itemCount: _tempWillDelete.length,
                          itemBuilder: (context, indexOfNotification) {
                            return AnimatedOpacity(
                              duration: Duration(
                                  milliseconds: _opacityAnimationDuration),
                              opacity: _opacityAnimation,
                              child: Slidable(
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.2,
                                secondaryActions: [
                                  // IconSlideAction(
                                  //     caption: "Edit",
                                  //     icon: Icons.edit,
                                  //     onTap: () {}),
                                  IconSlideAction(
                                      caption: "Delete",
                                      icon: Icons.delete,
                                      onTap: () {})
                                ],
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 50),
                                    child: RawMaterialButton(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.green,
                                        fillColor:
                                            Color.fromARGB(255, 37, 107, 16),
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.0))),
                                        // splashColor: Colors.green,
                                        textStyle:
                                            TextStyle(color: _yaziTipiRengi),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 8, 15, 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(5, 0, 0, 0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            _tempWillDelete[
                                                                indexOfNotification],
                                                            style: GoogleFonts
                                                                .publicSans(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        15,
                                                                    color:
                                                                        _yaziTipiRengi)),
                                                        // Text(remainHabitTimeRepeat(
                                                        //         _currentDayHabit[
                                                        //             indexOfCurrentDayHabit])
                                                        //     .toString()),
                                                        Text(
                                                          "BB",
                                                          style: GoogleFonts
                                                              .publicSans(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 10,
                                                                  color: _yaziTipiRengi
                                                                      .withOpacity(
                                                                          0.6)),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                    color: _yaziTipiRengi,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Icon(
                                                  Icons.flash_on,
                                                  // size: 35,
                                                  color: Color.fromARGB(
                                                      255, 35, 4, 71),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onLongPress: () {},
                                        onPressed: () {}),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          // Swiping in right direction.
                          if (details.delta.dx > 0) {
                            _pageController.animateToPage(_initialPage - 1,
                                duration: Duration(milliseconds: 250),
                                curve: Curves.easeInCirc);
                          }

                          // Swiping in left direction.
                          if (details.delta.dx < 0) {
                            _pageController.animateToPage(_initialPage + 1,
                                duration: Duration(milliseconds: 250),
                                curve: Curves.easeInCirc);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: ListView.builder(
                              itemCount: _currentDayHabit.length,
                              itemBuilder: (context, indexOfCurrentDayHabit) {
                                // //print(_kaydirmaNoktalari);
                                return AnimatedOpacity(
                                  duration: Duration(
                                      milliseconds: _opacityAnimationDuration),
                                  opacity: _opacityAnimation,
                                  child: Slidable(
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.2,
                                    secondaryActions: [
                                      IconSlideAction(
                                          caption: "Edit",
                                          icon: Icons.edit,
                                          onTap: () {
                                            editSingleHabit(
                                              _currentDayHabit[
                                                  indexOfCurrentDayHabit],
                                            );
                                          }),
                                      IconSlideAction(
                                          caption: "Delete",
                                          icon: Icons.delete,
                                          onTap: () {
                                            removeHabitFromSlide(
                                                _currentDayHabit[
                                                    indexOfCurrentDayHabit]);
                                          })
                                    ],
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 50),
                                        child: RawMaterialButton(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.green,
                                            fillColor: _isButtonPressedID ==
                                                    indexOfCurrentDayHabit
                                                ? _isButtonPressed == false
                                                    ? Color.fromARGB(
                                                        255, 40, 25, 56)
                                                    : Color.fromARGB(
                                                        255, 75, 47, 105)
                                                : Color.fromARGB(
                                                    255, 40, 25, 56),
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15.0))),
                                            // splashColor: Colors.green,
                                            textStyle: TextStyle(
                                                color: _yaziTipiRengi),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 8, 15, 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      _habitDetails[_currentDayHabit[
                                                                  indexOfCurrentDayHabit]] !=
                                                              null
                                                          ? _icons[_habitDetails[
                                                                  _currentDayHabit[
                                                                      indexOfCurrentDayHabit]]
                                                              ['habitCategory']]
                                                          : SizedBox(),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                5, 0, 0, 0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                _currentDayHabit[
                                                                    indexOfCurrentDayHabit],
                                                                style: GoogleFonts.publicSans(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        15,
                                                                    color:
                                                                        _yaziTipiRengi)),
                                                            // Text(remainHabitTimeRepeat(
                                                            //         _currentDayHabit[
                                                            //             indexOfCurrentDayHabit])
                                                            //     .toString()),
                                                            Text(
                                                              _habitDetails[_currentDayHabit[
                                                                              indexOfCurrentDayHabit]]
                                                                          [
                                                                          '_allTimes']
                                                                      [
                                                                      remainHabitTimeRepeat(
                                                                          _currentDayHabit[
                                                                              indexOfCurrentDayHabit])]['time']
                                                                  .split('(')[1]
                                                                  .split(')')[0],
                                                              style: GoogleFonts.publicSans(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 10,
                                                                  color: _yaziTipiRengi
                                                                      .withOpacity(
                                                                          0.6)),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Visibility(
                                                        visible: (_habitDetails[
                                                                            _currentDayHabit[indexOfCurrentDayHabit]]
                                                                        [
                                                                        '_allTimes']
                                                                    .length -
                                                                remainHabitRepeat(
                                                                    _currentDayHabit[
                                                                        indexOfCurrentDayHabit])) >
                                                            0,
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      5),
                                                          // width: 50,
                                                          height: 16,
                                                          decoration: BoxDecoration(
                                                              color: Color
                                                                  .fromARGB(
                                                                      137,
                                                                      28,
                                                                      192,
                                                                      31),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                  (_habitDetails[_currentDayHabit[indexOfCurrentDayHabit]]['_allTimes'].length -
                                                                          remainHabitRepeat(_currentDayHabit[
                                                                              indexOfCurrentDayHabit]))
                                                                      .toString(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: GoogleFonts.publicSans(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          14,
                                                                      color:
                                                                          _yaziTipiRengi)),
                                                              Icon(
                                                                Icons.check,
                                                                size: 14,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Container(
                                                        width: 20,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            color: Colors.amber,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Text(

                                                            ////TEST
                                                            remainHabitRepeat(
                                                                    _currentDayHabit[
                                                                        indexOfCurrentDayHabit])
                                                                .toString()
                                                            // _habitDetails[_currentDayHabit[
                                                            //             indexOfCurrentDayHabit]]
                                                            //         ['_allTimes']
                                                            //     .length
                                                            //     .toString()

                                                            ,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .publicSans(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16,
                                                                    color:
                                                                        _backgroudRengi)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            onLongPress: () {
                                              editSingleHabit(
                                                _currentDayHabit[
                                                    indexOfCurrentDayHabit],
                                              );
                                            },
                                            onPressed:
                                                !DateTime.parse(DateFormat('yyyy-MM-dd').format(days[_currentIndexCalendar]).toString())
                                                        .isAfter(DateTime.parse(
                                                            DateFormat('yyyy-MM-dd')
                                                                .format(
                                                                    DateTime.now())
                                                                .toString()))
                                                    ? () {
                                                        ////// Today veya önceki günlerde butona basılırsa çalışsın. Gelecek günlerde butona basılırsa çalışmasın çünkü henüz o günün habit'i yapılmadı.
                                                        if (!DateTime.parse(DateFormat(
                                                                    'yyyy-MM-dd')
                                                                .format(days[
                                                                    _currentIndexCalendar])
                                                                .toString())
                                                            .isAfter(DateTime
                                                                .parse(DateFormat(
                                                                        'yyyy-MM-dd')
                                                                    .format(
                                                                        DateTime
                                                                            .now())
                                                                    .toString()))) {
                                                          if (_completedHabits[DateFormat(
                                                                      'dd MMMM yyyy')
                                                                  .format(days[
                                                                      _currentIndexCalendar])
                                                                  .toString()] !=
                                                              null) {
                                                            PlayAudio()
                                                                .play("tik");
                                                            // //print(_habitDetails[_currentDayHabit[
                                                            //         indexOfCurrentDayHabit]]
                                                            //     ['_allTimes'][_completedHabits[
                                                            //         DateFormat('dd MMMM yyyy')
                                                            //             .format(days[
                                                            //                 _currentIndexCalendar])
                                                            //             .toString()][_currentDayHabit[
                                                            //         indexOfCurrentDayHabit]]
                                                            //     .length]);

                                                            //ilginç sorun
                                                            if (_completedHabits[
                                                                    DateFormat(
                                                                            'dd MMMM yyyy')
                                                                        .format(days[
                                                                            _currentIndexCalendar])
                                                                        .toString()][_currentDayHabit[
                                                                    indexOfCurrentDayHabit]] !=
                                                                null) {
                                                              isButtonPressedCheck(
                                                                  indexOfCurrentDayHabit);
                                                              completedHabits(
                                                                  _currentDayHabit[
                                                                      indexOfCurrentDayHabit],
                                                                  _habitDetails[
                                                                          _currentDayHabit[
                                                                              indexOfCurrentDayHabit]]
                                                                      [
                                                                      '_allTimes'][_completedHabits[DateFormat(
                                                                              'dd MMMM yyyy')
                                                                          .format(
                                                                              days[_currentIndexCalendar])
                                                                          .toString()][_currentDayHabit[indexOfCurrentDayHabit]]
                                                                      .length]);
                                                            } else {
                                                              isButtonPressedCheck(
                                                                  indexOfCurrentDayHabit);
                                                              completedHabits(
                                                                  _currentDayHabit[
                                                                      indexOfCurrentDayHabit],
                                                                  _habitDetails[
                                                                          _currentDayHabit[
                                                                              indexOfCurrentDayHabit]]
                                                                      [
                                                                      '_allTimes'][0]);
                                                            }
                                                          } else {
                                                            isButtonPressedCheck(
                                                                indexOfCurrentDayHabit);
                                                            // print(
                                                            //     "null bir değerdi");
                                                            completedHabits(
                                                                _currentDayHabit[
                                                                    indexOfCurrentDayHabit],
                                                                _habitDetails[
                                                                        _currentDayHabit[
                                                                            indexOfCurrentDayHabit]]
                                                                    [
                                                                    '_allTimes'][0]);
                                                          }
                                                        } else {
                                                          print("yapma");
                                                        }

                                                        ///////////////////////**************/////////////////////// */
                                                      }
                                                    : null),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Container(
                        // width:
                        //     MediaQuery.of(context).size.width *
                        //         3 /
                        //         5,
                        // height: 200,
                        // width: 50,

                        child: ListView.builder(
                            itemCount: _finalCompleted[
                                        DateFormat('dd MMMM yyyy')
                                            .format(days[_currentIndexCalendar])
                                            .toString()] !=
                                    null
                                ? _finalCompleted[DateFormat('dd MMMM yyyy')
                                        .format(days[_currentIndexCalendar])
                                        .toString()]
                                    .keys
                                    .toList()
                                    .length
                                : 0,
                            shrinkWrap: true,
                            reverse: true,
                            itemBuilder: (context, indexOffinalCompletedHabit) {
                              // print(_kaydirmaNoktalari);
                              return AnimatedOpacity(
                                duration: Duration(
                                    milliseconds: _opacityAnimationDuration),
                                opacity: _opacityAnimation,
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: RawMaterialButton(
                                      fillColor:
                                          Color.fromARGB(90, 54, 151, 42),
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0))),
                                      // splashColor: Colors.green,
                                      textStyle:
                                          TextStyle(color: _yaziTipiRengi),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 10, 15, 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          5, 0, 0, 0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(_finalCompleted[DateFormat(
                                                                  'dd MMMM yyyy')
                                                              .format(days[
                                                                  _currentIndexCalendar])
                                                              .toString()]
                                                          .keys
                                                          .toList()[
                                                              indexOffinalCompletedHabit]
                                                          .toString()),

                                                      // Text(" x" +
                                                      //     _completedHabits[DateFormat(
                                                      //                 'dd MMMM yyyy')
                                                      //             .format(days[
                                                      //                 _currentIndexCalendar])
                                                      //             .toString()][_completedHabits[DateFormat(
                                                      //                     'dd MMMM yyyy')
                                                      //                 .format(days[
                                                      //                     _currentIndexCalendar])
                                                      //                 .toString()]
                                                      //             .keys
                                                      //             .toList()[indexOffinalCompletedHabit]]
                                                      //         .length
                                                      //         .toString())
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () {
                                                // print(_currentDayCompletedHabits);
                                                // print("****");
                                              },
                                              child: Container(
                                                child: Icon(
                                                  Icons.check,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        223, 18, 218, 7),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onLongPress: () {
                                        editSingleHabit(_finalCompleted[
                                                DateFormat('dd MMMM yyyy')
                                                    .format(days[
                                                        _currentIndexCalendar])
                                                    .toString()]
                                            .keys
                                            .toList()[
                                                indexOffinalCompletedHabit]
                                            .toString());
                                      },
                                      onPressed: () {
                                        returnFromCompletedHabitList(
                                            _finalCompleted[DateFormat(
                                                        'dd MMMM yyyy')
                                                    .format(days[
                                                        _currentIndexCalendar])
                                                    .toString()]
                                                .keys
                                                .toList()[
                                                    indexOffinalCompletedHabit]
                                                .toString());
                                      }),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 35,
                bottom: 150,
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    quickReminderFunction();
                    // test();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                            center: Alignment(-.5, -.5),
                            colors: [
                              Color.fromARGB(255, 219, 232, 215),
                              Color.fromARGB(255, 199, 229, 190),
                              Color.fromARGB(255, 178, 232, 161),
                              Color.fromARGB(255, 119, 184, 99),
                              Color.fromARGB(255, 57, 122, 37),
                            ],
                            radius: .7),
                        // color: Color(0xffCFFFDC),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black38,
                              offset: Offset(5, 5),
                              spreadRadius: 1,
                              blurRadius: 10)
                        ],
                        // borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                      width: 60,
                      height: 60,
                      child: Stack(
                        children: [
                          // Visibility(
                          //   visible: _yourHabits.length >= 5,
                          //   child: Align(
                          //     alignment: Alignment.topRight,
                          //     child: Icon(
                          //       Icons.lock,
                          //       size: 25,
                          //       color: Color.fromARGB(255, 149, 149, 149),
                          //     ),
                          //   ),
                          // ),
                          Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.flash_on,
                              size: 35,
                              color: Color.fromARGB(255, 35, 4, 71),
                            ),
                          ),
                        ],
                      )
                      // IconTheme(
                      //   data: new IconThemeData(color: Color(0xff542e71)),
                      //   child: Icon(
                      //     Icons.sports_esports,
                      //     size: 50,
                      //   ),
                      // ),
                      ),
                ),
              ),
              Positioned(
                right: 35,
                bottom: 30,
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    addNewHabitFunction();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                            center: Alignment(-.5, -.5),
                            colors: [
                              Color.fromARGB(255, 191, 179, 206),
                              Color.fromARGB(255, 159, 140, 181),
                              Color.fromARGB(255, 134, 107, 165),
                              Color.fromARGB(255, 99, 74, 127),
                              Color.fromARGB(255, 67, 45, 93),
                            ],
                            radius: .7),
                        // color: Color(0xffCFFFDC),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black38,
                              offset: Offset(5, 5),
                              spreadRadius: 1,
                              blurRadius: 10)
                        ],
                        // borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                      width: 60,
                      height: 60,
                      child: Stack(
                        children: [
                          // Visibility(
                          //   visible: _yourHabits.length >= 5,
                          //   child: Align(
                          //     alignment: Alignment.topRight,
                          //     child: Icon(
                          //       Icons.lock,
                          //       size: 25,
                          //       color: Color.fromARGB(255, 149, 149, 149),
                          //     ),
                          //   ),
                          // ),
                          Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.add,
                              size: 35,
                              color: Color.fromARGB(255, 35, 4, 71),
                            ),
                          ),
                        ],
                      )
                      // IconTheme(
                      //   data: new IconThemeData(color: Color(0xff542e71)),
                      //   child: Icon(
                      //     Icons.sports_esports,
                      //     size: 50,
                      //   ),
                      // ),
                      ),
                ),
              ),
              SlidingUpPanel(
                onPanelSlide: (double pos) {
                  if (pos == 0.0) {
                    setState(() {
                      _bottomNavigatorShow = true;
                    });
                    if (_editleme) {
                      slidingCompletedProcess();
                    } else {
                      setState(() {
                        _editleme = true;
                      });
                    }
                  } else {
                    setState(() {
                      _bottomNavigatorShow = false;
                    });
                  }
                },

                // onPanelClosed: slidingCompletedProcess(),
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0)),
                controller: _pc,
                backdropEnabled: true,
                maxHeight: MediaQuery.of(context).size.height / 2,
                minHeight: 0,
                header: Container(
                  color: Color(0xff150923),
                  padding: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width - 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _slidingIcon,
                          SizedBox(
                            width: 5,
                          ),
                          Text(_slidingHeaderText,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.publicSans(
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: _yaziTipiRengi)),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                _editleme = false;
                              });
                              _pc.close();
                            },
                            child: Text(_cancelButton,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 138, 24, 16),
                                  fontSize: 12,
                                  fontFamily: 'Times New Roman',
                                  // fontWeight: FontWeight.bold
                                )),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              slidingCompletedProcess();
                              _pc.close();
                            },
                            child: Icon(
                              Icons.check,
                              size: 30,
                              color: Color(0xff77A830),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                panel: Container(
                  padding: const EdgeInsets.fromLTRB(0, 48, 0, 0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 27, 7, 50),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.0),
                        topRight: Radius.circular(24.0)),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                          child: Column(
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              //   child: Align(
                              //     alignment: Alignment.centerLeft,
                              //     child: Text(
                              //       "Goal",
                              //       style: TextStyle(
                              //         decoration: TextDecoration.underline,
                              //         color: _yaziTipiRengi,
                              //         fontSize: 25,
                              //         fontWeight: FontWeight.bold,
                              //         fontFamily: 'Times New Roman',
                              //         // fontWeight: FontWeight.bold
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Row(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            0,
                                            0,
                                            4,
                                            0,
                                          ),
                                          child: SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: RawMaterialButton(
                                                fillColor: _slidingCountADay > 1
                                                    ? Color(0xff996B3E)
                                                    : Color.fromARGB(
                                                        86, 153, 107, 62),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15.0))),
                                                splashColor: Color(0xff77A830),
                                                textStyle: TextStyle(
                                                    color: Colors.white),
                                                child: Text("-",
                                                    style: TextStyle(
                                                      color: _yaziTipiRengi,
                                                      fontSize: 15,
                                                      fontFamily:
                                                          'Times New Roman',
                                                      // fontWeight: FontWeight.bold
                                                    )),
                                                onPressed:
                                                    _slidingCountADay <= 1
                                                        ? null
                                                        : () {
                                                            if (_slidingCountADay >
                                                                1) {
                                                              setState(() {
                                                                _slidingCountADay--;

                                                                _sligingYourHabitAlltimes
                                                                    .removeLast();
                                                              });
                                                            }
                                                          }),
                                          ),
                                        ),
                                        Container(
                                          width: 45,
                                          padding:
                                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                                          decoration: BoxDecoration(
                                              // color: Color(0xff77A830),
                                              // border: Border.all(
                                              //     color:
                                              //         Color(0xff77A830)),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Text(
                                              _slidingCountADay.toString(),
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.publicSans(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                  color: _yaziTipiRengi)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            4,
                                            0,
                                            0,
                                            0,
                                          ),
                                          child: SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: RawMaterialButton(
                                                fillColor: Color(0xff996B3E),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15.0))),
                                                splashColor: Color(0xff77A830),
                                                textStyle: TextStyle(
                                                    color: Colors.white),
                                                child: Text("+",
                                                    style: TextStyle(
                                                      color: _yaziTipiRengi,
                                                      fontSize: 15,
                                                      fontFamily:
                                                          'Times New Roman',
                                                      // fontWeight: FontWeight.bold
                                                    )),
                                                onPressed: () {
                                                  setState(() {
                                                    _slidingCountADay++;

                                                    _sligingYourHabitAlltimes
                                                        .add({
                                                      "time": TimeOfDay(
                                                              hour: _slidingCountADay <
                                                                      12
                                                                  ? 12 +
                                                                      _slidingCountADay -
                                                                      1
                                                                  : (12 +
                                                                          _slidingCountADay -
                                                                          1) %
                                                                      24,
                                                              minute: 30)
                                                          .toString(),
                                                      "notification": true,
                                                      "alarm": false
                                                    });
                                                  });
                                                }),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(_inADayText,
                                        style: GoogleFonts.publicSans(
                                            // fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: _yaziTipiRengi))
                                  ],
                                ),
                              ),
                              Row(
                                children:
                                    _slidingItemWeekDaysList.map<Widget>((day) {
                                  return Container(
                                    padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                                    width:
                                        MediaQuery.of(context).size.width / 9,
                                    height:
                                        MediaQuery.of(context).size.width / 11,
                                    child: RawMaterialButton(
                                        fillColor: day['value']
                                            ? Colors.green
                                            : _yaziTipiRengi,
                                        shape: const RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 134, 85, 36),
                                                width: 3),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        splashColor: Colors.green,
                                        textStyle:
                                            TextStyle(color: _yaziTipiRengi),
                                        child: Text(
                                            DateFormat(
                                                    'E',
                                                    Localizations.localeOf(context)
                                                        .toString())
                                                .format(DateTime(2000, 1, 3)
                                                    .add(Duration(days: int.parse(day['day'])))),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.publicSans(fontWeight: FontWeight.w600, fontSize: 12, color: Color.fromRGBO(21, 9, 35, 1))),
                                        onPressed: () async {
                                          int _daySelected = 0;
                                          for (var _weekDay
                                              in _slidingItemWeekDaysList) {
                                            if (_weekDay['value']) {
                                              _daySelected += 1;
                                            }
                                          }
                                          if (_daySelected > 1) {
                                            bool _allDaysSelected = true;
                                            setState(() {
                                              day['value'] = !day['value'];
                                            });
                                            for (var _weekDay
                                                in _slidingItemWeekDaysList) {
                                              if (!_weekDay['value']) {
                                                _allDaysSelected = false;
                                              }
                                            }
                                            if (_allDaysSelected) {
                                              // _checkedBoxEveryday = true;
                                              _slidingCheckBoxEveryDay = true;
                                            } else {
                                              _slidingCheckBoxEveryDay = false;
                                              // _checkedBoxEveryday = false;
                                            }
                                          } else {
                                            if (!day['value'] == true) {
                                              bool _allDaysSelected = true;
                                              setState(() {
                                                day['value'] = !day['value'];
                                              });
                                              for (var _weekDay
                                                  in _slidingItemWeekDaysList) {
                                                if (!_weekDay['value']) {
                                                  _allDaysSelected = false;
                                                }
                                              }
                                              if (_allDaysSelected) {
                                                _slidingCheckBoxEveryDay = true;
                                                // _checkedBoxEveryday =
                                                //     true;
                                              } else {
                                                _slidingCheckBoxEveryDay =
                                                    false;
                                                // _checkedBoxEveryday =
                                                //     false;
                                              }
                                            }
                                          }
                                        }),
                                  );
                                }).toList(),
                              ),
                              Theme(
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
                                    _everyDay,
                                    style: GoogleFonts.publicSans(
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: _yaziTipiRengi),
                                  ),
                                  value: _slidingCheckBoxEveryDay,
                                  onChanged: (val) {
                                    if (!_slidingCheckBoxEveryDay) {
                                      setState(() {
                                        _slidingCheckBoxEveryDay = true;
                                        for (var day
                                            in _slidingItemWeekDaysList) {
                                          setState(() {
                                            day['value'] = true;
                                          });
                                        }
                                      });
                                    }
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                              ),
                              // CheckboxListTile(
                              //   side: BorderSide(
                              //       color: Color(0xff996B3E), width: 1),
                              //   activeColor: Color(0xff77A830),
                              //   // tileColor: Color(0xff996B3E),
                              //   checkColor: _yaziTipiRengi,
                              //   contentPadding: EdgeInsets.zero,
                              //   visualDensity:
                              //       VisualDensity(horizontal: -4),
                              //   dense: true,
                              //   title: Text(
                              //     "Alarm",
                              //     style: TextStyle(
                              //       color: _yaziTipiRengi,
                              //       fontSize: 15,
                              //       fontFamily: 'Times New Roman',
                              //     ),
                              //   ),
                              //   value: _checkedBoxAlarm,
                              //   onChanged: (val) {
                              //     setState(() {
                              //       _checkedBoxAlarm = val!;
                              //     });
                              //   },
                              //   controlAffinity:
                              //       ListTileControlAffinity.leading,
                              // ),
                              Expanded(
                                child: Container(
                                  // width:
                                  //     MediaQuery.of(context).size.width *
                                  //         3 /
                                  //         5,
                                  height: 200,
                                  // width: 50,

                                  child: ListView.builder(
                                      itemCount:
                                          _sligingYourHabitAlltimes.length,
                                      itemBuilder: (context, index2) {
                                        // print(_kaydirmaNoktalari);
                                        return Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          child: RawMaterialButton(
                                              // fillColor: _yaziTipiRengi,
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: _yaziTipiRengi),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.0))),
                                              // splashColor: Colors.green,
                                              textStyle: TextStyle(
                                                  color: _yaziTipiRengi),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 5, 15, 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        _goalText +
                                                            " " +
                                                            (index2 + 1)
                                                                .toString(),
                                                        style: GoogleFonts
                                                            .publicSans(
                                                                // fontWeight: FontWeight.bold,
                                                                fontSize: 15,
                                                                color:
                                                                    _yaziTipiRengi)),
                                                    Row(
                                                      children: [
                                                        InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () {
                                                            setState(() {
                                                              _sligingYourHabitAlltimes[
                                                                          index2]
                                                                      [
                                                                      'alarm'] =
                                                                  !_sligingYourHabitAlltimes[
                                                                          index2]
                                                                      ['alarm'];
                                                            });

                                                            if (_sligingYourHabitAlltimes[
                                                                    index2]
                                                                ['alarm']) {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .hideCurrentSnackBar();
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          2000),
                                                                  content: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text('Alarm enabled for ' +
                                                                          "Goal " +
                                                                          (index2 + 1)
                                                                              .toString()),
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
                                                            } else {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .hideCurrentSnackBar();
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          2000),
                                                                  content: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text('Alarm disabled for ' +
                                                                          "Goal " +
                                                                          (index2 + 1)
                                                                              .toString()),
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
                                                          },
                                                          child: Icon(
                                                            _sligingYourHabitAlltimes[
                                                                        index2]
                                                                    ['alarm']
                                                                ? Icons.alarm_on
                                                                : Icons
                                                                    .alarm_off,
                                                            size: 25,
                                                            color: _sligingYourHabitAlltimes[
                                                                        index2]
                                                                    ['alarm']
                                                                ? Color(
                                                                    0xff77A830)
                                                                : _yaziTipiRengi,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () {
                                                            setState(() {
                                                              _sligingYourHabitAlltimes[
                                                                          index2]
                                                                      [
                                                                      'notification'] =
                                                                  !_sligingYourHabitAlltimes[
                                                                          index2]
                                                                      [
                                                                      'notification'];
                                                            });

                                                            if (_sligingYourHabitAlltimes[
                                                                    index2][
                                                                'notification']) {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .hideCurrentSnackBar();
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          2000),
                                                                  content: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text('Notification enabled for ' +
                                                                          "Goal " +
                                                                          (index2 + 1)
                                                                              .toString()),
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
                                                            } else {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .hideCurrentSnackBar();
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          2000),
                                                                  content: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text('Notification disabled for ' +
                                                                          "Goal " +
                                                                          (index2 + 1)
                                                                              .toString()),
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
                                                          },
                                                          child: Icon(
                                                            _sligingYourHabitAlltimes[
                                                                        index2][
                                                                    'notification']
                                                                ? Icons
                                                                    .notifications_active
                                                                : Icons
                                                                    .notifications_off,
                                                            size: 25,
                                                            color: _sligingYourHabitAlltimes[
                                                                        index2][
                                                                    'notification']
                                                                ? Color(
                                                                    0xff77A830)
                                                                : _yaziTipiRengi,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            TimeOfDay? newTime =
                                                                await showTimePicker(
                                                              context: context,
                                                              initialTime: TimeOfDay(
                                                                  hour: int.parse(_sligingYourHabitAlltimes[index2]['time']
                                                                          .toString()
                                                                          .split("(")[
                                                                              1]
                                                                          .split(")")[
                                                                              0]
                                                                          .split(":")[
                                                                      0]),
                                                                  minute: int.parse(_sligingYourHabitAlltimes[index2]
                                                                          [
                                                                          'time']
                                                                      .toString()
                                                                      .split(
                                                                          "(")[1]
                                                                      .split(")")[0]
                                                                      .split(":")[1])),
                                                              builder: (context,
                                                                  child) {
                                                                return MediaQuery(
                                                                  data: MediaQuery.of(
                                                                          context)
                                                                      .copyWith(
                                                                          alwaysUse24HourFormat:
                                                                              true),
                                                                  child: child ??
                                                                      Container(),
                                                                );
                                                              },
                                                            );
                                                            if (newTime == null)
                                                              return;
                                                            else {
                                                              if (newTime
                                                                      .minute <
                                                                  10) {
                                                                newTime = TimeOfDay(
                                                                    hour: newTime
                                                                        .hour,
                                                                    minute: int.parse("0" +
                                                                        newTime
                                                                            .minute
                                                                            .toString()));
                                                                // print(newTime);
                                                              }

                                                              setState(() {
                                                                _sligingYourHabitAlltimes[
                                                                            index2]
                                                                        [
                                                                        'time'] =
                                                                    newTime
                                                                        .toString();
                                                              });
                                                            }
                                                          },
                                                          child: Text(
                                                              _sligingYourHabitAlltimes[index2]
                                                                          [
                                                                          'time']
                                                                      .toString()
                                                                      .split("(")[
                                                                          1]
                                                                      .split(")")[
                                                                          0]
                                                                      .split(":")[
                                                                          0]
                                                                      .toString() +
                                                                  ":" +
                                                                  _sligingYourHabitAlltimes[index2]
                                                                          [
                                                                          'time']
                                                                      .toString()
                                                                      .split("(")[
                                                                          1]
                                                                      .split(")")[
                                                                          0]
                                                                      .split(":")[
                                                                          1]
                                                                      .toString(),
                                                              style: GoogleFonts
                                                                  .publicSans(
                                                                      // fontWeight: FontWeight.bold,
                                                                      fontSize:
                                                                          25,
                                                                      color:
                                                                          _yaziTipiRengi)),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onPressed: null),
                                        );
                                      }),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 3 / 5,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(62, 138, 24, 16),
                                      border: Border.all(
                                          color:
                                              Color.fromARGB(255, 138, 24, 16)),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      removeHabit();
                                      _pc.close();
                                    },
                                    child: Text(_deleteHabit,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.publicSans(
                                            // fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Color.fromARGB(
                                                255, 218, 199, 198))),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
