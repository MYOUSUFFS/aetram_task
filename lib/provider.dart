import 'package:flutter/material.dart';

class ScreenProvider extends ChangeNotifier {
  int _screenIndex = 1;
  int get screenIndex => _screenIndex;

  void changeScreen(int index) {
    _screenIndex = index;
    notifyListeners();
  }
}
