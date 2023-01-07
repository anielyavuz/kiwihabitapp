import 'package:flutter/material.dart';

class BaseAlertDialog extends StatelessWidget {
  //When creating please recheck 'context' if there is an error!

  Color _color = Colors.white;

  String? _title;
  String? _content;
  String? _yes;
  String? _no;
  Function? _yesOnPressed;
  Function? _noOnPressed;

  BaseAlertDialog(
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
      title: Center(
        child: new Text(this._title!,
            style: TextStyle(
                color: Color(0xff185ADB),
                fontSize: 20,
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.bold)),
      ),
      content: new Text(this._content!,
          textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
      backgroundColor: this._color,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25)),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              // height: 25,
              // width: 25,
              child: RawMaterialButton(
                fillColor: Color(0xff66DE93),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                splashColor: Color(0xff66DE93),
                textStyle: TextStyle(color: Colors.white),
                child: Text(this._yes!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Times New Roman',
                      // fontWeight: FontWeight.bold
                    )),
                onPressed: () {
                  this._yesOnPressed!();
                },
              ),
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

            SizedBox(
              // height: 25,
              // width: 25,
              child: RawMaterialButton(
                fillColor: Color(0xffDA0037),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                splashColor: Color(0xffDA0037),
                textStyle: TextStyle(color: Colors.white),
                child: Text(this._no!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Times New Roman',
                      // fontWeight: FontWeight.bold
                    )),
                onPressed: () {
                  this._noOnPressed!();
                },
              ),
            )

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
