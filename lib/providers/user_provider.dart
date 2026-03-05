import 'package:flutter/material.dart';
import 'package:kiwihabitapp/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  void updateFromMap(Map<String, dynamic> data) {
    _user = UserModel.fromMap(data);
    notifyListeners();
  }

  void clear() {
    _user = null;
    notifyListeners();
  }
}
