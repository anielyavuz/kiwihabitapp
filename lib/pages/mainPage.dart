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
  int _currentIndexCalendar = 0;

  final Color _yaziTipiRengi = Color(0xffE4EBDE);
  final Color _backgroudRengi = Color.fromRGBO(21, 9, 35, 1);
  PageController _pageController =
      PageController(viewportFraction: 1 / 7, initialPage: 20);
  List<DateTime> calculateDaysInterval(DateTime startDate, DateTime endDate) {
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    print(days);
    return days;
  }

  getCurrentChooseYourHabits() {
    setState(() {
      _yourHabits = box.get("chooseYourHabitsHive") ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    calculateDaysInterval(DateTime(2022, 11, 0), DateTime(2022, 12, 31));
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   Future.delayed(const Duration(milliseconds: 50), () {

    //   });
    // });

    box = Hive.box("kiwiHive");
    getCurrentChooseYourHabits();
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
              days[_currentIndexCalendar].toString() ==
                      DateFormat('yyyy-MM-dd 00:00:00.000')
                          .format(DateTime.now())
                          .toString()
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
              onPressed: () {
                // do something
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
                                _currentIndexCalendar = index;
                              }),
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                              days.length,
                              (index) => Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          // border: Border.all(
                                          //     color: Color.fromARGB(
                                          //         255, 212, 212, 212),width: 0.5),
                                          color: _currentIndexCalendar != index
                                              ? Color.fromARGB(255, 56, 24, 93)
                                              : Color.fromARGB(
                                                  255, 48, 135, 51),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 2, 0, 1),
                                            child: Text(
                                                days[index].day.toString(),
                                                style: TextStyle(
                                                  color: _yaziTipiRengi,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Times New Roman',
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
                                                          Radius.circular(10)),
                                                  color:
                                                      _currentIndexCalendar !=
                                                              index
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
                                  ))),
                    ),
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: InkWell(
                            onTap: () {
                              // print("AAAAAAAAAAAAAAAAAAAAAAAA");
                              // for (var item in _yourHabits) {
                              //   print(item['habitName'] + "   ---  ");
                              //   print(item['_allTimes']);
                              // }
                            },
                            child: Container(
                              child: Text(
                                  days[_currentIndexCalendar].toString() +
                                      " --- " +
                                      DateFormat('yyyy-MM-dd 00:00:00.000')
                                          .format(DateTime.now()),
                                  style: TextStyle(
                                    color: _yaziTipiRengi,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Times New Roman',
                                    // fontWeight: FontWeight.bold
                                  )),
                            )),
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
