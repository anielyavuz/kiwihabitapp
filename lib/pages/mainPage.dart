import 'dart:async';

import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kiwihabitapp/auth/authFunctions.dart';
import 'package:kiwihabitapp/auth/authentication.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Box box;
  List<DateTime> days = [];
  List _yourHabits = [];
  int _currentIndexCalendar =
      100; //initial page değeri değişirse bu değerde değişmeli

  final Color _yaziTipiRengi = Color(0xffE4EBDE);
  final Color _backgroudRengi = Color.fromRGBO(21, 9, 35, 1);
  List _currentDayHabit = [];
  Map _currentDayCompletedHabits = {};
  Map _finalCurrentDayCompletedHabits = {};
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

  getCurrentChooseYourHabits() async {
    _yourHabits = await box.get("chooseYourHabitsHive") ?? [];

    currentDayHabits();
  }

  returnFromCompletedHabitList(String _habitName) {
    setState(() {
      _finalCurrentDayCompletedHabits[DateFormat('dd MMMM yyyy')
              .format(days[_currentIndexCalendar])
              .toString()][_habitName]
          .removeLast();

      if (_finalCurrentDayCompletedHabits[DateFormat('dd MMMM yyyy')
                  .format(days[_currentIndexCalendar])
                  .toString()][_habitName]
              .length ==
          0) {
        print("İlgili listenin içi boş");
        _finalCurrentDayCompletedHabits[DateFormat('dd MMMM yyyy')
                .format(days[_currentIndexCalendar])
                .toString()]
            .removeWhere((key, value) =>
                key ==
                _habitName); //ilgili dizinin time alanı boş kaldığı için habit'i de silmek için kullanılır
      }
      print(_finalCurrentDayCompletedHabits[DateFormat('dd MMMM yyyy')
          .format(days[_currentIndexCalendar])
          .toString()][_habitName]);
    });
    recalculateListWithAnimation(); //
  }

  currentDayHabits() {
    // bu alan tamamalanan habit'in mevcut güne ait habitler ile kıyaslanmasını sağlar
    List _tamamlananHabitler = [];
    if (_finalCurrentDayCompletedHabits[DateFormat('dd MMMM yyyy')
            .format(days[_currentIndexCalendar])
            .toString()] !=
        null) {
      _tamamlananHabitler = _finalCurrentDayCompletedHabits[
              DateFormat('dd MMMM yyyy')
                  .format(days[_currentIndexCalendar])
                  .toString()]
          .keys
          .toList();
    }

    // bu alan tamamalanan habit'in mevcut güne ait habitler ile kıyaslanmasını sağlar

    setState(() {
      _currentDayHabit = [];

      _opacityAnimation = 1;
      for (var _yourHabit in _yourHabits)
      //alışkanlıklar list olarak tutuluyor. Onun içinde for döngüsü örn  [{habitName: GYM, habitCategory: Sport, _weekDays: [{day: 0, value: true}, {day: 1, value: true}, {day: 2, value: true}, {day: 3, value: true}, {day: 4, value: true}, {day: 5, value: false}, {day: 6, value: false}], _allTimes: [{time: TimeOfDay(12:30), notification: true, alarm: false}], _checkedBoxEveryday: false}]

      {
        if (!_tamamlananHabitler.contains(_yourHabit['habitName']))
        // bu alan tamamalanan habit'in mevcut güne ait habitler ile kıyaslanmasını sağlar
        {
          for (var _yourHabitDays in _yourHabit['_weekDays'])
          //tek alışkanlığın günleri 7 gün olarak true false şeklinde liste tutuluyor örn [{day: 0, value: true}, {day: 1, value: true}, {day: 2, value: true}, {day: 3, value: true}, {day: 4, value: true}, {day: 5, value: false}, {day: 6, value: false}]
          {
            if (_yourHabitDays['day'] ==
                ((DateTime.now().add(Duration(
                                days: _initialPage - _defaultinitialPage)))
                            .difference(DateTime(2000, 1, 3))
                            .inDays %
                        7)
                    .toString()) {
              if (_yourHabitDays['value']) {
                _currentDayHabit.add(_yourHabit);
                _opacityAnimation = 1;
                break;
              }
            }
          }
        }
      }
    });
    // print("AAa");
    // print(_currentDayHabit.length);
    // print(
    //     (DateTime.now().add(Duration(days: _initialPage - _defaultinitialPage)))
    //             .difference(DateTime(2000, 1, 3))
    //             .inDays %
    //         7);

    print("Final liste");
    print(_finalCurrentDayCompletedHabits);
  }

  Timer? timer;
  @override
  void initState() {
    super.initState();

    calculateDaysInterval(DateTime.now().subtract(Duration(days: _initialPage)),
        DateTime.now().add(Duration(days: _initialPage)));
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   Future.delayed(const Duration(milliseconds: 50), () {

    //   });
    // });

    box = Hive.box("kiwiHive");
    getCurrentChooseYourHabits();

    // timer = Timer.periodic(
    //     Duration(seconds: 10), (Timer t) => getCurrentChooseYourHabits());
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
                                    await _auth.signOut();

                                    var a = await _authService.signOut();
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
                                print(index);
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
                            // _pageController.animateToPage(_defaultinitialPage,
                            //     duration: Duration(milliseconds: 500),
                            //     curve: Curves.easeInCirc);
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
                                                _icons[_currentDayHabit[
                                                        indexOfCurrentDayHabit]
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
                                                              indexOfCurrentDayHabit]
                                                          ['habitName']),
                                                      Text("15:00")
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                    color: Colors.amber,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Text(
                                                    _currentDayHabit[
                                                                indexOfCurrentDayHabit]
                                                            ['_allTimes']
                                                        .length
                                                        .toString(),
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
                                        setState(() {
                                          //_currentDayCompletedHabits değişkeni tamamlanan habitler için geçici bir dizi oluşturur
                                          if (_currentDayCompletedHabits[
                                                  DateFormat('dd MMMM yyyy')
                                                      .format(days[
                                                          _currentIndexCalendar])
                                                      .toString()] ==
                                              null)

                                          //if fonksiyonu map'in boş olması durumunda hata almaması için null kontrolü yapar

                                          {
                                            _currentDayCompletedHabits[
                                                DateFormat('dd MMMM yyyy')
                                                    .format(days[
                                                        _currentIndexCalendar])
                                                    .toString()] = {};
                                          }

                                          if (_currentDayCompletedHabits[DateFormat(
                                                      'dd MMMM yyyy')
                                                  .format(days[
                                                      _currentIndexCalendar])
                                                  .toString()][_currentDayHabit[
                                                      indexOfCurrentDayHabit]
                                                  ['habitName']] ==
                                              null)
                                          //if fonksiyonu map'in boş olması durumunda hata almaması için null kontrolü yapar

                                          {
                                            _currentDayCompletedHabits[DateFormat(
                                                    'dd MMMM yyyy')
                                                .format(
                                                    days[_currentIndexCalendar])
                                                .toString()][_currentDayHabit[
                                                    indexOfCurrentDayHabit]
                                                ['habitName']] = [];
                                          }

                                          //_currentDayCompletedHabits dizini içerisine orjinal habit listten ilk zaman dilimi bütün olarak alınır örn: {29 November 2022: {Yoga: [{time: TimeOfDay(12:30), notification: true, alarm: false}]}}

                                          _currentDayCompletedHabits[
                                                      DateFormat('dd MMMM yyyy').format(days[_currentIndexCalendar]).toString()][
                                                  _currentDayHabit[indexOfCurrentDayHabit]
                                                      ['habitName']]
                                              .add(_currentDayHabit[indexOfCurrentDayHabit]
                                                  ['_allTimes'][_currentDayCompletedHabits[
                                                      DateFormat('dd MMMM yyyy')
                                                          .format(days[_currentIndexCalendar])
                                                          .toString()][_currentDayHabit[indexOfCurrentDayHabit]['habitName']]
                                                  .length]);

                                          if (_currentDayCompletedHabits[DateFormat(
                                                          'dd MMMM yyyy')
                                                      .format(days[
                                                          _currentIndexCalendar])
                                                      .toString()][_currentDayHabit[
                                                          indexOfCurrentDayHabit]
                                                      ['habitName']]
                                                  .length ==
                                              _currentDayHabit[
                                                          indexOfCurrentDayHabit]
                                                      ['_allTimes']
                                                  .length)

                                          //alttaki tamamlanan habitler ekranına yazmak için ilgili habitte tüm zaman dilimlerini ekleyip eklemediğini kontrol eden koşul. Eklediyse _finalCurrentDayCompletedHabits içine yazıp üsteki habit listi yenilerek yeniden dizilimi sağlar.
                                          {
                                            _finalCurrentDayCompletedHabits =
                                                _currentDayCompletedHabits;
                                            print("Ekleme bitti");

                                            _opacityAnimationDuration = 1;
                                            _opacityAnimation = 0;
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 250), () {
                                              _opacityAnimationDuration = 250;
                                              _opacityAnimation = 1;
                                              currentDayHabits();
                                            });
                                          } else {
                                            print("Daha ekleyeceğim");
                                          }
                                          // print(
                                          //     _finalCurrentDayCompletedHabits);
                                          // print(_currentDayCompletedHabits);

                                          // print(_currentDayCompletedHabits);
                                        });
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
                            itemCount: _finalCurrentDayCompletedHabits[
                                        DateFormat('dd MMMM yyyy')
                                            .format(days[_currentIndexCalendar])
                                            .toString()] !=
                                    null
                                ? _finalCurrentDayCompletedHabits[
                                        DateFormat('dd MMMM yyyy')
                                            .format(days[_currentIndexCalendar])
                                            .toString()]
                                    .keys
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
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(_finalCurrentDayCompletedHabits[
                                                              DateFormat(
                                                                      'dd MMMM yyyy')
                                                                  .format(days[
                                                                      _currentIndexCalendar])
                                                                  .toString()]
                                                          .keys
                                                          .toList()[indexOffinalCompletedHabit]),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                    color: Colors.amber,
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
                                            _finalCurrentDayCompletedHabits[
                                                        DateFormat(
                                                                'dd MMMM yyyy')
                                                            .format(days[
                                                                _currentIndexCalendar])
                                                            .toString()]
                                                    .keys
                                                    .toList()[
                                                indexOffinalCompletedHabit]); //tıklanan habit'in ismini return fonksiyonuna yollar
                                        print("Test");
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
