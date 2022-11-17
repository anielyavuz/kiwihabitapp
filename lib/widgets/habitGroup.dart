import 'package:flutter/material.dart';

class HabitGroup extends StatefulWidget {
  final Color
      yaziTipiRengi; //Note: statefull'a parametre göndermek için gerekli
  final String butonYazi;
  const HabitGroup(
      {Key? key, required this.yaziTipiRengi, required this.butonYazi})
      : super(key: key);
  @override
  State<HabitGroup> createState() => _HabitGroupState();
}

class _HabitGroupState extends State<HabitGroup> {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        fillColor: widget.yaziTipiRengi,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        splashColor: Color(0xff867ae9),
        textStyle: TextStyle(color: widget.yaziTipiRengi),
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Text(widget.butonYazi,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(21, 9, 35, 1),
                fontSize: 15,
                fontFamily: 'Times New Roman',
                // fontWeight: FontWeight.bold
              )),
        ),
        onPressed: () async {});
  }
}
