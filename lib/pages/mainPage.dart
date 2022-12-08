import 'dart:async';
import 'package:flutter_timezone/flutter_timezone.dart';
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

  recalculateListWithAnimation() {
    _opacityAnimationDuration = 1;
    _opacityAnimation = 0;
    Future.delayed(const Duration(milliseconds: 250), () {
      _opacityAnimationDuration = 250;
      _opacityAnimation = 1;
      currentDayHabits();
    });
  }

  test() {
    print(_habitDays);
    // print(_habitDays);
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

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();

    final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }

  _timeZoneTriggerFunction() async {
    await _configureLocalTimeZone();
  }

  Timer? timer;
  @override
  void initState() {
    super.initState();
    _timeZoneTriggerFunction();
    // Future.delayed(const Duration(milliseconds: 250), () {

    // });

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
                              ListTile(
                                leading: Icon(Icons.exit_to_app),
                                title: InkWell(
                                  onTap: () async {
                                    notificationsServices
                                        .specificTimeNotification(
                                            "KiWi🥝", "Yoga zamanı 💁", 0, 5);

                                    // notificationsServices.ScheduleNotifications(
                                    //     'Schedule Title', 'Schedule Body');
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
                      flex: 4,
                      child: Container(
                        // width:
                        //     MediaQuery.of(context).size.width *
                        //         3 /
                        //         5,
                        height: 200,
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
                                                      Text(_habitDetails[
                                                                  _currentDayHabit[
                                                                      indexOfCurrentDayHabit]]
                                                              [
                                                              '_allTimes'][0]['time']
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
                                      onPressed: () {
                                        if (_completedHabits[DateFormat(
                                                    'dd MMMM yyyy')
                                                .format(
                                                    days[_currentIndexCalendar])
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
                                                _habitDetails[_currentDayHabit[
                                                        indexOfCurrentDayHabit]]
                                                    [
                                                    '_allTimes'][_completedHabits[
                                                        DateFormat(
                                                                'dd MMMM yyyy')
                                                            .format(days[
                                                                _currentIndexCalendar])
                                                            .toString()][_currentDayHabit[
                                                        indexOfCurrentDayHabit]]
                                                    .length]);
                                          } else {
                                            completedHabits(
                                                _currentDayHabit[
                                                    indexOfCurrentDayHabit],
                                                _habitDetails[_currentDayHabit[
                                                        indexOfCurrentDayHabit]]
                                                    ['_allTimes'][0]);
                                          }
                                        } else {
                                          print("null bir değerdi");
                                          completedHabits(
                                              _currentDayHabit[
                                                  indexOfCurrentDayHabit],
                                              _habitDetails[_currentDayHabit[
                                                      indexOfCurrentDayHabit]]
                                                  ['_allTimes'][0]);
                                        }
                                        // print(_habitDetails[_currentDayHabit[
                                        //             indexOfCurrentDayHabit]]
                                        //         ['_allTimes']
                                        //     .length
                                        //     .toString());

                                        // setState(() {
                                        //   //_currentDayCompletedHabits değişkeni tamamlanan habitler için geçici bir dizi oluşturur
                                        //   if (_currentDayCompletedHabits[
                                        //           DateFormat('dd MMMM yyyy')
                                        //               .format(days[
                                        //                   _currentIndexCalendar])
                                        //               .toString()] ==
                                        //       null)

                                        //   //if fonksiyonu map'in boş olması durumunda hata almaması için null kontrolü yapar

                                        //   {
                                        //     _currentDayCompletedHabits[
                                        //         DateFormat('dd MMMM yyyy')
                                        //             .format(days[
                                        //                 _currentIndexCalendar])
                                        //             .toString()] = {};
                                        //   }

                                        //   if (_currentDayCompletedHabits[DateFormat(
                                        //               'dd MMMM yyyy')
                                        //           .format(days[
                                        //               _currentIndexCalendar])
                                        //           .toString()][_currentDayHabit[
                                        //               indexOfCurrentDayHabit]
                                        //           ['habitName']] ==
                                        //       null)
                                        //   //if fonksiyonu map'in boş olması durumunda hata almaması için null kontrolü yapar

                                        //   {
                                        //     _currentDayCompletedHabits[DateFormat(
                                        //             'dd MMMM yyyy')
                                        //         .format(
                                        //             days[_currentIndexCalendar])
                                        //         .toString()][_currentDayHabit[
                                        //             indexOfCurrentDayHabit]
                                        //         ['habitName']] = [];
                                        //   }

                                        //   //_currentDayCompletedHabits dizini içerisine orjinal habit listten ilk zaman dilimi bütün olarak alınır örn: {29 November 2022: {Yoga: [{time: TimeOfDay(12:30), notification: true, alarm: false}]}}

                                        //   _currentDayCompletedHabits[
                                        //               DateFormat('dd MMMM yyyy').format(days[_currentIndexCalendar]).toString()][
                                        //           _currentDayHabit[indexOfCurrentDayHabit]
                                        //               ['habitName']]
                                        //       .add(_currentDayHabit[indexOfCurrentDayHabit]
                                        //           ['_allTimes'][_currentDayCompletedHabits[
                                        //               DateFormat('dd MMMM yyyy')
                                        //                   .format(days[_currentIndexCalendar])
                                        //                   .toString()][_currentDayHabit[indexOfCurrentDayHabit]['habitName']]
                                        //           .length]);

                                        //   if (_currentDayCompletedHabits[DateFormat(
                                        //                   'dd MMMM yyyy')
                                        //               .format(days[
                                        //                   _currentIndexCalendar])
                                        //               .toString()][_currentDayHabit[
                                        //                   indexOfCurrentDayHabit]
                                        //               ['habitName']]
                                        //           .length ==
                                        //       _currentDayHabit[
                                        //                   indexOfCurrentDayHabit]
                                        //               ['_allTimes']
                                        //           .length)

                                        //   //alttaki tamamlanan habitler ekranına yazmak için ilgili habitte tüm zaman dilimlerini ekleyip eklemediğini kontrol eden koşul. Eklediyse _finalCurrentDayCompletedHabits içine yazıp üsteki habit listi yenilerek yeniden dizilimi sağlar.
                                        //   {
                                        //     // _finalCurrentDayCompletedHabits =
                                        //     //     _currentDayCompletedHabits;

                                        //     _finalCurrentDayCompletedHabits =
                                        //         Map.from(
                                        //             _currentDayCompletedHabits);
                                        //     print("Ekleme bitti");

                                        //     _opacityAnimationDuration = 1;
                                        //     _opacityAnimation = 0;
                                        //     Future.delayed(
                                        //         const Duration(
                                        //             milliseconds: 250), () {
                                        //       _opacityAnimationDuration = 250;
                                        //       _opacityAnimation = 1;
                                        //       currentDayHabits();
                                        //     });
                                        //   } else {
                                        //     print("Daha ekleyeceğim");
                                        //   }
                                        //   // print(
                                        //   //     _finalCurrentDayCompletedHabits);
                                        //   // print(_currentDayCompletedHabits);

                                        //   // print(_currentDayCompletedHabits);
                                        // });
                                      }),
                                ),
                              );
                            }),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        // width:
                        //     MediaQuery.of(context).size.width *
                        //         3 /
                        //         5,
                        height: 200,
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
                                              onTap: () {
                                                print(
                                                    _currentDayCompletedHabits);
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
            ],
          ),
        ),
      ),
    );
  }
}
