import 'package:flutter/material.dart';

class TextFieldDecoration extends StatefulWidget {
  ValueChanged<String> textfieldData;
  final String hintYazi;
  TextFieldDecoration({Key? key, required this.hintYazi, required this.textfieldData})
      : super(key: key);

  @override
  State<TextFieldDecoration> createState() => _TextFieldDecorationState();
}

class _TextFieldDecorationState extends State<TextFieldDecoration> {
  final Color _yaziTipiRengi = Color(0xffE4EBDE);
  TextEditingController _turkceTextFieldController = TextEditingController();
  var habitName;
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value2) {
        setState(() {
          // var someCapitalizedString = "someString".capitalize();
          widget.textfieldData(value2);
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
        hintText: widget.hintYazi,
        hintStyle: TextStyle(color: Color.fromARGB(75, 21, 9, 35)),
      ),
    );
  }
}
