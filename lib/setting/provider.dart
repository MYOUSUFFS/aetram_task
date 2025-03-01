import 'package:flutter/material.dart';

class ScreenProvider extends ChangeNotifier {
  bool _locationStatus = false;
  bool get locationStatus => _locationStatus;
  
  set locationStatus(bool value) {
    _locationStatus = value;
    notifyListeners();
  }

  int _screenIndex = 0;
  int get screenIndex => _screenIndex;

  void changeScreen(int index) {
    _screenIndex = index;
    notifyListeners();
  }

  String? _category;
  String? get category => _category;
  void changeCategory(String? value) {
    _category = value;
    notifyListeners();
  }
}
