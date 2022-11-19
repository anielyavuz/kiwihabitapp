import 'package:flutter/material.dart';
import 'package:kiwihabitapp/widgets/textFieldDecoration.dart';

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
                    width: MediaQuery.of(context).size.width * 6 / 7,
                    child: TextFieldDecoration(
                      hintYazi: "Habit Name",
                    ))),
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
