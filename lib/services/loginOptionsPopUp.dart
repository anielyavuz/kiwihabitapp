import 'dart:io';

import 'package:flutter/material.dart';

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
      actionsAlignment: MainAxisAlignment.center,
      title: Center(
        child: new Text(this._title!,
            style: TextStyle(
                color: Color.fromARGB(184, 24, 130, 18),
                fontSize: 25,
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.bold)),
      ),
      content: Text(
        "Choose your Sıgn In method",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: _yaziTipiRengi,
            fontSize: 12,
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.normal),
      ),
      backgroundColor: Color.fromARGB(255, 33, 15, 53),
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25)),
      actions: <Widget>[
        Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Visibility(
              visible: true,
              // Platform.isIOS,
              child: RawMaterialButton(
                constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width * 3 / 5,
                    minHeight: 40),
                fillColor: Color.fromARGB(255, 33, 15, 53),
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.all(Radius.circular(15.0)),
                //     side: BorderSide(color: Color.fromARGB(184, 24, 130, 18))),
                splashColor: Colors.transparent,
                textStyle: TextStyle(color: _yaziTipiRengi),
                child: Container(
                    // width: MediaQuery.of(context).size.width * 3 / 5,
                    height: 40,
                    child: Image(
                        // fit: BoxFit.fill,
                        image: AssetImage("assets/images/Apple.png"))),
                onPressed: () {
                  this._yesOnPressed!();
                },
              ),

              // InkWell(
              //   splashColor: Colors.transparent,
              //   highlightColor: Colors.transparent,
              //   child: Container(
              //     width: 90,
              //     height: 45,
              //     color: Color.fromARGB(255, 33, 15, 53),
              //     child: Padding(
              //       padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
              //       child: Center(
              //         child: Text(this._no!,
              //             style: TextStyle(
              //               shadows: [
              //                 Shadow(
              //                     color: Color.fromARGB(184, 24, 130, 18),
              //                     offset: Offset(0, -2))
              //               ],
              //               decorationColor: Color.fromARGB(184, 24, 130, 18),
              //               decoration: TextDecoration.underline,
              //               decorationThickness: 2,
              //               color: Colors.transparent,
              //               fontSize: 13,
              //               fontFamily: 'Times New Roman',
              //               // fontWeight: FontWeight.bold
              //             )),
              //       ),
              //     ),
              //   ),
              //   onTap: () {
              //     this._noOnPressed!();
              //   },
              // ),
            ),

            RawMaterialButton(
              constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 3 / 5,
                  minHeight: 40),
              fillColor: Color.fromARGB(255, 33, 15, 53),
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.all(Radius.circular(15.0)),
              //     side: BorderSide(color: Color.fromARGB(184, 24, 130, 18))),
              splashColor: Colors.transparent,
              textStyle: TextStyle(color: _yaziTipiRengi),
              child: Container(
                  // width: MediaQuery.of(context).size.width * 3 / 5,
                  height: 45,
                  child: Image(
                      // fit: BoxFit.fill,
                      image: AssetImage("assets/images/Google.png"))),
              onPressed: () {
                this._yesOnPressed!();
              },
            )

            // new FlatButton(
            //   child: new Text(this._yes,
            //       style: TextStyle(
            //           color: Colors.green,
            //           fontSize: 15,
            //           fontFamily: 'Times New Roman',
            //           fontWeight: FontWeight.bold)),
            //   textColor: Colors.green,
            //   onPressed: () {
            //     this._yesOnPressed();
            //   },
            // )

            ,

            // new FlatButton(
            //   child: Text(this._no,
            //       style: TextStyle(
            //           color: Colors.redAccent,
            //           fontSize: 15,
            //           fontFamily: 'Times New Roman',
            //           fontWeight: FontWeight.bold)),
            //   textColor: Colors.redAccent,
            //   onPressed: () {
            //     this._noOnPressed();
            //   },
            // )
          ],
        ),
      ],
    );
  }
}
