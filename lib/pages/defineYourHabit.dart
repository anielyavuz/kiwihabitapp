import 'package:flutter/material.dart';

class DefineYourHabit extends StatefulWidget {
  const DefineYourHabit({Key? key}) : super(key: key);

  @override
  State<DefineYourHabit> createState() => _DefineYourHabitState();
}

class _DefineYourHabitState extends State<DefineYourHabit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(21, 9, 35, 1),
      body: SafeArea(
        child: Container(
          child: Text(
            "Define Your Habits",
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
    );
  }
}
