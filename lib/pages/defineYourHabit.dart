import 'package:flutter/material.dart';

class DefineYourHabit extends StatefulWidget {
  const DefineYourHabit({Key? key}) : super(key: key);

  @override
  State<DefineYourHabit> createState() => _DefineYourHabitState();
}

class _DefineYourHabitState extends State<DefineYourHabit> {
  final Color _yaziTipiRengi = Color(0xffE4EBDE);
  TextEditingController _turkceTextFieldController = TextEditingController();
  var habitName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(21, 9, 35, 1),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Center(
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
            ),
            Expanded(
                flex: 7,
                child: Container(
                  width: MediaQuery.of(context).size.width*6/7,
                  child: TextField(
                    onChanged: (value2) {
                      setState(() {
                        // var someCapitalizedString = "someString".capitalize();
                        habitName = value2;
                      });
                    },
                    controller: _turkceTextFieldController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      isCollapsed: true,
                      filled: true,
                      fillColor: _yaziTipiRengi,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: Colors.green,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: Colors.purple,
                          width: 2.0,
                        ),
                      ),
                      hintText: "Habit Name",
                      hintStyle: TextStyle(color: Color.fromARGB(75, 21, 9, 35)),
                    ),
                  ),
                )),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {},
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border.all(color: _yaziTipiRengi),
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                            child: Text("Define Your Habit",
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
