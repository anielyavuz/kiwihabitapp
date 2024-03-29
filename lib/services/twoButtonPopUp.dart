import 'package:flutter/material.dart';

class BaseAlertDialog extends StatelessWidget {
  //When creating please recheck 'context' if there is an error!
  final Color _yaziTipiRengi = Color(0xffE4EBDE);
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
      title: Container(
        decoration: BoxDecoration(
          color: _yaziTipiRengi,
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Center(
          child: new Text(this._title!,
              style: TextStyle(
                  color: Color.fromRGBO(51, 21, 85, 1),
                  fontSize: 25,
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.bold)),
        ),
      ),
      content: new Text(this._content!,
          textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: _yaziTipiRengi)),
      backgroundColor: Color.fromRGBO(51, 21, 85, 1),
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25)),
      actions: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(
              width: 1,
              color: _yaziTipiRengi
            ))
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0,0,5,0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  child: Container(
                    width: 90,
                    height: 45,
                    color: Color.fromRGBO(51, 21, 85, 1),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0,2,0,0),
                      child: Center(
                        child: Text(this._no!,
                            style: TextStyle(
                              shadows: [
                        Shadow(
                            color: _yaziTipiRengi,
                            offset: Offset(0, -2))
                  ],
                              decorationColor: _yaziTipiRengi,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2,
                              color: Colors.transparent,
                              fontSize: 13,
                              fontFamily: 'Times New Roman',
                              // fontWeight: FontWeight.bold
                            )),
                      ),
                    ),
                    
                  ),
                  onTap: () {
                      this._noOnPressed!();
                    },
                ),
                RawMaterialButton(
                  fillColor: Color.fromARGB(255, 33, 15, 53),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      side: BorderSide(color: Color.fromARGB(184, 24, 130, 18),width: 0.5)),
                  splashColor: Colors.transparent,
                  textStyle: TextStyle(color: _yaziTipiRengi),
                  child: Text(this._yes!,
                      style: TextStyle(
                        color: _yaziTipiRengi,
                        fontSize: 15,
                        fontFamily: 'Times New Roman',
                        // fontWeight: FontWeight.bold
                      )),
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
          ),
        ),
      ],
    );
  }
}
