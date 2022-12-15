import 'dart:async';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:kiwihabitapp/pages/bePremiumUser.dart';
import 'package:kiwihabitapp/services/iconClass.dart';
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

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _slidingCheckBoxEveryDay = true;
  List _sligingYourHabitAlltimes = [];
  List _slidingItemWeekDaysList = [];
  int _slidingCountADay = 1;
  Icon _slidingIcon = Icon(
    Icons.volunteer_activism,
    size: 25,
    color: Color.fromARGB(223, 218, 21, 7),
  );

  String _slidingHeaderText = "Drink Water";
  PanelController _pc = new PanelController();
  int _expand1 = 4;
  int _expand2 = 4;
  NotificationsServices notificationsServices = NotificationsServices();
  late Box box;
  List<DateTime> days = [];
  List _yourHabits = [];
  var _habitDays;
  var _habitDetails;
  int _currentIndexCalendar =
      100; //initial page değeri değişirse bu değerde değişmeli

  final Color _yaziTipiRengi = Color(0xffE4EBDE);
  final Color _backgroudRengi = Color.fromRGBO(21, 9, 35, 1);
  List _currentDayHabit = [];
  Map _currentDayCompletedHabits = {};

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
  final int _defaultinitialPage = 100;
  int _initialPage = 100; //initial page değeri değişirse bu değerde değişmeli
  PageController _pageController =
      PageController(viewportFraction: 1 / 7, initialPage: 100);
  List<DateTime> calculateDaysInterval(DateTime startDate, DateTime endDate) {
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }

    return days;
  }

  notificaitonMap() {
    notificationsServices.stopNotifications();
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
                        k,
                        _startTime.hour.toString() +
                            ":" +
                            _startTime.minute.toString(),
                        tzdatetime);
                  } else {
                    notificationsServices.sendScheduledNotifications2(
                        _notificationID,
                        k,
                        _startTime.hour.toString() +
                            ":0" +
                            _startTime.minute.toString(),
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

  getCurrentChooseYourHabits() async {
    _yourHabits = await box.get("chooseYourHabitsHive") ?? []; //eski

    _habitDetails = await box.get("habitDetailsHive") ?? [];
    _habitDays = await box.get("habitDays") ?? [];
    _completedHabits = await box.get("completedHabits") ?? {};

    _finalCompleted = await box.get("finalCompleted") ?? {};

    recalculateListWithAnimation();
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

    print("Final Map'e klonlanıyorr");
  }

  completedHabits(String _habitName, Map _time) {
    print('_completedHabits');
    print(_completedHabits);
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
      print("Map finale Klonlanıyorrr");

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

    // print('_completedHabits2');
    // print(_completedHabits);

    compareCurrentAndCompleted();
  }

  editSingleHabit(String slidingHeaderText) {
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

      _slidingHeaderText = slidingHeaderText;
    });

    _pc.open();
    // print("EDİTLE");
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
    // print('_habitDetails');
    // print(_habitDetails);

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
            print("Habitin tüm tekrarları bitti, kaldırılabilir");

            _willRemoveHabitNames.add(habitName);
            // print(_willRemoveHabitNames);
            //
          } else {
            print("Henüz bu habitte yapılacak tekrar var...");
          }
        }
      }
    }
    if (_willRemoveHabitNames.length != 0) {
      for (var _willRemoveHabitName in _willRemoveHabitNames) {
        setState(() {
          _currentDayHabit.removeWhere((item) => item == _willRemoveHabitName);
        });
        // print("$_willRemoveHabitName habitini kaldırıyorum.");
      }

      // recalculateListForCurrentListWithAnimation();
    }
  }

  currentDayHabits() {
    //habşt details {Swim: {habitCategory: Sport, _allTimes: [{time: TimeOfDay(12:30), notification: true, alarm: false}]}, Learn English: {habitCategory: Study, _allTimes: [{time: TimeOfDay(12:30), notification: true, alarm: false}]}, Painting: {habitCategory: Art, _allTimes: [{time: TimeOfDay(12:30), notification: true, alarm: false}]}}
    setState(() {
      _currentDayHabit = [];
      _habitDays.forEach((k, v) {
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
      });
    });
    compareCurrentAndCompleted();
    // print("_currentDayHabit");
    // print(_currentDayHabit);
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
      print('payload $payload');

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => BePremiumUser()));
    }
  }

  Timer? timer;
  @override
  void initState() {
    super.initState();

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
    getCurrentChooseYourHabits();
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
    AuthService _authService = AuthService();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return MaterialApp(
      home: Scaffold(
        drawer: Drawer(
            backgroundColor: _yaziTipiRengi,
            child: Container(
              child: Column(
                // Remove padding

                children: [
                  UserAccountsDrawerHeader(
                    accountName: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Today",
                            style: TextStyle(
                              color: _backgroudRengi,
                              // fontWeight: FontWeight.bold,
                              fontSize: 20,
                              // fontFamily: 'Times New Roman'
                            )),
                        Column(
                          children: [
                            Text(
                                DateFormat('EEEE')
                                    .format(DateTime.now())
                                    .toString(),
                                style: TextStyle(
                                  color: _backgroudRengi,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  // fontFamily: 'Times New Roman'
                                )),
                            Text(
                                DateFormat('dd MMMM yyyy')
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
                    child: SingleChildScrollView(
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              // ListTile(
                              //   leading: Icon(Icons.ice_skating),
                              //   title: InkWell(
                              //     onTap: () async {
                              //       // print(_yourHabits);

                              //       // notificaitonMap();
                              //     },
                              //     child: Container(
                              //       child: Text("Notifications Test",
                              //           style: TextStyle(
                              //             color: _backgroudRengi,
                              //             fontSize: 18,
                              //             fontWeight: FontWeight.bold,
                              //             fontFamily: 'Times New Roman',
                              //             // fontWeight: FontWeight.bold
                              //           )),
                              //     ),
                              //   ),
                              // ),

                              ListTile(
                                leading:
                                    Icon(Icons.notification_important_rounded),
                                title: InkWell(
                                  onTap: () async {
                                    // notificationsServices
                                    //     .specificTimeNotification(
                                    //         "KiWi🥝", "Yoga zamanı 💁", 0, 5);

                                    //////////BURASI ÖNEMLİ////////////
                                    notificationsServices.sendNotifications(
                                        "KiWi🥝", "Yoga zamanı 💁");

                                    // notificationsServices
                                    //     .sendPayloadNotifications(
                                    //         0,
                                    //         "KiWi🥝",
                                    //         "Premium ol 💁",
                                    //         "payload navigationnnnn");
                                    // DateTime dt = DateTime.now().add(Duration(
                                    //     seconds:
                                    //         5)); //Or whatever DateTime you want
                                    // var tzdatetime = tz.TZDateTime.from(dt,
                                    //     tz.local); //could be var instead of final
                                    // // notificationsServices
                                    // //     .sendScheduledNotifications2(
                                    // //         0, "Swim", "20:05", tzdatetime);
                                    // notificationsServices.stopNotifications();

                                    //////////BURASI ÖNEMLİ////////////
                                  },
                                  child: Container(
                                    child: Text("Notifications Test",
                                        style: TextStyle(
                                          color: _backgroudRengi,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Times New Roman',
                                          // fontWeight: FontWeight.bold
                                        )),
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: Icon(Icons.exit_to_app),
                                title: InkWell(
                                  onTap: () async {
                                    await _auth.signOut();

                                    var a = await _authService.signOut();

                                    box.put("chooseYourHabitsHive", []);
                                    box.put("habitDetailsHive", []);
                                    box.put("habitDays", []);
                                    box.put("completedHabits", {});
                                    box.put("finalCompleted", {});

                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                CheckAuth()),
                                        (Route<dynamic> route) => false);

                                    // Navigator.push(
                                    //     context, MaterialPageRoute(builder: (context) => CheckAuth()));
                                  },
                                  child: Container(
                                    child: Text("Çıkış",
                                        style: TextStyle(
                                          color: _backgroudRengi,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Times New Roman',
                                          // fontWeight: FontWeight.bold
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
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
                      (DateFormat('yyyy-MM-dd')
                          .format(DateTime.now())
                          .toString())
                  ? "Today"
                  : DateFormat('dd MMMM yyyy')
                      .format(days[_currentIndexCalendar])
                      .toString(),
              style: TextStyle(
                color: _yaziTipiRengi,
                // fontWeight: FontWeight.bold
              )),

          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.calendar_month,
                size: 30.00,
                color: _yaziTipiRengi,
              ),
              onPressed: () async {
                DateTime? _selectedDate = await showDatePicker(
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: _backgroudRengi, // header background color
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

                  _pageController.jumpToPage(_defaultinitialPage + _difference);
                  // _pageController.animateToPage(
                  //     _defaultinitialPage + _difference,
                  //     duration: Duration(milliseconds: 500),
                  //     curve: Curves.easeInCirc);
                }
              },
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
                    Container(
                      height: 54,
                      child: PageView(
                          controller: _pageController,
                          onPageChanged: (int index) => setState(() {
                                // print(index);
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
                                                  style: TextStyle(
                                                    color: _yaziTipiRengi,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        'Times New Roman',
                                                    // fontWeight: FontWeight.bold
                                                  )),
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
                                                        DateFormat('E')
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
                                                            ? TextStyle(
                                                                shadows: [
                                                                  Shadow(
                                                                      color:
                                                                          _yaziTipiRengi,
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              -2))
                                                                ],
                                                                color: Colors
                                                                    .transparent,
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                decorationThickness:
                                                                    3,
                                                                decorationColor:
                                                                    _yaziTipiRengi,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'Times New Roman',
                                                                // fontWeight: FontWeight.bold
                                                              )
                                                            : TextStyle(
                                                                color:
                                                                    _yaziTipiRengi,

                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'Times New Roman',
                                                                // fontWeight: FontWeight.bold
                                                              )),
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Visibility(
                        visible: _defaultinitialPage != _initialPage,
                        child: InkWell(
                          onTap: () async {
                            _pageController.jumpToPage(_defaultinitialPage);
                          },
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border.all(color: _yaziTipiRengi),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Center(
                                  child: Text("Back to Today",
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
                      ),
                    ),
                    Expanded(
                      child: Container(
                        // width:
                        //     MediaQuery.of(context).size.width *
                        //         3 /
                        //         5,
                        // height: 200,
                        // width: 50,

                        child: ListView.builder(
                            itemCount: _currentDayHabit.length,
                            itemBuilder: (context, indexOfCurrentDayHabit) {
                              // print(_kaydirmaNoktalari);
                              return AnimatedOpacity(
                                duration: Duration(
                                    milliseconds: _opacityAnimationDuration),
                                opacity: _opacityAnimation,
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: RawMaterialButton(
                                      // fillColor: _yaziTipiRengi,
                                      shape: RoundedRectangleBorder(
                                          side:
                                              BorderSide(color: _yaziTipiRengi),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0))),
                                      // splashColor: Colors.green,
                                      textStyle:
                                          TextStyle(color: _yaziTipiRengi),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 5, 15, 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                _icons[_habitDetails[
                                                        _currentDayHabit[
                                                            indexOfCurrentDayHabit]]
                                                    ['habitCategory']],
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          5, 0, 0, 0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(_currentDayHabit[
                                                          indexOfCurrentDayHabit]),
                                                      // Text(remainHabitTimeRepeat(
                                                      //         _currentDayHabit[
                                                      //             indexOfCurrentDayHabit])
                                                      //     .toString()),
                                                      Text(_habitDetails[_currentDayHabit[
                                                                      indexOfCurrentDayHabit]]
                                                                  ['_allTimes'][
                                                              remainHabitTimeRepeat(
                                                                  _currentDayHabit[
                                                                      indexOfCurrentDayHabit])]['time']
                                                          .split('(')[1]
                                                          .split(')')[0])
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            InkWell(
                                              onTap: () {
                                                // compareCurrentAndCompleted();
                                              },
                                              child: Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                    color: Colors.amber,
                                                    borderRadius:
                                                        BorderRadius.circular(
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
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: _backgroudRengi,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          'Times New Roman',
                                                      // fontWeight: FontWeight.bold
                                                    )),
                                              ),
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
                                      onPressed: !DateTime.parse(DateFormat(
                                                      'yyyy-MM-dd')
                                                  .format(days[
                                                      _currentIndexCalendar])
                                                  .toString())
                                              .isAfter(DateTime.parse(
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(DateTime.now())
                                                      .toString()))
                                          ? () {
                                              ////// Today veya önceki günlerde butona basılırsa çalışsın. Gelecek günlerde butona basılırsa çalışmasın çünkü henüz o günün habit'i yapılmadı.
                                              if (!DateTime.parse(DateFormat(
                                                          'yyyy-MM-dd')
                                                      .format(days[
                                                          _currentIndexCalendar])
                                                      .toString())
                                                  .isAfter(DateTime.parse(
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(
                                                              DateTime.now())
                                                          .toString()))) {
                                                if (_completedHabits[DateFormat(
                                                            'dd MMMM yyyy')
                                                        .format(days[
                                                            _currentIndexCalendar])
                                                        .toString()] !=
                                                    null) {
                                                  // print(_habitDetails[_currentDayHabit[
                                                  //         indexOfCurrentDayHabit]]
                                                  //     ['_allTimes'][_completedHabits[
                                                  //         DateFormat('dd MMMM yyyy')
                                                  //             .format(days[
                                                  //                 _currentIndexCalendar])
                                                  //             .toString()][_currentDayHabit[
                                                  //         indexOfCurrentDayHabit]]
                                                  //     .length]);

                                                  //ilginç sorun
                                                  if (_completedHabits[DateFormat(
                                                                  'dd MMMM yyyy')
                                                              .format(days[
                                                                  _currentIndexCalendar])
                                                              .toString()][
                                                          _currentDayHabit[
                                                              indexOfCurrentDayHabit]] !=
                                                      null) {
                                                    completedHabits(
                                                        _currentDayHabit[
                                                            indexOfCurrentDayHabit],
                                                        _habitDetails[
                                                                _currentDayHabit[
                                                                    indexOfCurrentDayHabit]]
                                                            [
                                                            '_allTimes'][_completedHabits[DateFormat(
                                                                        'dd MMMM yyyy')
                                                                    .format(days[
                                                                        _currentIndexCalendar])
                                                                    .toString()]
                                                                [
                                                                _currentDayHabit[
                                                                    indexOfCurrentDayHabit]]
                                                            .length]);
                                                  } else {
                                                    completedHabits(
                                                        _currentDayHabit[
                                                            indexOfCurrentDayHabit],
                                                        _habitDetails[
                                                                _currentDayHabit[
                                                                    indexOfCurrentDayHabit]]
                                                            ['_allTimes'][0]);
                                                  }
                                                } else {
                                                  print("null bir değerdi");
                                                  completedHabits(
                                                      _currentDayHabit[
                                                          indexOfCurrentDayHabit],
                                                      _habitDetails[
                                                              _currentDayHabit[
                                                                  indexOfCurrentDayHabit]]
                                                          ['_allTimes'][0]);
                                                }
                                              } else {
                                                print("yapma");
                                              }

///////////////////////**************/////////////////////// */
                                            }
                                          : null),
                                ),
                              );
                            }),
                      ),
                    ),
                    Container(
                      // width:
                      //     MediaQuery.of(context).size.width *
                      //         3 /
                      //         5,
                      // height: 200,
                      // width: 50,

                      child: ListView.builder(
                          itemCount: _finalCompleted[DateFormat('dd MMMM yyyy')
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
                                width: MediaQuery.of(context).size.width / 3,
                                child: RawMaterialButton(
                                    // fillColor: _yaziTipiRengi,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(color: _yaziTipiRengi),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0))),
                                    // splashColor: Colors.green,
                                    textStyle: TextStyle(color: _yaziTipiRengi),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 5, 15, 5),
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
                                                      CrossAxisAlignment.start,
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
                                            onTap: () {
                                              print(_currentDayCompletedHabits);
                                              print("****");
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
                                          .toList()[indexOffinalCompletedHabit]
                                          .toString());
                                    },
                                    onPressed: () {
                                      returnFromCompletedHabitList(_finalCompleted[
                                              DateFormat('dd MMMM yyyy')
                                                  .format(days[
                                                      _currentIndexCalendar])
                                                  .toString()]
                                          .keys
                                          .toList()[indexOffinalCompletedHabit]
                                          .toString());
                                    }),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
              SlidingUpPanel(
                // color: Color(0xff150923),
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
                              style: TextStyle(
                                color: _yaziTipiRengi,
                                fontSize: 18,
                                fontFamily: 'Times New Roman',
                                // fontWeight: FontWeight.bold
                              )),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          print(_yourHabits);
                        },
                        child: Icon(
                          Icons.edit,
                          size: 25,
                          color: Color.fromARGB(223, 130, 122, 121),
                        ),
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
                                            height: 20,
                                            width: 20,
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
                                                              });
                                                            }
                                                          }),
                                          ),
                                        ),
                                        Container(
                                          // width: 20,
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
                                              style: TextStyle(
                                                color: _yaziTipiRengi,
                                                fontSize: 25,
                                                fontFamily: 'Times New Roman',
                                                // fontWeight: FontWeight.bold
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            4,
                                            0,
                                            0,
                                            0,
                                          ),
                                          child: SizedBox(
                                            height: 20,
                                            width: 20,
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
                                                  });
                                                }),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text("in a day",
                                        style: TextStyle(
                                          color: _yaziTipiRengi,
                                          fontSize: 15,
                                          fontFamily: 'Times New Roman',
                                          // fontWeight: FontWeight.bold
                                        ))
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
                                            DateFormat('E').format(
                                                DateTime(2000, 1, 3).add(
                                                    Duration(
                                                        days: int.parse(
                                                            day['day'])))),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(21, 9, 35, 1),
                                              fontSize: 12,
                                              fontFamily: 'Times New Roman',
                                              // fontWeight: FontWeight.bold
                                            )),
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
                                    "Everyday",
                                    style: TextStyle(
                                      color: _yaziTipiRengi,
                                      fontSize: 15,
                                      fontFamily: 'Times New Roman',
                                    ),
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
                                                        "Goal " +
                                                            (index2 + 1)
                                                                .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                _yaziTipiRengi,
                                                            fontSize: 15)),
                                                    Row(
                                                      children: [
                                                        InkWell(
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
                                                          onTap: () async {
                                                            TimeOfDay? newTime = await showTimePicker(
                                                                context:
                                                                    context,
                                                                initialTime: TimeOfDay(
                                                                    hour: int.parse(
                                                                        _sligingYourHabitAlltimes[index2]['time'].split("(")[1].split(")")[0].split(":")[
                                                                            0]),
                                                                    minute: int.parse(_sligingYourHabitAlltimes[index2]
                                                                            [
                                                                            'time']
                                                                        .split("(")[
                                                                            1]
                                                                        .split(
                                                                            ")")[0]
                                                                        .split(":")[1])));
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
                                                                print(newTime);
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
                                                              style: TextStyle(
                                                                  color:
                                                                      _yaziTipiRengi,
                                                                  fontSize:
                                                                      25)),
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
