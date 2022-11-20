import 'package:flutter/material.dart';
import 'package:kiwihabitapp/widgets/textFieldDecoration.dart';

class DefineYourHabit extends StatefulWidget {
  const DefineYourHabit({Key? key}) : super(key: key);

  @override
  State<DefineYourHabit> createState() => _DefineYourHabitState();
}

class _DefineYourHabitState extends State<DefineYourHabit> {
  var _habitName;
  var _category = "Health";
  final Color _yaziTipiRengi = Color(0xffE4EBDE);
  TextEditingController _turkceTextFieldController = TextEditingController();
  var habitName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(21, 9, 35, 1),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
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
                    child: Column(
                      children: [
                        Container(
                            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                            width: MediaQuery.of(context).size.width * 9 / 10,
                            child: TextFieldDecoration(
                              hintYazi: "Habit Name",
                              textfieldData: (newtextfieldData) {
                                _habitName = newtextfieldData;
                              },
                            )),
                        Container(
                          width:
                              MediaQuery.of(context).size.width * 9 / 10 - 20,
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(21, 9, 35, 1),
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                                isExpanded: true,
                                dropdownColor: Color.fromRGBO(21, 9, 35, 1),
                                value: _category,
                                items: <String>[
                                  'Health',
                                  'Sport',
                                  'Study',
                                  'Art',
                                  'Finance',
                                  'Social',
                                  'Quit a Bad Habit',
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Row(
                                      children: [
                                        new Text(
                                          value,
                                          style: TextStyle(
                                              color: _yaziTipiRengi,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        value == 'Health'
                                            ? Icon(
                                                Icons.volunteer_activism,
                                                size: 25,
                                                color: Color.fromARGB(
                                                    223, 218, 21, 7),
                                              )
                                            : value == 'Sport'
                                                ? Icon(
                                                    Icons.directions_run,
                                                    size: 25,
                                                    color: Color.fromARGB(
                                                        223, 18, 218, 7),
                                                  )
                                                : value == 'Study'
                                                    ? Icon(
                                                        Icons.school,
                                                        size: 25,
                                                        color: Color.fromARGB(
                                                            223, 124, 38, 223),
                                                      )
                                                    : value == 'Art'
                                                        ? Icon(
                                                            Icons.palette,
                                                            size: 25,
                                                            color:
                                                                Color.fromARGB(
                                                                    223,
                                                                    225,
                                                                    5,
                                                                    240),
                                                          )
                                                        : value == 'Finance'
                                                            ? Icon(
                                                                Icons
                                                                    .attach_money,
                                                                size: 25,
                                                                color: Color
                                                                    .fromARGB(
                                                                        223,
                                                                        12,
                                                                        162,
                                                                        7),
                                                              )
                                                            : value == 'Social'
                                                                ? Icon(
                                                                    Icons
                                                                        .nightlife,
                                                                    size: 25,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            223,
                                                                            232,
                                                                            118,
                                                                            18),
                                                                  )
                                                                : Icon(
                                                                    Icons
                                                                        .smoke_free,
                                                                    size: 25,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            223,
                                                                            19,
                                                                            153,
                                                                            243),
                                                                  )
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _category = value!;
                                  });
                                }),
                          ),
                        ),
                        RawMaterialButton(
                            fillColor: _yaziTipiRengi,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0))),
                            splashColor: Color(0xff867ae9),
                            textStyle: TextStyle(color: _yaziTipiRengi),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                              child: Text("Start to Schedule",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color.fromRGBO(21, 9, 35, 1),
                                    fontSize: 15,
                                    fontFamily: 'Times New Roman',
                                    // fontWeight: FontWeight.bold
                                  )),
                            ),
                            onPressed: () async {
                              print(_habitName);
                            }),
                      ],
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
          ],
        ),
      ),
    );
  }
}
