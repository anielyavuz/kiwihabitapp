import 'package:flutter/material.dart';

class IconClass {
  getIconFromName(String _iconName, {double size = 32.00}) {
    Icon _returnIcon = Icon(
      Icons.volunteer_activism,
      size: size,
      color: Color.fromARGB(223, 218, 21, 7),
    );
    if (_iconName == 'Health') {
      _returnIcon = Icon(
        Icons.volunteer_activism,
        size: size,
        color: Color.fromARGB(223, 218, 21, 7),
      );
    } else if (_iconName == 'Sport') {
      _returnIcon = Icon(
        Icons.directions_run,
        size: size,
        color: Color.fromARGB(223, 18, 218, 7),
      );
    } else if (_iconName == 'Study') {
      _returnIcon = Icon(
        Icons.school,
        size: size,
        color: Color.fromARGB(223, 124, 38, 223),
      );
    } else if (_iconName == 'Art') {
      _returnIcon = Icon(
        Icons.palette,
        size: size,
        color: Color.fromARGB(223, 225, 5, 240),
      );
    } else if (_iconName == 'Finance') {
      _returnIcon = Icon(
        Icons.attach_money,
        size: size,
        color: Color.fromARGB(223, 12, 162, 7),
      );
    } else if (_iconName == 'Social') {
      _returnIcon = Icon(
        Icons.nightlife,
        size: 25,
        color: Color.fromARGB(223, 232, 118, 18),
      );
    } else
      () {
        _returnIcon = Icon(
          Icons.nightlife,
          size: size,
          color: Color.fromARGB(223, 19, 153, 243),
        );
      };

    return _returnIcon;
  }
}
