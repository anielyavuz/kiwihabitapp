import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kiwihabitapp/auth/authFunctions.dart';
import 'package:kiwihabitapp/auth/authentication.dart';

class ChooseHabits extends StatefulWidget {
  const ChooseHabits({Key? key}) : super(key: key);

  @override
  State<ChooseHabits> createState() => _ChooseHabitsState();
}

class _ChooseHabitsState extends State<ChooseHabits> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () async {
            await _auth.signOut();

            var a = await _authService.signOut();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CheckAuth()));
          },
          child: Container(
            child: Text("Sign Out"),
          ),
        ),
      ),
    );
  }
}
