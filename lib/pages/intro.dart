import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int _index = 0;
  List _introPages = ["Hoş geldiniz", "Merhaba", "Selam", "Naber"];
  final Color _yaziTipiRengi = Color(0xffE4EBDE);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xff150923),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                child: Center(
                    child: Text(
                  "KiWi - Habit App",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.philosopher(
                      fontSize: 32, color: _yaziTipiRengi),
                )),
              ),
            ),
            Expanded(
              flex: 5,
              child: PageView(
                  controller:
                      PageController(viewportFraction: 0.6, initialPage: 0),
                  onPageChanged: (int index) => setState(() => _index = index),
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                      _introPages.length,
                      (index) => Container(
                            width: 10,
                            height: 10,
                            color: Colors.amber,
                            child: Text(_introPages[_index],
                                style: TextStyle(
                                  color: _yaziTipiRengi,
                                  fontSize: 15,
                                  fontFamily: 'Times New Roman',
                                  // fontWeight: FontWeight.bold
                                )),
                          ))),
            ),
            Expanded(
              flex: 3,
              child: RawMaterialButton(
                  fillColor: Color(0xff542e71),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  splashColor: Color(0xff867ae9),
                  textStyle: TextStyle(color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: Text("Create Lobby",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Times New Roman',
                          // fontWeight: FontWeight.bold
                        )),
                  ),
                  onPressed: () {}),
            ),
            Expanded(
              flex: 5,
              child: Container(
                child: Center(
                    child: Text("Login",
                        style: TextStyle(
                          color: _yaziTipiRengi,
                          fontSize: 15,
                          fontFamily: 'Times New Roman',
                          // fontWeight: FontWeight.bold
                        ))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
