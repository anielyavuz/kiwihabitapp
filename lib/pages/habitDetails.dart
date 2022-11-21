import 'package:flutter/material.dart';

class HabitDetails extends StatefulWidget {
  const HabitDetails({Key? key}) : super(key: key);

  @override
  State<HabitDetails> createState() => _HabitDetailsState();
}

class _HabitDetailsState extends State<HabitDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(21, 9, 35, 1),
        body: SafeArea(
            child: Stack(children: [
          Column(
            children: [],
          ),
          Positioned(
            left: 5,
            child: Container(
              height: 40,
              child: IconButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 25,
                    color: Colors.white,
                  )),
            ),
          )
        ])));
  }
}
