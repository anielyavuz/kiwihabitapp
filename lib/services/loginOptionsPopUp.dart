import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginOptionsBaseAlertDialog extends StatelessWidget {
  //When creating please recheck 'context' if there is an error!
  final Color _yaziTipiRengi = Color(0xffE4EBDE);
  Color _color = Colors.white;

  String? _title;
  String? _content;
  String? _yes;
  String? _no;
  Function? _yesOnPressed;
  Function? _noOnPressed;

  LoginOptionsBaseAlertDialog(
      {Key? key,
      String? title,
      String? content,
      Function? yesOnPressed,
      Function? noOnPressed,
      String? yes = "Yes",
      String? no = "No"})
      : super(key: key) {
    this._title = title;
    this._content = content;
    this._yesOnPressed = yesOnPressed;
    this._noOnPressed = noOnPressed;
    this._yes = yes;
    this._no = no;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 20),
      actionsAlignment: MainAxisAlignment.center,
      title: Center(
        child: new Text(
          _title!,
          style: GoogleFonts.publicSans(fontSize: 22, color: _yaziTipiRengi),
        ),
      ),
      // content: Text(
      //   "Choose your Sıgn In method",
      //   textAlign: TextAlign.center,
      //   style: TextStyle(
      //       color: _yaziTipiRengi,
      //       fontSize: 12,
      //       fontFamily: 'Times New Roman',
      //       fontWeight: FontWeight.normal),
      // ),
      backgroundColor: Color.fromARGB(255, 31, 18, 57),
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25)),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: Platform.isIOS,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: RawMaterialButton(
                  constraints: BoxConstraints(minWidth: 55, minHeight: 55),
                  fillColor: _yaziTipiRengi,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    // side: BorderSide(color: Color.fromARGB(184, 24, 130, 18)

                    // )
                  ),
                  splashColor: Colors.transparent,
                  textStyle: TextStyle(color: _yaziTipiRengi),
                  child: Container(
                      // width: MediaQuery.of(context).size.width * 3 / 5,
                      height: 40,
                      child: Image(
                          // fit: BoxFit.fill,
                          image: AssetImage("assets/images/Apple.png"))),
                  onPressed: () {
                    this._noOnPressed!();
                  },
                ),
              ),
            ),
            RawMaterialButton(
              constraints: BoxConstraints(minWidth: 55, minHeight: 55),
              fillColor: _yaziTipiRengi,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                // side: BorderSide(color: Color.fromARGB(184, 24, 130, 18))
              ),
              splashColor: Colors.transparent,
              textStyle: TextStyle(color: _yaziTipiRengi),
              child: Container(
                  // width: MediaQuery.of(context).size.width * 3 / 5,
                  height: 40,
                  child: Image(
                      // fit: BoxFit.fill,
                      image: AssetImage("assets/images/Google.png"))),
              onPressed: () {
                this._yesOnPressed!();
              },
            ),
          ],
        ),
      ],
    );
  }
}
