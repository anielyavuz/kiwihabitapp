import 'package:flutter/material.dart';

class IconClass {
  /// Returns an [Icon] for a given challenge [category] string.
  /// Uses a direct category-name lookup instead of index-based matching.
  Icon getIconForCategory(String category, {double size = 32.0}) {
    switch (category) {
      case 'Sport':
        return const Icon(Icons.directions_run, size: 32, color: Color.fromARGB(223, 18, 218, 7));
      case 'Health':
        return const Icon(Icons.favorite, size: 32, color: Color.fromARGB(223, 218, 21, 7));
      case 'Study':
        return const Icon(Icons.menu_book, size: 32, color: Color.fromARGB(223, 124, 38, 223));
      case 'Art':
        return const Icon(Icons.palette, size: 32, color: Color.fromARGB(223, 225, 5, 240));
      case 'Finance':
        return const Icon(Icons.account_balance_wallet, size: 32, color: Color.fromARGB(223, 12, 162, 7));
      case 'Social':
        return const Icon(Icons.people, size: 32, color: Color.fromARGB(223, 232, 118, 18));
      case 'Nutrition':
        return const Icon(Icons.restaurant, size: 32, color: Color.fromARGB(223, 200, 100, 30));
      case 'Mindfulness':
        return const Icon(Icons.self_improvement, size: 32, color: Color.fromARGB(223, 160, 80, 220));
      case 'Language':
        return const Icon(Icons.translate, size: 32, color: Color.fromARGB(223, 20, 160, 180));
      case 'Sleep':
        return const Icon(Icons.bedtime, size: 32, color: Color.fromARGB(223, 80, 80, 200));
      case 'Productivity':
        return const Icon(Icons.task_alt, size: 32, color: Color.fromARGB(223, 140, 100, 40));
      default:
        return const Icon(Icons.star, size: 32, color: Color.fromARGB(223, 19, 153, 243));
    }
  }

  /// Legacy index-based lookup retained for backward compatibility.
  getIconFromName(List _groupNames, String _iconName, {double size = 32.00}) {
    Icon _returnIcon = Icon(
      Icons.volunteer_activism,
      size: size,
      color: Color.fromARGB(223, 218, 21, 7),
    );
    if (_iconName == _groupNames[0]) {
      _returnIcon = Icon(
        Icons.volunteer_activism,
        size: size,
        color: Color.fromARGB(223, 218, 21, 7),
      );
    } else if (_iconName == _groupNames[1]) {
      _returnIcon = Icon(
        Icons.directions_run,
        size: size,
        color: Color.fromARGB(223, 18, 218, 7),
      );
    } else if (_iconName == _groupNames[2]) {
      _returnIcon = Icon(
        Icons.school,
        size: size,
        color: Color.fromARGB(223, 124, 38, 223),
      );
    } else if (_iconName == _groupNames[3]) {
      _returnIcon = Icon(
        Icons.palette,
        size: size,
        color: Color.fromARGB(223, 225, 5, 240),
      );
    } else if (_iconName == _groupNames[4]) {
      _returnIcon = Icon(
        Icons.attach_money,
        size: size,
        color: Color.fromARGB(223, 12, 162, 7),
      );
    } else if (_iconName == _groupNames[5]) {
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
