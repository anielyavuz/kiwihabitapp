import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kiwihabitapp/auth/authFunctions.dart';
import 'package:kiwihabitapp/auth/authentication.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Box box;
  List _yourHabits = [];
  getCurrentChooseYourHabits() {
    setState(() {
      _yourHabits = box.get("chooseYourHabitsHive") ?? [];
    });
  }

  @override
  void initState() {
    super.initState();

    box = Hive.box("kiwiHive");
    getCurrentChooseYourHabits();
  }

  @override
  Widget build(BuildContext context) {
    AuthService _authService = AuthService();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
              onTap: () {
                // print("AAAAAAAAAAAAAAAAAAAAAAAA");
                // for (var item in _yourHabits) {
                //   print(item['habitName'] + "   ---  ");
                //   print(item['_allTimes']);
                // }
              },
              child: Container(
                child: Text("Bilgileri çek"),
              )),
          InkWell(
            onTap: () async {
              await _auth.signOut();

              var a = await _authService.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => CheckAuth()),
                  (Route<dynamic> route) => false);

              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => CheckAuth()));
            },
            child: Container(
              child: Text("Çıkış"),
            ),
          ),
        ],
      )),
    );
  }
}
