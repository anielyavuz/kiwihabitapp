import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kiwihabitapp/auth/authenticationStreamer.dart';
import 'package:kiwihabitapp/pages/chooseyourhabits.dart';
import 'package:kiwihabitapp/pages/intro.dart';
import 'package:kiwihabitapp/pages/mainPage.dart';
import 'package:provider/provider.dart';

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool _login = false;
  late User _user;
  rootControl() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        // print('User is signed in!');
        setState(() {
          _login = true;
        });
      }
      setState(() {
        _user = user!;
      });
    });
  }

  @override
  void initState() {
    rootControl();

    //LOGOYU BELLİ SURE GOSTEREN KOD BURASIYDI YORUMA ALINDI
//     Future.delayed(const Duration(milliseconds: 1500), () {
// // Here you can write your code
//     });
    // rootControl();
  }

  @override
  Widget build(BuildContext context) {
    return (_login)
        ? StreamProvider.value(
            value: DatabaseService(uid: _user.uid).people,
            initialData: null,
            child: DatabaseService(uid: _user.uid).people != null
                ? StreamProvider.value(
                    initialData: null,
                    value: DatabaseService2(uid: _user.uid).people,
                    child: DatabaseService2(uid: _user.uid).people != null
                        ? MainPage()
                        : Scaffold(
                            body: Container(
                                color: Colors.white,
                                child: Center(child: Text("Loading...")))),
                  )
                : Scaffold(
                    body: Container(
                        color: Colors.white,
                        child: Center(child: Text("Loading...")))),
          )

        // MainPage()
        : IntroPage();
  }
}
